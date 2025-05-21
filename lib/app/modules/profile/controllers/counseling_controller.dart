// ignore_for_file: unnecessary_overrides, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simag_app/app/constant/url.dart';
import 'package:simag_app/app/data/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:simag_app/app/modules/profile/controllers/fetch_counseling.dart';

class CounselingController extends GetxController {
  final PageController pageController = PageController();

  var selectedIndex = 0.obs;
  var selectedFile = Rxn<PlatformFile>();

  //buat jadwal
  var upcomingSchedules = [].obs;
  var pastSchedules = [].obs;

  void setPage(int index) {
    pageController.jumpToPage(index);
    selectedIndex.value = index;
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  bool validate() {
    if (selectedFile.value == null) {
      return false;
    }
    return true;
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // PlatformFile file = result.files.first;
      selectedFile.value = result.files.first;
      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
    } else {
      print("Batal Pick File");
    }
  }

//hapus file
  void removeFile() {
    selectedFile.value = null;
    // controller.filepath = "";
    print("File terhapus");
  }

//upload laporan
  Future<void> uploadLaporan() async {
    if (selectedFile.value == null) {
      Get.snackbar("Gagal", "Silakan pilih file PDF terlebih dahulu");
      return;
    }

    final filePath = selectedFile.value!.path;
    if (filePath == null || filePath.isEmpty) {
      Get.snackbar("Error", "Path file tidak ditemukan");
      return;
    }

    final dbProvider = Get.find<DatabaseProvider>();
    final idKelompok = await dbProvider.getKelompokId();
    print("🧠 ID Kelompok: $idKelompok");
    final token = await dbProvider.getToken();
    final url = Uri.parse('${AppUrl.baseUrl}/post-laporan/$idKelompok');

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    //print token
    print("🔑 Token: $token");

    request.files.add(await http.MultipartFile.fromPath('laporan', filePath));

    print("🛰 URL: $url");

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      //tes respon
      print("📡 Status Code: ${response.statusCode}");
      print("📄 Body: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar("Sukses", "Laporan berhasil dikirim");
        removeFile();
      } else {
        Get.snackbar("Gagal", "Upload gagal (${response.statusCode})");
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }

// jadwal

  Future<void> fetchCounselingSchedule(DatabaseProvider dbProvider) async {
    final token = await dbProvider.getToken();
    final userId = await dbProvider.getIdUser();
    final now = DateTime.now();

    try {
      final data = await CounselingFetcher.getJadwalBimbingan(
        token: token,
        userId: userId,
      );

      upcomingSchedules.value = data
          .where((item) {
            final jadwalStr = item["jadwal"];
            if (jadwalStr == null) return false;

            final jadwal = DateTime.tryParse(jadwalStr);
            return jadwal != null && jadwal.isAfter(DateTime.now());
          })
          .cast<Map<String, dynamic>>()
          .toList();

      pastSchedules.value = data
          .where((item) {
            final jadwalStr = item["jadwal"];
            if (jadwalStr == null) return false;

            final jadwal = DateTime.tryParse(jadwalStr);
            return jadwal != null && jadwal.isBefore(DateTime.now());
          })
          .cast<Map<String, dynamic>>()
          .toList();
    } catch (e) {
      print("Error mengambil jadwal: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
  // bool _isLoading = false;
  // String _resMessage = "";
  // Map<String, dynamic> _counselingData = {};

  // bool get isLoading => _isLoading;
  // String get resMessage => _resMessage;
  // Map<String, dynamic> get counselingData => _counselingData;

  // void _setLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }

  // Future<void> getCounselingData({
  //   required int userId,
  //   required String token,
  // }) async {
  //   _setLoading(true);

  //   String url = "$requestBaseUrl/get-counseling";
  //   final body = {"id_user": userId};

  //   try {
  //     http.Response response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: json.encode(body),
  //     );

  //     if (response.statusCode == 200) {
  //       final res = json.decode(response.body);
  //       _counselingData = res["response"];
  //       _resMessage = "Success";
  //     } else {
  //       final res = json.decode(response.body);
  //       _resMessage = res["message"];
  //     }
  //   } on SocketException catch (_) {
  //     _resMessage = "Internet connection is not available";
  //   } catch (e) {
  //     _resMessage = "Please try again";
  //     print(e);
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  // void clearData() {
  //   _counselingData = {};
  //   _resMessage = "";
  //   notifyListeners();
  // }

