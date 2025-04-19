import 'package:StudyDuck/core/widgets/admob_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/bottom_nav_bar.dart';
import '../white_noise/drawer_white_noise_controller.dart';
import 'widgets/leard_board_widget.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr("Rank.Rank")),
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 0,
          elevation: 0,
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
              child: Column(
                children: [
                  LeaderboardWidget(),
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
                            color: Colors.red
                                .withOpacity(0.6 * _animationController.value),
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
    );
  }
}
