import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/style_constants.dart';
import 'package:smart_incident/feature/common/enum/priority_status.dart';

class StatusCard extends StatelessWidget {
  final PriorityStatus status;

  const StatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 6.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: status.getBackgroundColor(),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: StyleConstant.white600Regular13,
      ),
    );
  }
}
