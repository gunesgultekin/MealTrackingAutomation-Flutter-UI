import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:indasyemek/Screens/adminPanel.dart';
import 'package:indasyemek/Screens/loginScreen.dart';
import 'package:indasyemek/Screens/userWaitScreen.dart';
import 'package:indasyemek/Screens/waitingPage.dart';
import 'package:indasyemek/authorization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class foodService {
  Future<void> saveFoodList(String corba, String yemek1, String yemek2,
      String meze, String tatli) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("token");
      var url = Uri.parse(
          "https://10.0.2.2:7239/yemekListesi/addToDb?corba=${corba}&yemek1=${yemek1}&yemek2=${yemek2}&meze=${meze}&tatli=${tatli}");
      //"http://yemek.omeryilmaz.info/yemekListesi/addToDb?corba=${corba}&yemek1=${yemek1}&yemek2=${yemek2}&meze=${meze}&tatli=${tatli}");
      var response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      });
      print(response.body);

      Get.dialog(
        AlertDialog(
          icon: Icon(Icons.task_alt_outlined, color: Colors.white, size: 35),
          title: Text(
            "Yemek listesi kaydedildi",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          backgroundColor: Colors.green,
          actions: [
            Center(
              child: TextButton(
                child: Text(
                  "Devam et",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                onPressed: () => {Get.to(adminPanel())},
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.dialog(AlertDialog(
        icon: Icon(Icons.warning, color: Colors.white, size: 35),
        title: Text(
          "Sunucu hatası: Lütfen yetkiliye danışınız ! \n\n Hata kodu: ${e}",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<bool> checkDb() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    var url = Uri.parse("https://10.0.2.2:7239/yemekListesi/checkDb");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    });
    String responseData = response.body;
    return bool.parse(responseData);
  }

  Future<http.Response> getFoodList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    var url = Uri.parse("https://10.0.2.2:7239/yemekListesi/GetAll");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    });
    return response;
  }

  Future<void> saveSelection(String email, String corba, String yemek1,
      String yemek2, String meze, String tatli) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("token");
      var url = Uri.parse(
          "https://10.0.2.2:7239/istekListesi/addToDb?email=${email}&corba=${corba}&yemek1=${yemek1}&yemek2=${yemek2}&meze=${meze}&tatli=${tatli}");
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      });
      Get.dialog(
        AlertDialog(
          icon: Icon(Icons.task_alt_outlined, color: Colors.white, size: 35),
          title: Text(
            "Yemek tercihiniz kaydedildi",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          backgroundColor: Colors.green,
          actions: [
            Center(
              child: TextButton(
                child: Text(
                  "Devam et",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                onPressed: () => {Get.to(loginScreen())},
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response> getWishList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    var url = Uri.parse("https://10.0.2.2:7239/istekListesi/GetAll");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    });
    return response;
  }

  Future<void> deleteAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    var url = Uri.parse("https://10.0.2.2:7239/yemekListesi/deleteAll");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    });
    Get.dialog(
      AlertDialog(
        icon: Icon(Icons.task_alt_outlined, color: Colors.white, size: 35),
        title: Text(
          "Yemek listesi silindi",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        actions: [
          Center(
            child: TextButton(
                child: Text(
                  "Devam et",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                onPressed: () =>
                    {Get.to(adminPanel(), preventDuplicates: false)}),
          ),
        ],
      ),
    );
  }
}
