
import 'package:esp_config/common/localization/default_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esp_config/models/devices.dart';
import 'package:esp_config/models/device.dart';
import 'package:dio/dio.dart';
import 'package:esp_config/api/config.dart';
import 'package:esp_config/common/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sprintf/sprintf.dart';

class DevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var devices = context.watch<DevicesModel>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
           delegate: SliverChildBuilderDelegate(
                    (context, index) => _MyListItem(devices.getByPosition(index)),childCount: devices==null ? 0:devices.getCount())
          ),
        ],
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(EspConfigLocalizations.i18n(context)!.devices, style: Theme.of(context).textTheme.subtitle1),
      floating: true,
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            var devices = Provider.of<DevicesModel>(context, listen:false);
            devices.setId(-1);
            Navigator.pushNamed(context, '/device');},
        ),
      ],
    );
  }
}


class _MyListItem extends StatelessWidget {
  final DeviceModel device;

  _MyListItem(this.device, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var textTheme = Theme.of(context).textTheme.headline6;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Text(sprintf("%s(%d)",[device.typeName, device.id]) , style: textTheme),
            ),
            SizedBox(width: 24),
            _AddButton(device.id,1, this.handleEdit),
            _AddButton(device.id,0,this.handleRemove),
          ],
        ),
      ),
    );
  }

  void handleEdit(context,id) {
    var devices = Provider.of<DevicesModel>(context, listen:false);
    devices!.setId(id);
    Navigator.pushNamed(context, '/device');
  }

  void handleRemove(context, id) {
    showCupertinoDialog<int>(context: context, builder: (context) {
      return CupertinoAlertDialog(
        title: Text(EspConfigLocalizations.i18n(context)!.information),
        content: Text(
            EspConfigLocalizations.i18n(context)!.confirm_delete_device),
        actions: [
          FlatButton(child: Text(EspConfigLocalizations.i18n(context)!.cancel),
              onPressed: () {
            Navigator.of(context).pop();
          }),
          FlatButton(child: Text(EspConfigLocalizations.i18n(context)!.confirm),
              onPressed: () => _removeDevice(context,id))
        ],
      );
    });
  }

  _removeDevice(context,id) {
    var message  = '';
    removeDevice(id).then((res) {
      var data = res.data;
      if(data[AppConfig.KEY_CODE]==200) {
        var devices = context.read<DevicesModel>();
        devices!.removeById(id);
        Navigator.of(context).pop();
      } else {
        message =
            EspConfigLocalizations.i18n(context)!.error_operation;
        Fluttertoast.showToast(msg: message);
      }
    }).catchError((error) { // 捕获出现异常时的情况
      if (error.runtimeType == DioError) {
        if (error.type == DioErrorType.connectTimeout) {
          message =
              EspConfigLocalizations.i18n(context)!.error_operation;
          Fluttertoast.showToast(msg: message);
          return;
        }
      }
      message =
          EspConfigLocalizations.i18n(context)!.error_operation;
      Fluttertoast.showToast(msg: message);
      return;
    });

  }
}

class _AddButton extends StatelessWidget {
  final int id;
  final int type;
  var onPress;
  _AddButton(this.id, this.type, [this.onPress, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The context.select() method will let you listen to changes to
    // a *part* of a model. You define a function that "selects" (i.e. returns)
    // the part you're interested in, and the provider package will not rebuild
    // this widget unless that particular part of the model changes.
    //
    // This can lead to significant performance improvements.

    return TextButton(
      onPressed: () {
        // If the item is not in cart, we let the user add it.
        // We are using context.read() here because the callback
        // is executed whenever the user taps the button. In other
        // words, it is executed outside the build method.
        if(this.onPress!=null) {
          this.onPress(context, id);
        }

      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: type==0 ? Icon(Icons.delete):Icon(Icons.edit),
    );
  }
}