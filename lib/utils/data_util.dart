int strToInt(String str, [int defaultValue = 0]) {
  try {
    return int.parse(str);
  } catch (e) {
    return defaultValue;
  }
}

dynamic strToValueByType(String str, String type) {
  var ret;
  try {
    switch (type) {
      case 'int':
        ret = int.parse(str);
        break;
      case 'float':
        ret = double.parse(str);
        break;
      default:
        ret = str;
    }
    return ret;
  } catch (e) {
    return null;
  }
}
