// ignore_for_file: unnecessary_overrides, avoid_print
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simag_app/app/constant/url.dart';
import 'package:simag_app/app/data/db_provider.dart';
import 'package:simag_app/app/modules/timeline/controllers/fetch_jobs_controller.dart';
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
      selectedFile.value = result.files.first;
    } else {
      print("Batal Pick File");
    }
  }

//hapus file
  void removeFile() {
    selectedFile.value = null;
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

        // removeFile();
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
   final FetchKelompokController fetchKelompok =
        Get.put(FetchKelompokController());
    await fetchKelompok.fetchKelompok();
    final idKelompok = fetchKelompok.kelompokModel.value.response.id;

    final url = Uri.parse('${AppUrl.baseUrl}/jadwal-bimbingan/$idKelompok');

    // final now = DateTime.now();

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      print("🛰 URL: $url");
      print("📡 Status Code: ${response.statusCode}");
      print("📄 Body: ${response.body}");
      print(idKelompok);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'] as List;

        upcomingSchedules.value = data
            .where((item) {
              final status = item["status"]?.toString().toLowerCase();
              return status == "pending";
            })
            .cast<Map<String, dynamic>>()
            .toList();

        pastSchedules.value = data
            .where((item) {
              final status = item["status"]?.toString().toLowerCase();
              return status == "selesai";
            })
            .cast<Map<String, dynamic>>()
            .toList();
      } else {
        Get.snackbar("Gagal", "Gagal mengambil jadwal bimbingan");
      }
    } catch (e) {
      print("Error mengambil jadwal: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
