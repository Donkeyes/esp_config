import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:esp_config/pages/devices/device_form.dart';
import 'package:esp_config/models/devices.dart';
import 'package:esp_config/models/device.dart';
import 'package:esp_config/models/device_type.dart';
import 'package:esp_config/common/localization/default_localizations.dart';
import 'package:esp_config/common/common.dart';
import 'package:esp_config/api/config.dart';
import 'package:dio/dio.dart';

class DevicePage extends StatefulWidget {
  final String title = '';
  DevicePage();
  @override
  _DevicePageState createState() {
    // ignore: todo
    // TODO: implement createState
    return new _DevicePageState();
  }
}

class _DevicePageState extends State<DevicePage> {
  DeviceTypeModel? _deviceType;
  DeviceModel? _device;
  String _devTypeName = '';
  String _message = '';
  var widgetsBinding;
  int _init = 0;

  ///Form Key
  GlobalKey formKey = new GlobalKey<FormState>();

  ///message
  String message = "";

  @override
  void initState() {
    super.initState();

    widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      var devices = Provider.of<DevicesModel>(context, listen: false);
      _device = devices.device;
      if (_device == null) {
        _showDeviceTypeDlg();
      }
    });
  }

  Future _showDeviceTypeDlg() async {
    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: new Text(EspConfigLocalizations.i18n(context)!.device_type_select),
              children: buildDevicesList()
          );
        });
  }

  List<SimpleDialogOption> buildDevicesList() {
    List<SimpleDialogOption> list = [];
    var i = 0;
    for (var e in AppConfig.listType.keys) {
      list.add(new SimpleDialogOption(
          child: new Text(AppConfig.listType[e]!.typeName),
          onPressed: () {
            setState(() {
              onDeviceTypeSelect(i);
            });
            Navigator.of(context).pop();
          }));
    }
    return list;
  }

  void onDeviceTypeSelect(index) {
    setState(() {
      _deviceType = AppConfig.listType[AppConfig.listType.keys.toList()[index]];
      _devTypeName = _deviceType!.typeName;
    });
  }

  @override
  Widget build(BuildContext context) {
    var devices = context.watch<DevicesModel>();
    _device = devices.device;
    if(_device!=null) {
      print('deviceModule:'+ _device!.deviceModule);
      _deviceType = AppConfig.listType[_device!.deviceModule];
      _devTypeName = _deviceType == null? "" : _deviceType!.typeName;
    }

    return Scaffold(
        appBar: AppBar(
          title: new Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: new Container(
                      child: Column(
                        children:[
                          new Text(_message,
                              style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.red,
                                fontStyle: FontStyle.italic,
                              )),
                              new Text(
                                EspConfigLocalizations.i18n(context)!.device_type+':' + _devTypeName,
                                style: new TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                )),
                          DeviceForm(_deviceType, _device, _save)
                    ],)
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(15.0),
                          child: Text(EspConfigLocalizations.i18n(context)!.save),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {

                          },
                        ),
                      ),
                    ],
                  ),
                )*/
              ],
            ),
          ],
        ));
  }

  void _save(int id, DeviceModel newDevice) {
    setState(() {
      _message = '';
    });

    updateDevice(id, newDevice.getItems() ).then((res) {
      var data = res.data;
      if(data[AppConfig.KEY_CODE]==200) {

        var devices = context.read<DevicesModel>();
        devices.updateById(id,newDevice);
        setState(() {
          _message = EspConfigLocalizations.i18n(context)!.succeed_operation;
        });
      } else {
        setState(() {
          _message =
          EspConfigLocalizations.i18n(context)!.error_operation;
        });
      }
    }).catchError((error) { // 捕获出现异常时的情况
      if (error.runtimeType == DioError) {
        if (error.type == DioErrorType.connectTimeout) {
          setState(() {
          _message =
          EspConfigLocalizations.i18n(context)!
              .error_http_connect_timedout;
          });
        }
      }
      setState(() {
        _message =
          EspConfigLocalizations.i18n(context)!.error_http_other;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}


