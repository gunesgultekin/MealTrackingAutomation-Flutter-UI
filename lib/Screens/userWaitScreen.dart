// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:indasyemek/Screens/loginScreen.dart';
import 'package:indasyemek/Services/foodService.dart';

class userWaitScreen extends StatefulWidget {
  String email;
  userWaitScreen({required this.email});

  @override
  State<userWaitScreen> createState() => _userWaitScreenState();
}

class _userWaitScreenState extends State<userWaitScreen> {
  Future<bool> checkDb() async {
    await getFoodList();
    return foodService().checkDb();
  }

  late Future _future1;
  late Future _future2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future1 = checkDb();
    _future2 = getWishListState(widget.email);
    saveDeviceToken();
  }

  late bool corbaSecimi = false;
  late bool yemek1Secimi = false;
  late bool yemek2Secimi = false;
  late bool mezeSecimi = false;
  late bool tatliSecimi = false;
  late bool selectAll = false;

  late var currentResponse;
  late var wishStates;

  Future<void> getFoodList() async {
    Response response = await foodService().getFoodList();
    String responseData = response.body;
    currentResponse = jsonDecode(responseData)["desc"];
  }

  Future<void> getWishListState(String email) async {
    Response response = await foodService().getWishList();
    String responseData = response.body;
    wishStates = jsonDecode(responseData)["desc"];
    for (int i = 0; i < wishStates.length; ++i) {
      if (wishStates[i]["email"] == email) {
        corbaSecimi = bool.parse(wishStates[i]["corba"]);
        yemek1Secimi = bool.parse(wishStates[i]["yemek1"]);
        yemek2Secimi = bool.parse(wishStates[i]["yemek2"]);
        mezeSecimi = bool.parse(wishStates[i]["meze"]);
        tatliSecimi = bool.parse(wishStates[i]["tatli"]);
      }
    }
  }

  Future<String?> saveDeviceToken() async {
    String? deviceToken = '@';

    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print('could not get token');
      print(e.toString());
    }
    if (deviceToken != null) {
      print("--------------Device Token--------------" + deviceToken);
    }
    return deviceToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: Future.wait([_future1, _future2]),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (currentResponse["corba"] == null) {
                  return Scaffold(
                    body: Container(
                      color: const Color.fromARGB(255, 23, 115, 190),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu_sharp,
                              color: Colors.red,
                              size: 200,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 25),
                            Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedTextKit(
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                        colors: [Colors.red, Colors.blue],
                                        "Henüz Yemek Listesi eklenmedi",
                                        speed: Duration(milliseconds: 100),
                                        textStyle: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ))
                                  ],
                                ),
                              ],
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
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Hepsini seç",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.5,
                                    ),
                                  ),
                                  Checkbox(
                                      activeColor: Colors.blue,
                                      value: selectAll,
                                      onChanged: (bool? value) => {
                                            setState(() {
                                              selectAll = value!;
                                              corbaSecimi = selectAll;
                                              yemek1Secimi = selectAll;
                                              yemek2Secimi = selectAll;
                                              mezeSecimi = selectAll;
                                              tatliSecimi = selectAll;
                                              selectAll = selectAll;
                                            })
                                          }),
                                ],
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 40),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: Colors.white,
                                  child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      selected: corbaSecimi,
                                      value: corbaSecimi,
                                      title: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "Assets/foodIcons/soup.png"),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "   Çorba Seçimi:\n " +
                                                  "  " +
                                                  currentResponse["corba"]
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ]),
                                      onChanged: (bool? value) => {
                                            setState(() {
                                              corbaSecimi = value!;
                                            })
                                          }),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 40),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: Colors.white,
                                  child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      selected: yemek1Secimi,
                                      value: yemek1Secimi,
                                      title: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "Assets/foodIcons/food1.png"),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "   1.Yemek Seçimi:\n " +
                                                  "  " +
                                                  currentResponse["yemek1"]
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ]),
                                      onChanged: (bool? value) => {
                                            setState(() {
                                              yemek1Secimi = value!;
                                            })
                                          }),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 40),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: Colors.white,
                                  child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      selected: yemek2Secimi,
                                      value: yemek2Secimi,
                                      title: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "Assets/foodIcons/food2.png"),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "   2.Yemek Seçimi:\n  " +
                                                  " " +
                                                  currentResponse["yemek2"]
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ]),
                                      onChanged: (bool? value) => {
                                            setState(() {
                                              yemek2Secimi = value!;
                                            })
                                          }),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 40),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: Colors.white,
                                  child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      selected: mezeSecimi,
                                      value: mezeSecimi,
                                      title: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "Assets/foodIcons/appetizer.png"),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "   Meze Seçimi:\n  " +
                                                  " " +
                                                  currentResponse["meze"]
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ]),
                                      onChanged: (bool? value) => {
                                            setState(() {
                                              mezeSecimi = value!;
                                            })
                                          }),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 40),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: Colors.white,
                                  child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      selected: tatliSecimi,
                                      value: tatliSecimi,
                                      title: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "Assets/foodIcons/dessert.png"),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "   Tatlı Seçimi:\n  " +
                                                  " " +
                                                  currentResponse["tatli"]
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ]),
                                      onChanged: (bool? value) => {
                                            setState(() {
                                              tatliSecimi = value!;
                                            })
                                          }),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 20),
                              Container(
                                width: 250,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.white),
                                  ),
                                  onPressed: () => {
                                    foodService().saveSelection(
                                        widget.email,
                                        corbaSecimi.toString(),
                                        yemek1Secimi.toString(),
                                        yemek2Secimi.toString(),
                                        mezeSecimi.toString(),
                                        tatliSecimi.toString())
                                  },
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Icon(
                                        Icons.task_alt_rounded,
                                        color: Colors.blue,
                                        size: 25,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30),
                                      Text(
                                        "Onayla",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 22.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Container(
                    color: const Color.fromARGB(255, 23, 115, 190),
                    child: Center(
                      child: SpinKitRing(
                        color: Colors.white,
                        size: 150,
                      ),
                    ));
              }
            }));
  }
}
