import 'dart:async';
import 'package:esp_config/api/config.dart';
import 'package:esp_config/common/common.dart';
import 'package:flutter/material.dart';
import 'package:esp_config/common/localization/default_localizations.dart';
import 'package:esp_config/component/numeric_text_formatter.dart';
import 'package:esp_config/utils/data_util.dart';
import 'package:dio/dio.dart';

class MqttPage extends StatefulWidget {
  @override
  _MqttPageState createState() => _MqttPageState();
}

class _MqttPageState extends State<MqttPage> {
  bool _saving = false;
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(EspConfigLocalizations.i18n(context)!.network),
        ),
        body:
        Stack(
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
                          MqttForm(this._handleSave)],)
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void _handleSave(ip, port, user, password) {
    setState(() {
      _message = '';
      _saving = true;
    });

    updateMQTT(ip,port, user,password).then((res) {

      var data = res.data;
      if(data[AppConfig.KEY_CODE]==200) {
        AppConfig.mqtt_ip = ip;
        AppConfig.mqtt_port = port;
        AppConfig.mqtt_user = user;

        setState(() {
          _message =
              EspConfigLocalizations.i18n(context)!.succeed_operation;
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
}

class MqttForm extends StatefulWidget {
  var handleSave;
  MqttForm(this.handleSave);
  @override
  _MqttFormState createState() => _MqttFormState(this.handleSave);
}

class _MqttFormState extends State<MqttForm> {
  final TextEditingController _ipController = new TextEditingController();
  final TextEditingController _portController = new TextEditingController();
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _pwdController = new TextEditingController();

  final GlobalKey _formKey = new GlobalKey<FormState>();
  String _ip = '';
  int _port = AppConfig.defaultMqttPort;
  String _user = '';
  String _pwd = '';
  var handleSave;

  _MqttFormState(this.handleSave);

  @override
  void initState() {

    super.initState();
    _ipController.text = AppConfig.mqtt_ip;
    _userController.text = AppConfig.mqtt_user;
    if(AppConfig.mqtt_port!=null)
      _portController.text = AppConfig.mqtt_port.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      //设置globalKey，用于后面获取FormState
      key: _formKey,
      //开启自动校验
      autovalidate: true,
      child: Column(
        children: <Widget>[
          TextFormField(
              autofocus: false,
              keyboardType: TextInputType.number,
              //键盘回车键的样式
              textInputAction: TextInputAction.next,
              controller: _ipController,
              decoration: InputDecoration(
                  labelText: EspConfigLocalizations.i18n(context)!.mqtt_ip,
                  hintText: EspConfigLocalizations.i18n(context)!.mqtt_ip_hint,
                  icon: Icon(Icons.settings_remote)),
              onChanged: (inputStr) {
                _ip = inputStr;
              },
              // 校验用户名
              validator: (v) {
                return v==null?null:(v.trim().length > 0 ? null : EspConfigLocalizations.i18n(context)!.error_ip_empty);
              }),
          TextFormField(
              autofocus: false,
              keyboardType: TextInputType.number,
              //键盘回车键的样式
              textInputAction: TextInputAction.next,
              controller: _portController,
              inputFormatters: [NumericTextInputFormatter()],
              decoration: InputDecoration(
                  labelText: EspConfigLocalizations.i18n(context)!.mqtt_port, hintText: EspConfigLocalizations.i18n(context)!.mqtt_port_hint, icon: Icon(Icons.toll)),
              onChanged: (inputStr) {
                _port = strToInt(inputStr,AppConfig.defaultMqttPort);
              },
              ),
          TextFormField(
              autofocus: false,
              keyboardType: TextInputType.number,
              //键盘回车键的样式
              textInputAction: TextInputAction.next,
              controller: _userController,
              decoration: InputDecoration(
                  labelText: EspConfigLocalizations.i18n(context)!.mqtt_user, hintText: EspConfigLocalizations.i18n(context)!.mqtt_user_hint, icon: Icon(Icons.person)),
              onChanged: (inputStr) {
                _user = inputStr;
              },
              ),
          TextFormField(
              autofocus: false,
              controller: _pwdController,
              decoration: InputDecoration(
                  labelText: EspConfigLocalizations.i18n(context)!.mqtt_password,
                  hintText: EspConfigLocalizations.i18n(context)!.mqtt_password_hint,
                  icon: Icon(Icons.lock)),
              obscureText: true,
              onChanged: (inputStr) {
                _pwd = inputStr;
              },
          ),
          // 登录按钮
          Padding(
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
                      if ((_formKey.currentState as FormState).validate()) {
                        //验证通过提交数据
                        _save(_ip,_port,_user,_pwd);
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

  _save(ip,port,user,pwd) => handleSave==null ? null:handleSave(ip,port,user,pwd);
}