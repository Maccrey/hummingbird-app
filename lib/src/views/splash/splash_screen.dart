import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/delay.dart';
import '../../providers/auth/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    delay(() async {
      final isLoggedIn = ref.watch(authProvider);

      if (!isLoggedIn) {
        context.pushReplacement('/login');
      } else {
        context.pushReplacement('/');
      }
    }, seconds: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Hummingbird Logo'),
        ),
      ),
    );
  }
}
