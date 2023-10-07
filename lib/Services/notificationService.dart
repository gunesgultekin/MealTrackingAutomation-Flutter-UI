import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Authorization.dart';

class notificationService {
  Future<void> saveDevice(String? email, String? deviceToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    var url = Uri.parse(
        "https://10.0.2.2:7239/deviceTable/AddToDb?email=${email}&deviceToken=${deviceToken}");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    });
  }

  Future<http.Response> getDeviceList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    var url = Uri.parse("https://10.0.2.2:7239/deviceTable/GetAll");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    });
    return response;
  }
}
