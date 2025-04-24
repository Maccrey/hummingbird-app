import 'package:StudyDuck/core/widgets/admob_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/enum/mxnRate.dart';
import '../../../core/widgets/mxnContainer.dart';
import 'widgets/settings/timer_stteing/auto_focus_switch_widget.dart';
import 'widgets/settings/timer_stteing/auto_breathing_switch_widget.dart';
import 'widgets/settings/timer_stteing/white_noise_animation_switch_widget.dart';

class TimerSettingScreen extends StatelessWidget {
  const TimerSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('TimerSetting.TimerSetting'),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MxNcontainer(
                  MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
                  MxN_child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      children: [
                        //자동 포커스 모드
                        AutoFocusSwitchWidget(),
                        Divider(),
                        //자동 숨쉬기 연습
                        AutoBreathingSwitchWidget(),
                        // 화이트 노이즈 애니메이션
                        Divider(),
                        WhiteNoiseAnimationSwitchWidget(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                AdMobWidget.showBannerAd(50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
