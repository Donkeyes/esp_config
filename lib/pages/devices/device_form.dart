import 'package:esp_config/models/device_type_col.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:esp_config/models/device_type.dart';
import 'package:esp_config/models/device.dart';
import 'package:esp_config/common/localization/default_localizations.dart';
import 'package:esp_config/utils/data_util.dart';

class DeviceForm extends StatefulWidget {
  var handleSave;
  DeviceTypeModel? deviceType;
  DeviceModel? device;
  DeviceForm(this.deviceType, this.device,this.handleSave);
  @override
  _DeviceFormState createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  bool _inited = false;
  Map<String, ControllerItem> listItem = {};
  final GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initCol();
    List<Widget> children = [];
    for (var field in listItem.keys) {
      children.add(listItem[field]!.field!);
    }
    children.add(
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
                    onPress();
                  },
                ),
              ),
            ],
          ),
        ));

    return Form(
      //设置globalKey，用于后面获取FormState
        key: _formKey,
        //开启自动校验
        autovalidate: true,
        child: Column(children:children));
  }

  void _initCol() {
    if (widget.deviceType == null ) return;
    if (_inited) return;
    var i = 0;
    widget.deviceType!.listCols.forEach((col) {
      var item = ControllerItem();
      listItem[col.code] = item;
      var cols = widget.deviceType!.listCols;
      if (widget.device != null && widget.device!.getItem(col.code)!= null) {
        item.controller.text = widget.device!.getItem(col.code).toString();
      }
      item.colCode = col.code;
      item.colType = col.dataType;

      item.colCode = col.code;
      item.colType = col.dataType;
      item.field = new TextFormField(
          autofocus: false,
          keyboardType: TextInputType.number,
          //键盘回车键的样式
          textInputAction: TextInputAction.next,
          controller: item.controller,
          decoration: InputDecoration(
              labelText: col.title,
              hintText: col.title,
              icon: Icon(Icons.mode_edit)),
          textAlign:
          col.dataType == 'string' ? TextAlign.left : TextAlign.right,
          onChanged: (inputStr) {
            item.colValue = inputStr;
          },
          // 校验用户名
          validator: (v) {
            return v!.trim().length > 0 ? null : "ssid不能为空";
          });
      i++;
    });
    _inited = true;
  }

  onPress () {
    if(widget.deviceType!=null && widget.handleSave!=null) {
      var id = widget.device == null ? 0 : widget.device!.id;
      Map<String, dynamic> d = {};
      listItem.forEach((key, item) {
       String txtValue = item.controller.text;
       DeviceTypeColModel? col = widget.deviceType!.findCol(key);
       if(col != null) {
         var value = strToValueByType(txtValue, col.dataType);
         if (value != null)
           d[key] = value;
       }
      });
      DeviceModel device = DeviceModel(id, widget.deviceType!.deviceModule, widget.deviceType!.typeName, d);
      widget.handleSave(id, device);
    }
  }
}

class ControllerItem {
  String colValue = '';
  String colCode = '';
  String colType = '';
  Widget? field;
  TextEditingController controller = TextEditingController();
}
