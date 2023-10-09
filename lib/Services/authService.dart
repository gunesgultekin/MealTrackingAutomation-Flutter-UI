import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Authorization.dart';

class authService {
  String adminUUID = "---";

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  final _firebaseNotification = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseNotification.requestPermission();
  }

  Future<String> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (_firebaseAuth.currentUser != null) {
      if (_firebaseAuth.currentUser!.uid == adminUUID) {
        return "admin";
      } else {
        return "user";
      }
    }
    return "error";
  }

  Future<String> login(String username, String password) async {
    var url = Uri.parse(
        "https://10.0.2.2:7239/userTable/loginAuth?username=${username}&password=${password}");
    var response = await http.get(url);
    return response.body;
  }
}
