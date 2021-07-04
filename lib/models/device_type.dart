// 设备类型
// Created by vhsal.com
// Date: 2021-06-03

import 'package:esp_config/models/device_type_col.dart';
class DeviceTypeModel {
  String deviceModule="";
  String typeName="";
  List<DeviceTypeColModel> listCols = [];

  DeviceTypeModel.fromJson(Map<String, dynamic> json) {
    this.deviceModule = json['device_module'].toString();
    this.typeName = json['type_name'].toString();
    var cols = json['cols'];
    for (var d in cols) {
      listCols.add(DeviceTypeColModel.fromJson(d));
    }
  }

  DeviceTypeColModel? findCol(String code) {

    for(var d in listCols) {
      if(d.code==code)
        return d;
    }
    return null;
  }
}