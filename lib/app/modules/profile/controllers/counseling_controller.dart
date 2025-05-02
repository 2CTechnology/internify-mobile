// ignore_for_file: unnecessary_overrides, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simag_app/app/constant/url.dart';

class CounselingController extends ChangeNotifier {
  final String requestBaseUrl = AppUrl.baseUrl;

  bool _isLoading = false;
  String _resMessage = "";
  Map<String, dynamic> _counselingData = {};

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  Map<String, dynamic> get counselingData => _counselingData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getCounselingData({
    required int userId,
    required String token,
  }) async {
    _setLoading(true);

    String url = "$requestBaseUrl/get-counseling";
    final body = {"id_user": userId};

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        _counselingData = res["response"];
        _resMessage = "Success";
      } else {
        final res = json.decode(response.body);
        _resMessage = res["message"];
      }
    } on SocketException catch (_) {
      _resMessage = "Internet connection is not available";
    } catch (e) {
      _resMessage = "Please try again";
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  void clearData() {
    _counselingData = {};
    _resMessage = "";
    notifyListeners();
  }
}
