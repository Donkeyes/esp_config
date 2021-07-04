// 设备列表
// Created by vhsal.com
// Date: 2021-06-03

import 'package:flutter/foundation.dart';
import 'package:esp_config/models/device.dart';

class DevicesModel with ChangeNotifier {
  /// all devices
  final Map<int, DeviceModel> _devices = {};
  int _currentId = -1;

  bool add(DeviceModel newDevice) {
    assert(newDevice.id != null);
    if (_devices.containsKey(newDevice.id)) return false;
    _devices[newDevice.id] = newDevice;
    notifyListeners();
    return true;
  }

  void update(id, DeviceModel newDevice) {
    assert(newDevice.id != null);
    _devices[id] = newDevice;
    notifyListeners();
  }

  void updateById(int id, DeviceModel newDevice) {
    assert(id != null);
    if(id==newDevice)
      _devices[id] = newDevice;
    else {
      _devices.remove(id);
      _devices[newDevice.id] = newDevice;
    }
    notifyListeners();
  }

  void remove(DeviceModel device) {
    assert(device.id != null);
    _devices.remove(device.id);

    notifyListeners();
  }

  void removeById(int id) {
    assert(id != null);
    _devices.remove(id);

    notifyListeners();
  }

  int getCount() {
    return _devices.length;
  }

  DeviceModel getByPosition(index) {
    assert(index<_devices.length);
    var  key = _devices.keys.toList()[index];
    return _devices[key]!;
  }

  int getId() => _currentId;
  void setId(id) {
    _currentId = id;
    notifyListeners();
  }
  DeviceModel? get device => _devices[_currentId];
}
