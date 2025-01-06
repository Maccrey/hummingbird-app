import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hummingbird/src/providers/auth/auth_provider.dart';
import 'package:hummingbird/src/views/splash/app_initialize.dart';

import '../../../core/utils/delay.dart';

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
      await appInitialize();

      final isLoggedIn = ref.watch(authProvider);

      if (!isLoggedIn) {
        if (!mounted) {
          return;
        }
        context.pushReplacement('/login');
      } else {
        if (!mounted) {
          return;
        }
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
