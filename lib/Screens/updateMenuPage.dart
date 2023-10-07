import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:indasyemek/Services/notificationService.dart';

import '../Services/foodService.dart';

class updateMenuPage extends StatefulWidget {
  const updateMenuPage({super.key});

  @override
  State<updateMenuPage> createState() => _updateMenuPageState();
}

class _updateMenuPageState extends State<updateMenuPage> {
  TextEditingController corbaText = TextEditingController();
  TextEditingController yemek1Text = TextEditingController();
  TextEditingController yemek2Text = TextEditingController();
  TextEditingController mezeText = TextEditingController();
  TextEditingController tatliText = TextEditingController();

  Future<void> getSelected() async {
    Response response = await foodService().getFoodList();
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData)["desc"];
    corba = currentResponse["corba"].toString();
    yemek1 = currentResponse["yemek1"].toString();
    yemek2 = currentResponse["yemek2"].toString();
    meze = currentResponse["meze"].toString();
    tatli = currentResponse["tatli"].toString();
  }

  late String corba;
  late String yemek1;
  late String yemek2;
  late String meze;
  late String tatli;

  late Future _future;
  late Future _future1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getSelected();
    _future1 = getDeviceTokens();
  }

  List<String> deviceTokens = [];

  Future<void> makeCall() async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    for (int i = 0; i < deviceTokens.length; ++i) {
      var data = {
        "notification": {
          "body": "Tekrar yemek seçimi yapınız",
          "title": "Menü Güncellendi"
        },
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done"
        },
        "to": deviceTokens[i]

        //"czrr_QppQeav51tElRBR22:APA91bHo_XvvNEVYhX3uVNoPsGERcGTK4_vFNfeh-zed2ggD4l2lcy0AEEjTaROS1gcYSx-6yAy3efHreu8OQ2-YwWB4u7DE8su2CmOyBM1qFU9tb_4cuZq1MEnXK2adKDDWSOUj8g8N"
      };
      final headers = {
        'content-type': 'application/json',
        'Authorization':
            'key=AAAA5D5sHHE:APA91bE9pBJW7H2cp9GZEWHiXBpBnP9ObwjDypnxd7AvLvE_t1demyd349up_mkMBDEne2dcWd9rKMVIub7Wc89F7ncAc0iWxLk9RD9pHo1GGTHVLzuw-JX5TQODxOU5JYBFzPc8cqHv'
      };

      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);
    }
  }

  notificationService _notificationService = notificationService();

  Future<void> getDeviceTokens() async {
    Response response = await _notificationService.getDeviceList();
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);
    for (int i = 0; i < currentResponse["desc"].length; ++i) {
      deviceTokens.add(currentResponse["desc"][i]["deviceToken"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_future, _future1]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Container(
                color: const Color.fromARGB(255, 23, 115, 190),
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 18),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Colors.white),
                          child: TextFormField(
                            controller: corbaText,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: corba == "null"
                                  ? "Çorba Seçimi yapılmamış"
                                  : "Önceki Seçim: " + corba,
                              icon: Container(
                                width: MediaQuery.of(context).size.width / 8,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage("Assets/foodIcons/soup.png"),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 60),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Colors.white),
                          child: TextFormField(
                            controller: yemek1Text,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: yemek1 == "null"
                                  ? "1.yemek Seçimi yapılmamış"
                                  : "Önceki Seçim: " + yemek1,
                              icon: Container(
                                width: MediaQuery.of(context).size.width / 8,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "Assets/foodIcons/food1.png"),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 60),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Colors.white),
                          child: TextFormField(
                            controller: yemek2Text,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: yemek2 == "null"
                                  ? "2.yemek seçimi yapılmamış"
                                  : "Önceki Seçim: " + yemek2,
                              icon: Container(
                                width: MediaQuery.of(context).size.width / 8,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "Assets/foodIcons/food2.png"),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 60),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Colors.white),
                          child: TextFormField(
                            controller: mezeText,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: meze == "null"
                                  ? "Meze seçimi yapılmamış"
                                  : "Önceki Seçim: " + meze,
                              icon: Container(
                                width: MediaQuery.of(context).size.width / 8,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "Assets/foodIcons/appetizer.png"),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 60),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Colors.white),
                          child: TextFormField(
                            controller: tatliText,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: tatli == "null"
                                  ? "Tatlı seçimi yapılmamış"
                                  : "Önceki seçim: " + tatli,
                              icon: Container(
                                width: MediaQuery.of(context).size.width / 8,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "Assets/foodIcons/dessert.png"),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(50),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                        ),
                        onPressed: () => {
                          makeCall(),
                          foodService().saveFoodList(
                              corbaText.text,
                              yemek1Text.text,
                              yemek2Text.text,
                              mezeText.text,
                              tatliText.text)
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
                                width: MediaQuery.of(context).size.width / 30),
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
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SpinKitChasingDots(color: Colors.black);
          }
        });
  }
}
