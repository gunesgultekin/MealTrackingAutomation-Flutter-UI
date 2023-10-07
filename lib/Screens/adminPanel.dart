// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:indasyemek/Screens/createMenuPage.dart';
import 'package:indasyemek/Screens/updateMenuPage.dart';
import 'package:indasyemek/Screens/waitingPage.dart';
import 'package:indasyemek/Services/authService.dart';
import 'package:get/get.dart' hide Response;

import '../Services/foodService.dart';

class adminPanel extends StatefulWidget {
  adminPanel({super.key});

  @override
  State<adminPanel> createState() => _adminPanelState();
}

class _adminPanelState extends State<adminPanel> {
  foodService _foodService = foodService();

  TextEditingController corbaText = TextEditingController();
  TextEditingController yemek1Text = TextEditingController();
  TextEditingController yemek2Text = TextEditingController();
  TextEditingController mezeText = TextEditingController();
  TextEditingController tatliText = TextEditingController();

  Future<void> saveFoodList() async {
    await _foodService.saveFoodList(corbaText.text, yemek1Text.text,
        yemek2Text.text, mezeText.text, tatliText.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 23, 115, 190),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => updateMenuPage()))
                  },
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Icon(
                        Icons.edit_document,
                        color: Color.fromARGB(255, 12, 186, 175),
                        size: 30,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 30),
                      Expanded(
                        child: Text(
                          "Menüyü Güncelle",
                          style: TextStyle(
                            color: Color.fromARGB(255, 12, 186, 175),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => createMenuPage()))
                  },
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 21, 141, 25),
                        size: 40,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 30),
                      Expanded(
                        child: Text(
                          "Yeni Menü Ekle",
                          style: TextStyle(
                            color: Color.fromARGB(255, 21, 141, 25),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  onPressed: () => {Get.to(waitingPage())},
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Icon(
                        Icons.bar_chart,
                        color: Color.fromARGB(255, 119, 0, 255),
                        size: 30,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 30),
                      Expanded(
                        child: Text(
                          "Seçimleri Gör",
                          style: TextStyle(
                            color: Color.fromARGB(255, 119, 0, 255),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  onPressed: () => {
                    foodService().deleteAll(),
                  },
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 40,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 30),
                      Expanded(
                        child: Text(
                          "Menüyü Sil",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
