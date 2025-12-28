import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/constants/image_constants.dart';
import 'package:smart_incident/feature/common/constants/style_constants.dart';
import 'package:smart_incident/feature/common/widgets/custom_text_field.dart';
import 'package:smart_incident/feature/common/widgets/custom_toast.dart';
import 'package:smart_incident/feature/common/widgets/generic_elevated_button.dart';
import 'package:smart_incident/feature/login/controller/login_controller.dart';
import 'package:smart_incident/utils/app_routing/app_routes.dart';
import 'package:smart_incident/utils/custom_validator.dart';
import 'package:smart_incident/utils/local_storage/local_storage_service.dart';

class LoginView extends ConsumerStatefulWidget {
  static const String loginViewRoute = "/loginViewRoute";

  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyShade100,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 40.r),
        children: [
          20.verticalSpace,
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Welcome To",
                style: StyleConstant.black500Regular24,
                children: [
                  TextSpan(
                    text: "\nSmart Incident",
                    style: StyleConstant.black700Regular40,
                  ),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          CircleAvatar(
            radius: 100.r,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200.r),
              child: Image.asset(ImageConstant.loginReportImage),
            ),
          ),
          20.verticalSpace,
          Center(
            child: Text(
              "Manage your incident reports efficiently",
              style: StyleConstant.grey500Regular18,
            ),
          ),
          40.verticalSpace,
          CustomTextField(
            title: "Email",
            hintText: "Enter your email",
            controller: emailController,
            validator: (value) => CustomValidator.validateEmail(value),
          ),
          20.verticalSpace,
          CustomTextField(
            title: "Password",
            hintText: "Enter your password",
            controller: passwordController,
            isPassword: true,
          ),
          Row(
            children: [
              Checkbox(
                visualDensity: VisualDensity.compact,
                value: ref.watch(loginController).isRememberMeChecked,
                activeColor: AppColors.blueColor,
                onChanged: (newValue) =>
                    ref.read(loginController).toggleRememberMe(),
              ),
              Text("Remember me", style: StyleConstant.grey500Regular14),
            ],
          ),
          20.verticalSpace,
          GenericElevatedButton(
            text: "Login",
            isLoading: ref.watch(loginController).isLoading,
            onPressed: () async {
              final success = await ref
                  .read(loginController)
                  .userLogin(
                    email: emailController.text,
                    password: passwordController.text,
                  );
              if (success) {
                if (ref.read(loginController).isRememberMeChecked) {
                  await LocalStorageService.saveCredentials(
                    email: emailController.text,
                    password: passwordController.text,
                    rememberMe: true,
                  );
                } else {
                  await LocalStorageService.clearCredentials();
                }

                CustomToast.show(
                  context,
                  message: "Logged in successfully",
                  toastEnum: ToastEnum.success,
                );
                Beamer.of(
                  context,
                ).beamToReplacementNamed(AppRoutes.homeViewRoute);
              } else {
                CustomToast.show(
                  context,
                  message: "Failed to login. Please try again later",
                  toastEnum: ToastEnum.error,
                );
              }
            },
          ),
          20.verticalSpace,
          InkWell(
            onTap: () =>
                Beamer.of(context).beamToNamed(AppRoutes.signUpViewRoute),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: StyleConstant.grey500Regular14,
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: StyleConstant.black600Regular14.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
