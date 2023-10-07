import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:indasyemek/Services/notificationService.dart';

import '../Services/foodService.dart';

class createMenuPage extends StatefulWidget {
  const createMenuPage({super.key});

  @override
  State<createMenuPage> createState() => _createMenuPageState();
}

class _createMenuPageState extends State<createMenuPage> {
  TextEditingController corbaText = TextEditingController();
  TextEditingController yemek1Text = TextEditingController();
  TextEditingController yemek2Text = TextEditingController();
  TextEditingController mezeText = TextEditingController();
  TextEditingController tatliText = TextEditingController();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

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

  late Future _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getDeviceTokens();
  }

  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,
  }) async {
    // FirebaseMessaging.instance.subscribeToTopic("myTopic1");

    String dataNotifications = '{ '
        ' "to" : "/topics/myTopic1" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"$body" '
        ' } '
        ' } ';

    var response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key= ${'AAAA5D5sHHE:APA91bE9pBJW7H2cp9GZEWHiXBpBnP9ObwjDypnxd7AvLvE_t1demyd349up_mkMBDEne2dcWd9rKMVIub7Wc89F7ncAc0iWxLk9RD9pHo1GGTHVLzuw-JX5TQODxOU5JYBFzPc8cqHv'}',
      },
      body: dataNotifications,
    );
    print(response.body.toString());
    return true;
  }

  notificationService _notificationService = notificationService();

  List<String> deviceTokens = [];

  Future<void> getDeviceTokens() async {
    Response response = await _notificationService.getDeviceList();
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);
    for (int i = 0; i < currentResponse["desc"].length; ++i) {
      deviceTokens.add(currentResponse["desc"][i]["deviceToken"]);
    }
  }

  Future<void> makeCall() async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    for (int i = 0; i < deviceTokens.length; ++i) {
      var data = {
        "notification": {
          "body": "Menüye göz atıp seçim yapınız",
          "title": "Yemek Menüsü Hazır"
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
            'key=AAAA5D5sHHE:APA91bGHceEI1EPSMzemfwCoS4hFemRFxkmKwWfYcEje9-oz6P_fAbIuR_J2HfpJsbyxur12nfuWylzVtd4MKLolfokixOnI6Y9J-Q_3Y-7iOvSSXY9k2yQkk-qbcrPCdhZLI4xK-oo3'
      }; //

      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                              hintText: "Çorba Seçimi",
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
                              hintText: "1.Yemek Seçimi",
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
                              hintText: "2.Yemek Seçimi",
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
                              hintText: "Meze / Salata Seçimi",
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
                              hintText: "Tatlı Seçimi",
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
                              tatliText.text),
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
            return SpinKitChasingDots(
              color: Colors.red,
            );
          }
        });
  }
}
