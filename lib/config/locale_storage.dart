import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:renmoney_weatherapp/utilities/constants.dart';
import 'package:logging/logging.dart';
import 'package:renmoney_weatherapp/utilities/utils.dart';

class LocalStorageService {
  final _prefs = Hive.box(dbName);
  final log = Logger('Local Storage Service');
  final FlutterSecureStorage storage;

  LocalStorageService(this.storage);

  static Future<void> initializeDb() async {
    await Hive.initFlutter();
    await Hive.openBox(dbName);
    Logger.root.info("Initialized HIVE............");
  }

  dynamic saveData(String key, dynamic data) async {
    if (getData(key) != null) {
      log.info("Removing record with key $key");
      await remove(key);
    }
    await _saveData(key, data);
    log.info("Saved $key with data $data");
    return data;
  }

  dynamic getData(String key) {
    return _prefs.get(key);
  }

  Future<void> remove(String key) async {
    if (getData(key) != null) {
      await _prefs.delete(key);
    }
  }

  dynamic saveJsonData(String key, dynamic data) async {
    if (getData(key) != null) {
      log.info("Removing json record with key $key");
      await remove(key);
    }
    await _saveData(key, jsonEncode(data));
    log.info("Saved record with key $key");
    return data;
  }

  dynamic getJsonData(String key) {
    var data = getData(key);
    return (data != null) ? jsonDecode(data) : null;
  }

  _saveData(String key, dynamic data) async {
    await _prefs.put(key, data);
  }

  dynamic getDynamicData(String key, bool isJson) {
    return isJson ? getJsonData(key) : getData(key);
  }


// Flutter Storage starts here...
  Future<void> saveSecureJson(String key, dynamic data) async {
    if (Platform.isIOS) {
      const options = IOSOptions(
        synchronizable: false,
        accessibility: KeychainAccessibility.first_unlock,
      );
      await storage.write(key: key, value: jsonEncode(data), iOptions: options);
      log.info("Saved secured record with key $key");
      return;
    }
    await storage.write(key: key, value: jsonEncode(data));
    log.info("Saved secured record with key $key");
  }

  Future<dynamic> getSecureJson(String key) async {
    // Bug: Problem reading from the storage...
    var value = await storage.read(key: key);
    return isNotEmpty(value) ? jsonDecode(value!) : null;
  }

  Future<void> deleteSecureJson(String key) async {
    var value = await storage.read(key: key);
    if (isNotEmpty(value)) {
      await storage.delete(key: key);
      log.info("Deleted secured record with key $key");
    }
  }

  Future<void> saveSecure(String key, String data) async {
    if (Platform.isIOS) {
      const options =
          IOSOptions(accessibility: KeychainAccessibility.first_unlock);
      await storage.write(key: key, value: data, iOptions: options);
      log.info("Saved secured record with key $key");
      return;
    }
    await storage.write(key: key, value: data);
    log.info("Saved secured record with key $key");
  }

  Future<dynamic> getSecure(String key) async {
    var value = await storage.read(key: key);
    return isNotEmpty(value) ? value : null;
  }

  Future<void> deleteSecure(String key) async {
    var value = await storage.read(key: key);
    if (isNotEmpty(value)) {
      await storage.delete(key: key);
      log.info("Deleted secured record with key $key");
    }
  }
}
