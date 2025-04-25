import 'package:hive/hive.dart';

import '../../../models/setting/app_setting.dart';

class AppSettingLocalDatasource {
  AppSettingLocalDatasource(this._box);

  final Box<AppSetting> _box;

  String get _key => 'appSetting';

  AppSetting getAppSetting() {
    try {
      final appSetting = _box.get(_key);
      return appSetting ?? AppSetting();
    } catch (e) {
      _box.delete(_key);
      return AppSetting();
    }
  }

  Future<void> updateAppSetting(AppSetting updatedAppSetting) async {
    try {
      await _box.put(_key, updatedAppSetting);
    } catch (e) {
      // 쓰기 실패 시 박스 초기화 후 재시도
      await _box.delete(_key);
      await _box.put(_key, updatedAppSetting);
    }
  }

  bool checkIsFirstInstalled() {
    try {
      final isFirstInstalled = getAppSetting().isFirstInstalled;
      if (isFirstInstalled) {
        updateAppSetting(AppSetting(isFirstInstalled: false));
      }
      return isFirstInstalled;
    } catch (e) {
      // 읽기/쓰기 실패 시 초기화하고 첫 실행으로 처리
      _box.delete(_key);
      updateAppSetting(AppSetting(isFirstInstalled: false));
      return true;
    }
  }
}
