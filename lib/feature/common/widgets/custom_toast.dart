import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:smart_incident/feature/common/constants/app_colors.dart";
import "package:smart_incident/feature/common/constants/style_constants.dart";

class CustomToast {
  static void show(
    BuildContext context, {
    required String message,
    required ToastEnum toastEnum,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(10.r, 0.r, 10.r, 40.r),
        showCloseIcon: true,
        elevation: 0,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: toastEnum.getToastBackgroundColor().withAlpha(100),
          ),
        ),
        backgroundColor: toastEnum.getToastBackgroundColor(),
        closeIconColor: AppColors.white,
        content: Text(message, style: StyleConstant.white600Regular16),
        duration: const Duration(milliseconds: 1200),
        animation: CurvedAnimation(
          parent: const AlwaysStoppedAnimation(1.0),
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInBack,
        ),
        dismissDirection: DismissDirection.down,
      ),
    );
  }
}

enum ToastEnum {
  information,
  warning,
  error,
  success;

  Color getToastBackgroundColor() {
    switch (this) {
      case ToastEnum.information:
        return AppColors.blueColor;
      case ToastEnum.warning:
        return AppColors.pendingStatusColor;
      case ToastEnum.error:
        return AppColors.rejectedStatusColor;
      case ToastEnum.success:
        return AppColors.approvedStatusColor;
    }
  }
}
