import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/style_constants.dart';

class RowDetail extends StatelessWidget {
  final String rightTitle;
  final String rightValue;
  final String leftTitle;
  final String leftValue;
  final Widget? leftWidget;
  final Widget? rightWidget;

  const RowDetail({
    super.key,
    required this.rightTitle,
    required this.rightValue,
    required this.leftTitle,
    required this.leftValue,
    this.leftWidget,
    this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(leftTitle, style: StyleConstant.grey500Regular14),
              5.verticalSpace,
              leftWidget ??
                  Text(leftValue, style: StyleConstant.black500Regular16),
            ],
          ),
        ),
        (rightTitle.isEmpty)
            ? const SizedBox.shrink()
            : Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(rightTitle, style: StyleConstant.grey500Regular14),
                    5.verticalSpace,
                    rightWidget ??
                        Text(
                          rightValue,
                          style: StyleConstant.black500Regular16,
                        ),
                  ],
                ),
              ),
      ],
    );
  }
}
