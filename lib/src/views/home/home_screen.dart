import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/bottom_nav_bar.dart';
import '../../providers/suduck_timer/suduck_timer_provider_2_0.dart'; // Corrected import path
import '../../../core/theme/colors/app_color.dart';
import '../../../core/widgets/admob_widget.dart';
import '../white_noise/drawer_white_noise_controller.dart';
import 'home_seg1_screen.dart';
import 'widgets/breathing_exercise_widget.dart'; // Import the new widget
import 'home_seg2_screen.dart';
import 'home_seg3_screen.dart';

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
  // Change to ConsumerStatefulWidget
  @override
  ConsumerState<HomeScreen> createState() =>
      _HomeScreenState(); // Change to ConsumerState
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _startDrawerAnimation();
  }

  void _startDrawerAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _animationController.repeat();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
