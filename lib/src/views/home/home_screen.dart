import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/services/whitenoise/audio_service.dart';
import '../../models/whitenoise/audio_model.dart';

import '../../../core/router/bottom_nav_bar.dart';
import '../../providers/suduck_timer/suduck_timer_provider_2_0.dart'; // Corrected import path
import '../../../core/theme/colors/app_color.dart';
import '../../../core/widgets/admob_widget.dart';
import '../white_noise/drawer_white_noise_controller.dart';
import 'home_seg1_screen.dart';
import 'widgets/breathing_exercise_widget.dart'; // Import the new widget
import 'home_seg2_screen.dart';
import 'home_seg3_screen.dart';
import '../../viewmodels/app_setting/app_setting_view_model.dart';

final List<SegmentTab> _tabs = [
  SegmentTab(
    label: tr("HomeSegmentBar.Timer"),
    textColor: Colors.black,
    color: Colors.white,
    backgroundColor: AppColor.themeGrey,
  ),
  SegmentTab(
    label: tr("HomeSegmentBar.Dday"),
    textColor: Colors.black,
    color: Colors.white,
    backgroundColor: AppColor.themeGrey,
  ),
  SegmentTab(
    label: tr("HomeSegmentBar.Summary"),
    textColor: Colors.black,
    color: Colors.white,
    backgroundColor: AppColor.themeGrey,
  ),
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDrawerOpen = false;
  bool _isAnyAudioPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateAnimationState(bool isPlaying) {
    if (isPlaying && !_isDrawerOpen && !_animationController.isAnimating) {
      _animationController.repeat();
    } else if (!isPlaying && _animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 화이트 노이즈 상태 실시간 감시
    final audioList = ref.watch(multiAudioViewModelProvider);
    final isAnyAudioPlaying =
        audioList.any((audio) => audio.playbackState == PlaybackState.playing);
    final isAnimationEnabled =
        ref.watch(appSettingViewModelProvider).whiteNoiseAnimation;

    // 상태가 변경되었을 때만 애니메이션 업데이트
    if (isAnyAudioPlaying != _isAnyAudioPlaying) {
      _isAnyAudioPlaying = isAnyAudioPlaying;
      _updateAnimationState(isAnyAudioPlaying);
    }

    return WillPopScope(
      onWillPop: () async {
        if (_isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }
        return false;
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.themeGrey,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SegmentedTabControl(
                selectedTabTextColor: Colors.black,
                tabPadding: EdgeInsets.zero,
                height: 36.h,
                tabs: _tabs,
              ),
            ),
          ),
          drawer: DrewerWhiteNoiseController(),
          drawerScrimColor: Colors.black54,
          drawerEdgeDragWidth: 60.w,
          onDrawerChanged: (isOpened) {
            setState(() {
              _isDrawerOpen = isOpened;
              if (!isOpened) {
                _updateAnimationState(_isAnyAudioPlaying);
              }
            });
          },
          body: Stack(
            children: [
              SafeArea(
                child: TabBarView(
                  children: [
                    Seg1Screen(),
                    Seg2Screen(),
                    Seg3Screen(),
                  ],
                ),
              ),
              if (_isAnyAudioPlaying && !_isDrawerOpen && isAnimationEnabled)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.primaryDelta! > 0) {
                        Scaffold.of(context).openDrawer();
                      }
                    },
                    child: Container(
                      width: 60.w,
                      color: Colors.transparent,
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Center(
                            child: Transform.translate(
                              offset: Offset(
                                  -10 + (10 * _animationController.value), 0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.red.withOpacity(
                                    0.6 * _animationController.value),
                                size: 24.w,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(),
        ),
      ),
    );
  }
}
