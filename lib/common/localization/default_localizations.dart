// 语言选择
// Vhsal.com

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:esp_config/common/localization/esp_config_string_base.dart';
import 'package:esp_config/common/localization/esp_config_string_en.dart';
import 'package:esp_config/common/localization/esp_config_string_zh.dart';

///自定义多语言实现
class EspConfigLocalizations {
  final Locale locale;

  EspConfigLocalizations(this.locale);

  static Map<String, EspConfigStringBase> _localizedValues = {
    'en': new EspConfigStringEn(),
    'zh': new EspConfigStringZh(),
  };

  EspConfigStringBase? get currentLocalized {
    if (_localizedValues.containsKey(locale.languageCode)) {
      return _localizedValues[locale.languageCode];
    }
    return _localizedValues["zh"];
  }

  ///通过 Localizations 加载当前的 GSYLocalizations
  ///获取对应的 GSYStringBase
  static EspConfigLocalizations of(BuildContext context) {
    return Localizations.of(context, EspConfigLocalizations);
  }

  ///通过 Localizations 加载当前的 GSYLocalizations
  ///获取对应的 GSYStringBase
  static EspConfigStringBase? i18n(BuildContext context) {
    return (Localizations.of(context, EspConfigLocalizations) as EspConfigLocalizations)
        .currentLocalized;
  }
}
