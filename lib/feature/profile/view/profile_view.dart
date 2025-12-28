import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/constants/style_constants.dart';
import 'package:smart_incident/feature/common/widgets/animated_empty_state.dart';
import 'package:smart_incident/feature/common/widgets/custom_text_field.dart';
import 'package:smart_incident/feature/common/widgets/generic_elevated_button.dart';
import 'package:smart_incident/feature/profile/controller/profile_controller.dart';
import 'package:smart_incident/feature/profile/model/user_model.dart';
import 'package:smart_incident/utils/custom_validator.dart';
import 'package:smart_incident/utils/state_management/generic_state_handler.dart';

class ProfileView extends ConsumerStatefulWidget {
  static const String profileViewRoute = "/profileViewRoute";

  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileController.notifier).fetchUserProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyShade100,
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        leading: InkWell(
          onTap: () => Beamer.of(context).beamBack(),
          splashFactory: NoSplash.splashFactory,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.grey,
            size: 30.r,
          ),
        ),
        centerTitle: true,
        title: Text("Profile", style: StyleConstant.black500Regular18),
      ),
      body: GenericStateHandler<UserModel>(
        state: ref.watch(profileController),
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onError: () => Expanded(
          child: const Center(
            child: AnimatedEmptyState(titleMessage: "Error loading profile"),
          ),
        ),
        onEmpty: (_) => Expanded(
          child: const Center(
            child: AnimatedEmptyState(titleMessage: "No profile data"),
          ),
        ),
        onLoaded: (user) {
          if (_nameController.text.isEmpty && user.name != null) {
            _nameController.text = user.name!;
          }
          if (_emailController.text.isEmpty && user.email != null) {
            _emailController.text = user.email!;
          }

          return Padding(
            padding: EdgeInsets.all(20.r),
            child: Form(
              key: _formKey,
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
                    enabled: false,
                  ),
                  40.verticalSpace,
                  GenericElevatedButton(
                    text: "Update",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await ref
                            .read(profileController.notifier)
                            .updateUserProfile(_nameController.text);
                        if (success && context.mounted) {
                          Beamer.of(context).beamBack();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
