// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:indasyemek/Screens/loginScreen.dart';

class splashPage extends StatefulWidget {
  String jwtToken;
  splashPage({required this.jwtToken});

  @override
  State<splashPage> createState() => _splashPageState();
}

class _splashPageState extends State<splashPage> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => loginScreen()));
    });
    return Scaffold(
        body: Container(
      color: const Color.fromARGB(255, 23, 115, 190),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              height: MediaQuery.of(context).size.height / 50,
            ),
            SpinKitCubeGrid(
              color: Colors.white,
              size: 150,
            )
          ],
        ),
      ),
    ));
  }
}
