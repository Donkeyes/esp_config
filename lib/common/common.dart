// App参数
// Created by vhsal.com
// Date: 2021-06-03

import 'package:esp_config/models/device_type.dart';
class AppConfig {
  static String token = '';
  static String espIp = '';
  static const int espPort = 8000;
  static const int defaultMqttPort = 1883;
  static String mqtt_ip='';
  static int? mqtt_port ;
  static String mqtt_user = '';
  static String ssid = '';

  static const KEY_USER_NAME = "USER_NAME";
  static const KEY_ESP_IP = "ESP_IP";
  static const KEY_PASSWORD = "PASSWORD";
  static const KEY_MQTT_IP = "MQTT_IP";
  static const KEY_MQTT_PORT ='MQTT_PORT';
  static const KEY_MQTT_USER ='MQTT_USER';
  static const KEY_MQTT_PASSWORD ='MQTT_PASSWORD';
  static const KEY_WIFI_SSID = "WIFI_SSID";
  static const KEY_WIFI_PASSWORD = "WIFI_PASSWORD";
  static const KEY_DEVICE ='DEVICE';
  static const KEY_DEVICE_ID ='ID';
  static const KEY_DEVICES ='DEVICES';
  static const KEY_CODE ='CODE';
  static const KEY_TOKEN = "TOKEN";
  static const KEY_DEVICE_TYPE = "device_module";

  static Map<String,DeviceTypeModel> listType = {};
  static DeviceTypeModel? getDeviceTypeByModule(String module) {
    return listType![module];
  }

}
