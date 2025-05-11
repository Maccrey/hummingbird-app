import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../viewmodels/app_setting/app_setting_view_model.dart';

class WhiteNoiseAnimationSwitchWidget extends ConsumerWidget {
  const WhiteNoiseAnimationSwitchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWhiteNoiseAnimation =
        ref.watch(appSettingViewModelProvider).whiteNoiseAnimation;
    final appSettingNotifer = ref.read(appSettingViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              tr('SettingsScreen.AnimationSettings'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            Spacer(),
            Switch(
              activeColor: Colors.indigo,
              value: isWhiteNoiseAnimation,
              onChanged: (value) {
                appSettingNotifer.setWhiteNoiseAnimation(value);
              },
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 30.w, top: 4.h, bottom: 8.h),
          child: Text(
            tr('SettingsScreen.whiteNoiseAnimationDesc'),
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
