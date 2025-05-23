// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simag_app/app/constant/url.dart';
import 'package:simag_app/app/data/db_provider.dart';
import 'package:simag_app/app/modules/timeline/controllers/fetch_jobs_controller.dart';
import 'package:simag_app/app/modules/timeline/controllers/post_jobs_controller.dart';

class TimelineController extends GetxController {
  var selectedFile = Rxn<PlatformFile>();
  final PostJobsController controller = PostJobsController();

  // Di TimelineController atau FetchAlurMagangController
  final FetchKelompokController fetchKelompokController = Get.put(FetchKelompokController());
  final FetchAlurMagangController fetchAlurMagangController = Get.put(FetchAlurMagangController());
  var anggotaList = [].obs;

  @override
  void onReady() {
    super.onReady();
    fetchTimelineData(); // Fetch data setiap kali controller siap
  }

  Future<void> fetchTimelineData() async {
    try {
      if (!Get.isRegistered<FetchKelompokController>()) {
        Get.put(FetchKelompokController());
      }
      await fetchKelompokController.fetchKelompok();
      anggotaList.value = fetchKelompokController.kelompokModel.value.response.anggota;
      
      if (!Get.isRegistered<FetchAlurMagangController>()) {
        Get.put(FetchAlurMagangController());
      }
      await fetchAlurMagangController.fetchAlurMagang()
        .then((_) => print("✅ AlurMagang fetched ctrl"))
        .catchError((e) => print("❌ Error fetching alur magang: $e"));
    } catch (e) {
      print("❌ Error in fetchTimelineData: $e");
    Get.snackbar(
      "Error",
      "Failed to load timeline data",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 2),
    );
    }
  }

  bool validate() {
    if (selectedFile.value == null) {
      return false;
    }
    return true;
  }

  Rx<File?> selectedProposalFile = Rx<File?>(null);
  Rx<File?> selectedReplyLetterFile = Rx<File?>(null);

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

  void pickReplyLetterFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      selectedReplyLetterFile.value = File(result.files.single.path!);
      print("✅ Reply letter selected: ${selectedReplyLetterFile.value!.path}");
    } else {
      print("❌ Cancelled picking reply letter");
    }
  }

  void pickProposalFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      selectedProposalFile.value = File(result.files.single.path!);
      print("✅ Proposal file selected: ${selectedProposalFile.value!.path}");
    } else {
      print("❌ Cancelled picking proposal file");
    }
  }

  void clearProposalFile() {
    selectedProposalFile.value = null;
    controller.filepath = "";
    print("File proposal terhapus");
  }

  void clearReplyLetterFile() {
    selectedReplyLetterFile.value = null;
    controller.filepath = "";
    print("File surat balasan terhapus");
  }

  Future<void> downloadFile() async {
    //gettoken
    final requestBaseUrl = AppUrl.baseUrl;
    final dbProvider = Get.put(DatabaseProvider());
    final token = await dbProvider.getToken();

    //get id kelompok
    final FetchKelompokController fetchKelompok =
        Get.put(FetchKelompokController());
    await fetchKelompok.fetchKelompok();
    final idKelompok = fetchKelompok.kelompokModel.value.response.id;
    print(idKelompok);

    final url = Uri.parse('$requestBaseUrl/download-surat-pelaksanaan');
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String savePath = '${appDocDir.path}/surat-pelaksanaan.pdf';

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/pdf',
          'Authorization': 'Bearer $token',
        },
        body: {
          'id_kelompok': idKelompok.toString(),
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded and saved to $savePath');
      } else {
        print(response.body);
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Download error: $e');
    }
  }
}
