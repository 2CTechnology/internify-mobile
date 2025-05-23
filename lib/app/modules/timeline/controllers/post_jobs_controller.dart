// ignore_for_file: avoid_print

import 'dart:io';
import 'package:get/get.dart';
import 'package:simag_app/app/constant/url.dart';
import 'package:simag_app/app/data/db_provider.dart';
import 'package:http/http.dart' as http;
import 'package:simag_app/app/modules/timeline/controllers/fetch_jobs_controller.dart';
import 'package:simag_app/app/routes/app_pages.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PostJobsController extends GetxController {
  var tempatMagang = '';
  var posisiMagang = '';
  var filepath = "";

  Future<void> postProposal() async {
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

    try {
      //post tempat magang
      final urlTempatMagang =
          Uri.parse('$requestBaseUrl/insert-tempat-magang/$idKelompok');

      final responseTempatMagang = await http.post(
        urlTempatMagang,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'tempat_magang': tempatMagang,
          'nama_posisi': posisiMagang,
        },
      );
      print('Tempat Magang Response: ${responseTempatMagang.body}');

      //post proposal
      final urlProposal =
          Uri.parse('$requestBaseUrl/upload-proposal/$idKelompok');
      var requestProposal = http.MultipartRequest('POST', urlProposal);
      requestProposal.fields['id'] = idKelompok.toString();
      requestProposal.files
          .add(await http.MultipartFile.fromPath('proposal', filepath));
      requestProposal.headers['Authorization'] = 'Bearer $token';
      requestProposal.headers['Accept'] = 'application/json';

      final streamedResponse = await requestProposal.send();
      final responseProposal = await http.Response.fromStream(streamedResponse);

      if (responseProposal.statusCode == 200 &&
          responseTempatMagang.statusCode == 200) {
        print('Response: ${responseProposal.body}');
        // print('Response: ${responseTempatMagang.body}');
        // print('Response: ${responseDospem.body}');
        await Get.put(FetchAlurMagangController()).fetchAlurMagang();
        Get.offAllNamed(Routes.NAVIGATION_BAR);
      } else {
        print('Failed to upload proposal: ${responseProposal.statusCode}');
        print('Response: ${responseProposal.body}');
        print(
            'Failed to insert tempat magang: ${responseTempatMagang.statusCode}');
        print('Response: ${responseTempatMagang.body}');
        // print('Failed to insert dospem: ${responseDospem.statusCode}');
        // print('Response: ${responseDospem.body}');
      }
    } catch (error) {
      print('Error uploading alur magang: $error');
    }
  }

  Future<void> postResponseLetter() async {
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

    // Validasi file
    final filePath = filepath;
    if (filePath == null || !File(filePath).existsSync()) {
      print("File tidak ditemukan atau tidak valid");
      return;
    }

    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final mimeSplit = mimeType.split('/');

    try {
      //post letter
      final urlLetter = Uri.parse('$requestBaseUrl/upload-surat-balasan/$idKelompok');
      final requestLetter = http.MultipartRequest('POST', urlLetter);
      // requestLetter.fields['id'] = idKelompok.toString();

      requestLetter.files.add(await http.MultipartFile.fromPath(
          'surat_balasan',
          filepath,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );
      
      requestLetter.headers['Authorization'] = 'Bearer $token';
      requestLetter.headers['Accept'] = 'application/json';

      final streamedResponse = await requestLetter.send();
      final responseLetter = await http.Response.fromStream(streamedResponse);

      if (responseLetter.statusCode == 200) {
        print('Response: ${responseLetter.body}');
        Get.offAllNamed(Routes.NAVIGATION_BAR);
      } else {
        print('Failed to upload letter: ${responseLetter.statusCode}');
        print('Response: ${responseLetter.body}');
      }
    } catch (e) {
      print('Error uploading response letter: $e');
    }
  }

  Future<void> postRevisi() async {
    //gettoken
    final requestBaseUrl = AppUrl.baseUrl;
    final dbProvider = Get.put(DatabaseProvider());
    final token = await dbProvider.getToken();

    //get id kelompok
    final fetchKelompok = Get.put(FetchKelompokController());
    await fetchKelompok.fetchKelompok();
    final idKelompok = fetchKelompok.kelompokModel.value.response.id;
    print(idKelompok);

    try {
      //post revised proposal
      final urlProposal =
          Uri.parse('$requestBaseUrl/upload-revisi-proposal/$idKelompok');

      var requestProposal = http.MultipartRequest('POST', urlProposal);
      requestProposal.fields['id'] = idKelompok.toString();
      requestProposal.files
          .add(await http.MultipartFile.fromPath('proposal', filepath));
      requestProposal.headers['Authorization'] = 'Bearer $token';
      requestProposal.headers['Accept'] = 'application/json';
      final streamedResponse = await requestProposal.send();
      final responseProposal = await http.Response.fromStream(streamedResponse);

      if (responseProposal.statusCode == 200) {
        print('Response: ${responseProposal.body}');
        await Get.put(FetchAlurMagangController()).fetchAlurMagang();
        Get.offAllNamed(Routes.NAVIGATION_BAR);
      } else {
        print('Failed to upload letter: ${responseProposal.statusCode}');
        print('Response: ${responseProposal.body}');
      }
    } catch (e) {
      print('Error uploading response letter: $e');
    }
  }
}
