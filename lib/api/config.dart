/**
 * api implement
 * Vincent Lee
 */
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:esp_config/common/common.dart';
import 'package:esp_config/models/devices.dart';
import 'package:sprintf/sprintf.dart';
import 'package:esp_config/models/device.dart';
import 'dart:convert';


Dio buildRequest() {
  String url = sprintf("http://%s:%d", [AppConfig.espIp,AppConfig.espPort]);
  print(url);
  var options = BaseOptions(
    baseUrl: url,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  return Dio(options);
}

login(String user,String pwd) async{
  var dio = buildRequest();
  return await dio.post('/login/',data: {'user': user, 'pwd': pwd});
}

updateNetwork(ssid, password) async{
  var dio = buildRequest();
  var data = {AppConfig.KEY_TOKEN:AppConfig.token, AppConfig.KEY_WIFI_SSID:ssid, AppConfig.KEY_WIFI_PASSWORD: password};

  return await dio.post('/network/update/',data: data);
}

addDevice(DeviceModel device) async{
  var dio = buildRequest();
  var data = {};
  data[AppConfig.KEY_TOKEN] = AppConfig.token;
  data[AppConfig.KEY_DEVICE] = device.getItems();

  return await dio.post('/devices/add/',data: data);
}

updateDevice(int id,  Map<String, dynamic> device) async{
  var dio = buildRequest();
  var data = {};
  data[AppConfig.KEY_TOKEN] = AppConfig.token;
  data[AppConfig.KEY_DEVICE] = device;
  data[AppConfig.KEY_DEVICE_ID] = id;

  return await dio.post('/devices/update/',data: data);
}

removeDevice(int id) async{
  var dio = buildRequest();
  var data = {};
  data[AppConfig.KEY_TOKEN] = AppConfig.token;
  data[AppConfig.KEY_DEVICE_ID] = id;

  return await dio.post('/devices/remove/',data: data);
}

updateMQTT(ip, port, user,password) async{
  var dio = buildRequest();
  var data = {
    AppConfig.KEY_TOKEN:AppConfig.token,
    AppConfig.KEY_MQTT_IP:ip,
    AppConfig.KEY_MQTT_PORT: port,
    AppConfig.KEY_MQTT_USER: user,
    AppConfig.KEY_MQTT_PASSWORD: password
  };
  return await dio.post('/mqtt/update/',data: data);
}