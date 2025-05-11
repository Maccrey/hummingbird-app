import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../core/const/box_keys.dart';
import 'models/setting/app_setting.dart';
import 'models/setting/study_setting.dart';
import 'models/token_model.dart';

Future<void> appInitialize() async {
  final directory = await getApplicationDocumentsDirectory();
  const secureStorage = FlutterSecureStorage();
  var containsEncryptionKey =
      await secureStorage.containsKey(key: BoxKeys.encryptionBoxKey);

  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(
        key: BoxKeys.encryptionBoxKey, value: base64UrlEncode(key));
  }

  var key = base64Url.decode(
      await secureStorage.read(key: BoxKeys.encryptionBoxKey) as String);

  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(TokenModelAdapter());

  await Hive.openBox<TokenModel>(BoxKeys.tokenBoxKey,
      encryptionCipher: HiveAesCipher(key));

  await Hive.openBox<List>(BoxKeys.suduckBoxKey);

  Hive.registerAdapter(StudySettingAdapter());
  await Hive.openBox<StudySetting>(BoxKeys.studySettingBoxKey);

  // 기존 AppSettingAdapter 등록 전에 이미 등록된 어댑터가 있는지 확인
  try {
    // 커스텀 어댑터 등록 (이미 등록된 경우 예외 발생)
    Hive.registerAdapter(AppSettingAdapter());
  } catch (e) {
    // 이미 등록된 경우 무시 (HiveError: TypeAdapter for type AppSetting is already registered.)
    print('AppSettingAdapter 등록 오류 (이미 등록됨): $e');
  }

  await Hive.openBox<AppSetting>(BoxKeys.appSettingBoxKey);
}
