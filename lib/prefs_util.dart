import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtil {
  static PrefsUtil? _singleton;
  static SharedPreferences? _prefs;

  static Future<PrefsUtil?> getInstance() async {
    if (_singleton == null) {
      var singleton = PrefsUtil._();
      await singleton._init();
      _singleton = singleton;
    }
    return _singleton;
  }

  PrefsUtil._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool>? putObject(String key, Object value) {
    return _prefs?.setString(key, json.encode(value));
  }

  /// get obj.
  static T? getObj<T>(String key, T Function(Map<String, dynamic> v) f, {T? defValue}) {
    Map<String, dynamic>? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map<String, dynamic>? getObject(String key) {
    String? _data = _prefs?.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  static Future<bool>? putObjectList(String key, List<Object> list) {
    List<String>? _dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return _prefs?.setStringList(key, _dataList);
  }

  /// get obj list.
  static List<T>? getObjList<T>(String key, T Function(Map v) f) {
    List<Map>? dataList = getObjectList(key);
    List<T>? list = dataList?.map((value) {
      return f(value);
    }).toList();
    return list;
  }

  /// get object list.
  static List<Map>? getObjectList(String key) {
    List<String>? dataLis = _prefs?.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    }).toList();
  }

  /// get string.
  static String? getString(String key, {String? defValue = ''}) {
    return _prefs?.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool>? putString(String key, String value) {
    return _prefs?.setString(key, value);
  }

  /// get bool.
  static bool? getBool(String key, {bool? defValue = false}) {
    return _prefs?.getBool(key) ?? defValue;
  }

  static bool? getBoolNotDefault(String key) {
    return _prefs?.getBool(key);
  }

  /// put bool.
  static Future<bool>? putBool(String key, bool value) {
    return _prefs?.setBool(key, value);
  }

  /// get int.
  static int? getInt(String key, {int? defValue = 0}) {
    return _prefs?.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool>? putInt(String key, int value) {
    return _prefs?.setInt(key, value);
  }

  /// get double.
  static double? getDouble(String key, {double? defValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool>? putDouble(String key, double value) {
    return _prefs?.setDouble(key, value);
  }

  /// get string list.
  static List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  /// put string list.
  static Future<bool>? putStringList(String key, List<String> value) {
    return _prefs?.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {Object? defValue}) {
    return _prefs?.get(key) ?? defValue;
  }

  /// have key.
  static bool? haveKey(String key) {
    return _prefs?.getKeys().contains(key);
  }

  /// contains Key.
  static bool? containsKey(String key) {
    return _prefs?.containsKey(key);
  }

  /// get keys.
  static Set<String>? getKeys() {
    return _prefs?.getKeys();
  }

  /// remove.
  static Future<bool>? remove(String key) {
    return _prefs?.remove(key);
  }

  /// clear.
  static Future<bool>? clear() {
    return _prefs?.clear();
  }

  /// Fetches the latest values from the host platform.
  static Future<void>? reload() {
    return _prefs?.reload();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _prefs != null;
  }

  /// get Sp.
  static SharedPreferences? getSp() {
    return _prefs;
  }
}

double? checkDouble(dynamic value) {
  if(value is double) return value;
  if(value is int) return value.toDouble();
  if(value is String) return double.tryParse(value);
  return null;
}