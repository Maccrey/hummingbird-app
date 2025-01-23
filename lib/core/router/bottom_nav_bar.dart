import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../src/views/home/widgets/timer/suduck_timer_modal_widget.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(context),
      selectedFontSize: 12,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          // case 1:
          //   context.go('/social');
          //   break;
          case 1:
            showModalBottomSheet(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              context: context,
              builder: (context) => SuduckTimerModalWidget(),
            );
            break;
          case 2:
            context.go('/statistics');
            break;
          case 3:
            context.go('/more');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: tr('홈'),
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.groups),
        //   label: tr('소셜'),
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: tr('타이머'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart_rounded),
          label: tr('통계'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_rounded),
          label: tr('더보기'),
        ),
      ],
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    switch (currentPath) {
      case '/':
        return 0;
      // case '/social':
      //   return 1;
      case '/timer':
        return 1;
      case '/statistics':
        return 2;
      case '/more':
        return 3;
      default:
        return 0;
    }
  }
}
