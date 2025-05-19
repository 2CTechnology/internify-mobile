import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:simag_app/app/constant/url.dart';
import 'package:simag_app/app/data/db_provider.dart';

class CounselingFetcher {
  static Future<List<Map<String, dynamic>>> getJadwalBimbingan({
    required String token,
    required int userId,
  }) async {
    final String url = "${AppUrl.baseUrl}/jadwal-bimbingan";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        // HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    print("🛰 URL: $url");
    print("📡 Status Code: ${response.statusCode}");
    print("📄 Body: ${response.body}");

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final data = responseJson['data'];
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception("Format data tidak sesuai");
      }
    } else {
      throw Exception("Gagal fetch jadwal: ${response.body}");
    }
  }
}
