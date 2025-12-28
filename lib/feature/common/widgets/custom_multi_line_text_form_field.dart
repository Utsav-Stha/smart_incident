import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/constants/style_constants.dart';

class CustomMultiLineTextFormField extends StatefulWidget {
  final double? height;
  final String? title;
  final bool? isRequired;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool text;
  final TextInputType keyboardType;
  final int? length;
  final String? hintText;
  final MaxLengthEnforcement? enforcement;
  final IconData? icon;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final bool editable;
  final int? maxLines;
  final Color? fillColor;
  final bool enabled;

  const CustomMultiLineTextFormField({
    super.key,
    this.text = false,
    this.isRequired = true,
    this.enforcement,
    this.keyboardType = TextInputType.multiline,
    this.length,
    this.controller,
    this.validator,
    this.hintText,
    this.icon,
    this.onTap,
    this.onChanged,
    this.editable = false,
    this.title,
    this.maxLines,
    this.height,
    this.fillColor,
    this.enabled = true,
  });

  @override
  State<CustomMultiLineTextFormField> createState() =>
      _CustomMultiLineTextFormFieldState();
}

class _CustomMultiLineTextFormFieldState
    extends State<CustomMultiLineTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Row(
            children: [
              Text(widget.title!, style: StyleConstant.black600Regular14),
              if (widget.isRequired ?? false) ...[
                5.horizontalSpace,
                Text("*", style: StyleConstant.red600Regular15),
              ],
            ],
          ),
          5.verticalSpace,
        ],
        SizedBox(
          height: widget.height,
          child: Center(
            child: InkWell(
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!();
                }
              },
              child: TextFormField(
                enabled: widget.editable,
                controller: widget.controller,
                validator: widget.validator,
                obscureText: widget.text,
                keyboardType: widget.keyboardType,
                maxLength: widget.length,
                maxLengthEnforcement: widget.enforcement,
                onChanged: widget.onChanged,
                minLines: null,
                maxLines: null,
                expands: true,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: StyleConstant.black500Regular18,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  counterText: "",
                  hintStyle: StyleConstant.grey500Regular14,

                  errorStyle: StyleConstant.red600Regular15,
                  suffixIcon: widget.icon != null
                      ? InkWell(
                          onTap: widget.onTap,
                          child: Icon(
                            widget.icon,
                            color: AppColors.black,
                            size: 30.r,
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor:
                      widget.fillColor ??
                      (widget.enabled
                          ? AppColors.white
                          : AppColors.greyShade300),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: AppColors.borderLine,
                      width: 1.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: AppColors.borderLine,
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: AppColors.borderLine,
                      width: 1.w,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColors.red, width: 1.w),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColors.red, width: 1.w),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
