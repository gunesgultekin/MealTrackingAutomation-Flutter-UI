// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_catch_clause, empty_catches

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indasyemek/Screens/adminPanel.dart';

import 'package:indasyemek/Screens/userWaitScreen.dart';
import 'package:indasyemek/Services/authService.dart';
import 'package:indasyemek/Services/notificationService.dart';
import 'package:indasyemek/authorization.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginScreen extends StatefulWidget {
  static late String Token;
  @override
  State<loginScreen> createState() => loginScreenState();
}

class loginScreenState extends State<loginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? message = " ";
  bool warning = false;

  Future<String?> saveDeviceToken() async {
    String? deviceToken = '@';

    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print('could not get token');
      print(e.toString());
    }
    if (deviceToken != null) {
      //print("--------------Device Token--------------" + deviceToken);
      await _notificationService.saveDevice(_emailController.text, deviceToken);
    }
    return deviceToken;
  }

  notificationService _notificationService = notificationService();

  Future<void> signIn() async {
    try {
      String role = await authService()
          .signIn(_emailController.text, _passwordController.text);
      if (role == "admin") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => adminPanel()));
      } else {
        saveDeviceToken();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => userWaitScreen(
                  email: _emailController.text,
                )));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        warning = true;
        message = e.message;
      });
    }
  }

  Future<void> login(String username, String password) async {
    try {
      String response = await authService().login(username, password);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("token", response);

      Map<String, dynamic> decodedToken = JwtDecoder.decode(response);
      saveDeviceToken();
      if (decodedToken["role"] == 'admin') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => adminPanel()));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => userWaitScreen(
                  email: _emailController.text,
                )));
      }
    } catch (e) {
      setState(() {
        warning = true;
        message = "Sunucu Hatası (!) Lütfen yetkiliye danışınız.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 23, 115, 190),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 15,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                    "Assets/logo.png",
                  ))),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Text(
                  "İndas Yemek Takip",
                  style: TextStyle(color: Colors.white, fontSize: 17.5),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Visibility(
                  visible: warning,
                  child: Icon(
                    Icons.warning_sharp,
                    color: Color.fromARGB(255, 219, 13, 13),
                    size: 60,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Text(
                  message!,
                  style: TextStyle(
                      color: Color.fromARGB(255, 4, 0, 0), fontSize: 13),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: Color.fromARGB(255, 235, 235, 235),
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 20,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Kullanıcı Adı",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 141, 141, 141),
                            fontSize: 14.5),
                      ),
                      controller: _emailController,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: Color.fromARGB(255, 235, 235, 235),
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 20,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Şifre",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 141, 141, 141),
                        ),
                      ),
                      controller: _passwordController,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 15,
                  child: ElevatedButton(
                      onPressed: () => {
                            login(
                                _emailController.text, _passwordController.text)
                          },
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt_outlined,
                            color: Colors.blue,
                            size: 25,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 75,
                          ),
                          Text(
                            "Giriş Yap",
                            style:
                                TextStyle(color: Colors.blue, fontSize: 22.5),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
