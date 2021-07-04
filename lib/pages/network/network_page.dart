import 'dart:async';
import 'package:flutter/material.dart';
import 'package:esp_config/common/localization/default_localizations.dart';
import 'package:esp_config/common/common.dart';
import 'package:esp_config/api/config.dart';
import 'package:dio/dio.dart';

class NetworkPage extends StatefulWidget {
  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
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
                    NetworkForm(this._handleSave)],)
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void _handleSave(ssid, password) {
    setState(() {
      _message = '';
      _saving = true;
    });
    print('ssid' + ssid);

    updateNetwork(ssid,password).then((res) {

      var data = res.data;
      if(data[AppConfig.KEY_CODE]==200) {
        AppConfig.ssid = ssid;
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

class NetworkForm extends StatefulWidget {
  var handleSave;
  NetworkForm(this.handleSave);
  @override
  _NetworkFormState createState() => _NetworkFormState(this.handleSave);
}

class _NetworkFormState extends State<NetworkForm> {
  final TextEditingController _ssidController = new TextEditingController();
  final TextEditingController _pwdController = new TextEditingController();
  final GlobalKey _formKey = new GlobalKey<FormState>();
  String _message = '';
  String _ssid = '';
  String _pwd = '';
  var handleSave;

  _NetworkFormState(this.handleSave);
  @override
  void initState() {
    super.initState();
    setState(() {
      _ssidController.text = AppConfig.ssid;
    });
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
              controller: _ssidController,
              decoration: InputDecoration(
                  labelText: EspConfigLocalizations.i18n(context)!.ssid,
                  hintText: EspConfigLocalizations.i18n(context)!.ssid_hint,
                  icon: Icon(Icons.settings_remote)),
              onChanged: (inputStr) {
                _ssid = inputStr;
              },
              // 校验用户名
              validator: (v) {
                return v==null?null:(v.trim().length > 0 ? null : EspConfigLocalizations.i18n(context)!.error_ssid_empty);
              }),
          TextFormField(
              autofocus: false,
              controller: _pwdController,
              decoration: InputDecoration(
                  labelText: EspConfigLocalizations.i18n(context)!.wifi_password,
                  hintText: EspConfigLocalizations.i18n(context)!.wifi_password_hint,
                  icon: Icon(Icons.lock)),
              obscureText: true,
              onChanged: (inputStr) {
                _pwd = inputStr;
              },
              //校验密码
              validator: (v) {
                return v==null?null:(v.trim().length > 0 ? null : EspConfigLocalizations.i18n(context)!.error_wifi_password_empty);
              }),
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
                        _save(_ssid, _pwd);
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

  _save(ssid,password) => handleSave==null ? null:handleSave(ssid,password);
}