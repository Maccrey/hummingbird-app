import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/setting/app_setting.dart';
import '../../repositories/app_setting/app_setting_repository.dart';

part 'app_setting_view_model.g.dart';

@riverpod
class AppSettingViewModel extends _$AppSettingViewModel {
  late final AppSettingRepository repository;

  @override
  AppSetting build() {
    repository = ref.watch(appSettingRepositoryProvider);
    return repository.getAppSetting();
  }

  Future<void> updateAppSetting({
    String? updatedColor,
    int? updatedFontSize,
    String? updatedLanguage,
    bool? updatedAutoFocusMode,
    bool? updatedAutoBreathingExercise,
    bool? updatedWhiteNoiseAnimation,
  }) async {
    final currentAppSetting = repository.getAppSetting();
    final updatedAppSetting = currentAppSetting.copyWith(
      color: updatedColor ?? currentAppSetting.color,
      fontSize: updatedFontSize ?? currentAppSetting.fontSize,
      language: updatedLanguage ?? currentAppSetting.language,
      autoFocusMode: updatedAutoFocusMode ?? currentAppSetting.autoFocusMode,
      autoBreathingExercise: updatedAutoBreathingExercise ??
          currentAppSetting.autoBreathingExercise,
      whiteNoiseAnimation:
          updatedWhiteNoiseAnimation ?? currentAppSetting.whiteNoiseAnimation,
    );
    await repository.updateAppSetting(updatedAppSetting);
    state = updatedAppSetting;
  }

  Future<void> setWhiteNoiseAnimation(bool value) async {
    await updateAppSetting(updatedWhiteNoiseAnimation: value);
  }

  bool get isFirstInstalled => repository.checkIsFirstInstalled();
}
