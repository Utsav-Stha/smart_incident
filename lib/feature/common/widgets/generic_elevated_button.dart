import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:smart_incident/feature/common/constants/app_colors.dart";
import "package:smart_incident/feature/common/constants/style_constants.dart";

class GenericElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? textColor;
  final Color? buttonColor;
  final double? width;
  final double height;
  final double borderRadius;

  const GenericElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.textColor,
    this.buttonColor,
    this.width,
    this.height = 56,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onPressed,
          child: Container(
            width: width ?? double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: buttonColor ?? AppColors.blueColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5.r,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor ?? AppColors.white,
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: StyleConstant.black500Regular18.copyWith(
                      color: textColor?? AppColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
