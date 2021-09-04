import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  final webAPIKey = dotenv.env['WEB_API_KEY']!;
  final signUpURL =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=";
  final signInURL =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=";

  bool get isAutheticated {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _postToFireBase(
      String url, String? email, String? password) async {
    try {
      final uri = Uri.parse(url + webAPIKey);
      final resp = await post(uri,
          body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true},
          ));
      final respData = json.decode(resp.body);
      if (respData['error'] != null) {
        throw HttpException(respData['error']['message']);
      }
      _token = respData["idToken"];
      _userId = respData["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(respData["expiresIn"])));
      notifyListeners();
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String? email, String? password) async {
    return _postToFireBase(signUpURL, email, password);
  }

  Future<void> signin(String? email, String? password) async {
    return _postToFireBase(signInURL, email, password);
  }
}
