import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/constants/image_constants.dart';
import 'package:smart_incident/feature/login/controller/login_controller.dart';
import 'package:smart_incident/utils/app_routing/app_routes.dart';
import 'package:smart_incident/utils/local_storage/local_storage_service.dart';

class SplashView extends ConsumerStatefulWidget {
  static const String splashViewRoute = "/splashViewRoute";

  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final credentials = await LocalStorageService.getCredentials();
    final rememberMe = credentials['rememberMe'] == 'true';
    final email = credentials['email'];
    final password = credentials['password'];

    if (rememberMe && email != null && password != null) {
      final success = await ref
          .read(loginController)
          .userLogin(email: email, password: password);
      if (success && mounted) {
        Beamer.of(context).beamToReplacementNamed(AppRoutes.homeViewRoute);
        return;
      }
    }

    if (mounted) {
      Beamer.of(context).beamToReplacementNamed(AppRoutes.loginViewRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstant.logoImage, height: 150.h, width: 150.h),
            20.verticalSpace,
            CircularProgressIndicator(strokeWidth: 4.r),
          ],
        ),
      ),
    );
  }
}
