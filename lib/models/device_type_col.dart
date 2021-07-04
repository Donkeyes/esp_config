// 设备类型参数
// Created by vhsal.com
// Date: 2021-06-03

class DeviceTypeColModel {
  String title="";
  String code="";
  String formatter="";
  String dataType="";
  DeviceTypeColModel(this.title,this.code,this.formatter,this.dataType);
  DeviceTypeColModel.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.code = json['code'];
    this.dataType = json['data_type'];
    this.formatter = json['formatter']??"";
  }
}
