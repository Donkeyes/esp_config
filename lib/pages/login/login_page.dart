import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:esp_config/common/common.dart';
import 'package:esp_config/common/storage/local_storage.dart';
import 'package:esp_config/common/localization/default_localizations.dart';
import 'package:esp_config/models/devices.dart';
import 'package:esp_config/models/device.dart';
import 'package:esp_config/models/device_type.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:esp_config/api/config.dart';

/**
 * Vhsal.com
 * 2021-06-09
 */
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with _LoginCrl {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(EspConfigLocalizations.i18n(context)!.login),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 120.0,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 30.0),
                  color: Colors.white,
                  child: Icon(Icons.access_alarm),
                ),
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: new Container(
                    child: buildForm(),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget buildForm() {
    return Form(
      //设置globalKey，用于后面获取FormState
      key: formKey,
      //开启自动校验
      autovalidate: true,
      child: Column(
        children: <Widget>[
          new Text(_message,
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.red,
                fontStyle: FontStyle.italic,
              )),
          TextFormField(
              autofocus: false,
              keyboardType: TextInputType.number,
              //键盘回车键的样式
              textInputAction: TextInputAction.next,
              controller: ipController,
              decoration: InputDecoration(
                  labelText: "ip",
                  hintText: EspConfigLocalizations.i18n(context)!.esp_device_ip,
                  icon: Icon(Icons.settings_remote)),
              onChanged: (inputStr) {
                _ip = inputStr;
              },
              // 校验用户名
              validator: (v) {
                return v==null? null:(v.trim().length > 0
                    ? null
                    : EspConfigLocalizations.i18n(context)!.error_ip_empty);
              }),
          TextFormField(
              autofocus: false,
              keyboardType: TextInputType.number,
              //键盘回车键的样式
              textInputAction: TextInputAction.next,
              controller: userController,
              decoration: InputDecoration(
                  labelText: EspConfigLocalizations.i18n(context)!.user_name,
                  hintText: EspConfigLocalizations.i18n(context)!.user_name,
                  icon: Icon(Icons.person)),
              onChanged: (inputStr) {
                _userName = inputStr;
              },
              // 校验用户名
              validator: (v) {
                return v==null?null:(v.trim().length > 0
                    ? null
                    : EspConfigLocalizations.i18n(context)!.error_user_empty);
              }),
          TextFormField(
              autofocus: false,
              controller: pwdController,
              decoration: InputDecoration(
                  labelText: EspConfigLocalizations.i18n(context)!.password,
                  hintText: EspConfigLocalizations.i18n(context)!.password_hint,
                  icon: Icon(Icons.lock)),
              obscureText: true,
              onChanged: (inputStr) {
                _password = inputStr;
              },
              //校验密码
              validator: (v) {
                return v==null?null:(v.trim().length > 0
                    ? null
                    : EspConfigLocalizations.i18n(context)!.error_password_empty);
              }),
          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    child: Text(EspConfigLocalizations.i18n(context)!.login),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if ((formKey.currentState as FormState).validate()) {
                        //验证通过提交数据
                        _login();
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

mixin _LoginCrl on State<LoginPage> {
  final TextEditingController ipController = new TextEditingController();
  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwdController = new TextEditingController();
  GlobalKey formKey = new GlobalKey<FormState>();

  String _ip = "";
  String _userName = "";
  String _password = "";
  String _message = "";

  @override
  void initState() {
    super.initState();
    _initDeviceType();
    _initParams();
  }

  @override
  void dispose() {
    super.dispose();
    ipController.removeListener(_ipChange);
    userController.removeListener(_usernameChange);
    pwdController.removeListener(_passwordChange);
  }

  _ipChange() {
    _ip = ipController.text;
  }

  _usernameChange() {
    _userName = userController.text;
  }

  _passwordChange() {
    _password = pwdController.text;
  }

  void _initDeviceType() {
    rootBundle.loadString('assets/tmpl/devices_type.json').then((value) {
      List list = json.decode(value);
      for (var m in list) {
        DeviceTypeModel d = DeviceTypeModel.fromJson(m);
        AppConfig.listType[d.deviceModule]=d;
      }
    });
  }

  _initParams() async {
    _ip = await LocalStorage.get(AppConfig.KEY_ESP_IP);
    _userName = await LocalStorage.get(AppConfig.KEY_USER_NAME);
    _password = await LocalStorage.get(AppConfig.KEY_PASSWORD);
    ipController.value = new TextEditingValue(text: _ip!);
    userController.value = new TextEditingValue(text: _userName!);
    pwdController.value = new TextEditingValue(text: _password!);
  }

  _login() {
    setState(() {
      _message = '';
    });
    AppConfig.espIp = _ip;
    login(_userName,_password).then((res) {

      LocalStorage.save(AppConfig.KEY_ESP_IP, _ip);
      LocalStorage.save(AppConfig.KEY_USER_NAME, _userName);
      LocalStorage.save(AppConfig.KEY_PASSWORD, _password);

      var data = res.data;
      print(data);
      if(data[AppConfig.KEY_CODE]==200) {
        _parse(data);
        Navigator.pushReplacementNamed(context, '/home');
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

  _parse(data) {
    var d = {};
    AppConfig.token = data[AppConfig.KEY_TOKEN];
    AppConfig.mqtt_ip = data.keys.contains(AppConfig.KEY_MQTT_IP)? data[AppConfig.KEY_MQTT_IP] : '';
    AppConfig.mqtt_port = data.keys.contains(AppConfig.KEY_MQTT_PORT)?
                    int.tryParse(data[AppConfig.KEY_MQTT_PORT]!.toString())
                    : null;
    AppConfig.mqtt_user = data.keys.contains(AppConfig.KEY_MQTT_USER)? data[AppConfig.KEY_MQTT_USER] : '';
    AppConfig.ssid = data.keys.contains(AppConfig.KEY_WIFI_SSID)? data[AppConfig.KEY_WIFI_SSID] : '';
    if(data.keys.contains(AppConfig.KEY_DEVICES)) {
      var oldDevices = data[AppConfig.KEY_DEVICES];
      var devices = Provider.of<DevicesModel>(context, listen:false);
      oldDevices.forEach((element) {
        var type = AppConfig.getDeviceTypeByModule(element[AppConfig.KEY_DEVICE_TYPE].toString());
        int devId = int.parse(element["dev_id"].toString());
        String typeName = type==null ? "": type.typeName;

        var d = DeviceModel(devId,element["device_module"].toString(), typeName, element);
        devices.add(d);
      });
    }
  }
}
