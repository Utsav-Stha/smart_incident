import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashView extends ConsumerStatefulWidget {
  static const String splashViewRoute = "/splashViewRoute";

  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("data"),
    );
  }
}
