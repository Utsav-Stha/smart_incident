import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/constants/image_constants.dart';
import 'package:smart_incident/feature/common/constants/style_constants.dart';
import 'package:smart_incident/feature/common/widgets/custom_text_field.dart';
import 'package:smart_incident/feature/common/widgets/generic_elevated_button.dart';
import 'package:smart_incident/feature/sign_up/controller/sign_up_controller.dart';
import 'package:smart_incident/utils/custom_validator.dart';

class SignUpView extends ConsumerStatefulWidget {
  static const String signUpViewRoute = "/signUpViewRoute";

  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep2 = GlobalKey<FormState>();

  int _currentStep = 0;
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final password = _passwordController.text;

    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigit = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  bool get _isPasswordValid {
    return _hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasDigit &&
        _hasSpecialChar;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void _nextStep() {
    if (_formKeyStep1.currentState!.validate()) {
      setState(() {
        _currentStep = 1;
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyShade100,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 40.r),
        children: [
          20.verticalSpace,
          CircleAvatar(
            radius: 50.r,
            backgroundColor: AppColors.white,
            child: Image.asset(ImageConstant.logoImage),
          ),
          20.verticalSpace,
          Text(
            "Sign In To Manage Your Incident Reports Efficiently",
            textAlign: TextAlign.center,
            style: StyleConstant.grey500Regular18,
          ),
          40.verticalSpace,
          if (_currentStep == 0) _buildStep1() else _buildStep2(),
          20.verticalSpace,
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Already have an account? ",
                style: StyleConstant.grey500Regular14,
                children: [
                  TextSpan(
                    text: "Login",
                    style: StyleConstant.black600Regular14.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        children: [
          CustomTextField(
            title: "Full Name",
            hintText: "Enter your full name",
            controller: _nameController,
            validator: (value) => CustomValidator.validateName(value),
          ),
          20.verticalSpace,
          CustomTextField(
            title: "Email",
            hintText: "Enter your email",
            controller: _emailController,
            validator: (value) => CustomValidator.validateEmail(value),
          ),
          20.verticalSpace,
          GenericElevatedButton(text: "Next", onPressed: _nextStep),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        children: [
          CustomTextField(
            title: "Password",
            hintText: "Enter your password",
            controller: _passwordController,
            isPassword: true,
            validator: (value) {
              if (!_isPasswordValid)
                return 'Password does not meet requirements';
              return null;
            },
          ),
          20.verticalSpace,
          _buildValidationItem('At least 8 characters', _hasMinLength),
          _buildValidationItem('Contains uppercase letter', _hasUppercase),
          _buildValidationItem('Contains lowercase letter', _hasLowercase),
          _buildValidationItem('Contains number', _hasDigit),
          _buildValidationItem('Contains special character', _hasSpecialChar),
          20.verticalSpace,
          CustomTextField(
            title: "Confirm Password",
            enabled: _passwordController.text.isNotEmpty,
            hintText: "Enter your confirm password",
            controller: _confirmPasswordController,
            isPassword: true,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: GenericElevatedButton(
                  text: "Back",
                  onPressed: _previousStep,
                  buttonColor: Colors.grey,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: GenericElevatedButton(
                  text: "Sign Up",
                  onPressed: () async {
                    if (_formKeyStep2.currentState!.validate()) {
                      final bool success = await ref
                          .read(signUpController.notifier)
                          .userSignUp(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                      if (success && context.mounted) {
                        Beamer.of(context).beamBack();
                      }
                    }
                  },
                  isLoading: ref.watch(signUpController).isUploading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValidationItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
