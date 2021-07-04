// 设备
// Created by vhsal.com
// Date: 2021-06-03

class DeviceModel {
  int id=0;
  final String deviceModule;
  final String typeName;
  Map<String, dynamic> _items = {};
  DeviceModel(this.id, this.deviceModule, this.typeName, this._items);

  DeviceModel.fromJson(this.deviceModule, this.typeName, Map<String, dynamic> json) {
    assert(json.containsKey("dev_id"));
    assert(json.containsKey("device_module"));
    assert(json["device_module"] == this.deviceModule);
    _items = json;
    id = _items["dev_id"];
  }

  /// Get the item by itemName
  dynamic getItem(String itemCol) => _items[itemCol];
  void setItem(String itemCol, value) => _items[itemCol] = value;
  /// Update the item by itemName
  update(String itemCol, dynamic value) => _items[itemCol] = value;
  Map<String, dynamic> getItems () {
    return _items;
  }
}
