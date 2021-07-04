// 语言选择
// Vhsal.com
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esp_config/common/localization/default_localizations.dart';


class EspConfigLocalizationsDelegate extends LocalizationsDelegate<EspConfigLocalizations> {

  EspConfigLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    ///支持中文和英语
    return true;
  }

  ///根据locale，创建一个对象用于提供当前locale下的文本显示
  @override
  Future<EspConfigLocalizations> load(Locale locale) {
    return new SynchronousFuture<EspConfigLocalizations>(new EspConfigLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<EspConfigLocalizations> old) {
    return false;
  }

  ///全局静态的代理
  static EspConfigLocalizationsDelegate delegate = new EspConfigLocalizationsDelegate();
}
