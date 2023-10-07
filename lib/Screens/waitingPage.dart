// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:indasyemek/Screens/createMenuPage.dart';
import 'package:indasyemek/Services/foodService.dart';

class waitingPage extends StatefulWidget {
  const waitingPage({super.key});

  @override
  State<waitingPage> createState() => _waitingPageState();
}

class _waitingPageState extends State<waitingPage> {
  late var currentResponse;
  late Future _future;
  late Future _future1;
  foodService _foodService = foodService();
  late List<DataRow> dataRows = [];

  late bool isMenuAdded;

  Future<void> checkIsMenuAdded() async {
    isMenuAdded = await foodService().checkDb();
  }

  Future<void> getWishList() async {
    Response response = await _foodService.getWishList();
    String responseData = response.body;
    currentResponse = jsonDecode(responseData)["desc"];
    for (int i = 0; i < currentResponse.length; ++i) {
      dataRows.add(DataRow(cells: [
        DataCell(
            Text((currentResponse[i]["email"].toString().split("@").first))),
        DataCell(
          currentResponse[i]["corba"] == "true"
              ? Icon(Icons.task_sharp, color: Colors.green)
              : Icon(Icons.cancel, color: Colors.red),
        ),
        DataCell(
          currentResponse[i]["yemek1"] == "true"
              ? Icon(Icons.task_sharp, color: Colors.green)
              : Icon(Icons.cancel, color: Colors.red),
        ),
        DataCell(
          currentResponse[i]["yemek2"] == "true"
              ? Icon(Icons.task_sharp, color: Colors.green)
              : Icon(Icons.cancel, color: Colors.red),
        ),
        DataCell(
          currentResponse[i]["meze"] == "true"
              ? Icon(Icons.task_sharp, color: Colors.green)
              : Icon(Icons.cancel, color: Colors.red),
        ),
        DataCell(
          currentResponse[i]["tatli"] == "true"
              ? Icon(Icons.task_sharp, color: Colors.green)
              : Icon(Icons.cancel, color: Colors.red),
        ),
      ]));
    }
  }

  @override
  void initState() {
    super.initState();
    _future = getWishList();
    _future1 = checkIsMenuAdded();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_future, _future1]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (isMenuAdded == false) {
              return Scaffold(
                body: Container(
                  color: const Color.fromARGB(255, 23, 115, 190),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.red,
                          size: 100,
                        ),
                        Text(
                          "Henüz herhangi bir yemek menüsü eklemediniz !",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.all(50),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                            ),
                            onPressed: () => {Get.to(createMenuPage())},
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Icon(
                                  Icons.task_alt_rounded,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 30),
                                Text(
                                  "Menü ekle",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 22.5,
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
            } else {
              return Scaffold(
                body: Container(
                  color: const Color.fromARGB(255, 23, 115, 190),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SpinKitCubeGrid(
                            size: 80,
                            color: Colors.white,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 20),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () => {
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        waitingPage(),
                                  ),
                                )
                              },
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh,
                                      color: Colors.blue, size: 50),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          60),
                                  Text(
                                    "Sayfayı Yenile",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 22.5),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 30),
                          SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Seçimler:",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              80),
                                  DataTable(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      columnSpacing: 12,
                                      columns: [
                                        DataColumn(label: Text("İsim")),
                                        DataColumn(label: Text("Çorba")),
                                        DataColumn(label: Text("1.Yemek")),
                                        DataColumn(label: Text("2.Yemek")),
                                        DataColumn(label: Text("Meze")),
                                        DataColumn(label: Text("Tatlı")),
                                      ],
                                      rows: dataRows),
                                ],
                              )),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return SpinKitChasingDots(
              color: Colors.white,
            );
          }
        });
  }
}
