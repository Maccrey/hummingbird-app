import 'dart:math';

import 'package:hive/hive.dart';

import '../../../models/setting/user_setting.dart';

class UserSettingLocalDatasource {
  UserSettingLocalDatasource(this._box);
  final Box<UserSetting> _box;

  String get key => 'userSetting';

  Future<void> addUserSetting(UserSetting userSetting) async {
    try {
      await _box.put(key, userSetting);
    } catch (e) {
      // 쓰기 실패 시 박스 초기화 후 재시도
      await _box.delete(key);
      await _box.put(key, userSetting);
    }
  }

  UserSetting getUserSetting() {
    try {
      final userSetting = _box.get(key);
      return userSetting ??
          UserSetting(
            nickname:
                '유저 #${Random().nextInt(300).toString().padLeft(3, '0')} ',
          );
    } catch (e) {
      // Hive 포맷 변경 등으로 읽기 실패 시 기존 데이터 삭제 후 기본값 반환
      _box.delete(key);
      return UserSetting(
        nickname: '유저 #${Random().nextInt(300).toString().padLeft(3, '0')} ',
      );
    }
  }

  Future<void> updateUserSetting(UserSetting updatedUserSetting) async {
    try {
      await _box.put(key, updatedUserSetting);
    } catch (e) {
      // 쓰기 실패 시 박스 초기화 후 재시도
      await _box.delete(key);
      await _box.put(key, updatedUserSetting);
    }
  }
}
