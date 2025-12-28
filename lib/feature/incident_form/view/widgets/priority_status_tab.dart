import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/constants/style_constants.dart';
import 'package:smart_incident/feature/common/enum/priority_status.dart';

class PriorityStatusTab extends StatefulWidget {
  final PriorityStatus status;
  final Function(PriorityStatus value) onTap;

  const PriorityStatusTab({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  State<PriorityStatusTab> createState() => _PriorityStatusTabState();
}

class _PriorityStatusTabState extends State<PriorityStatusTab> {
  @override
  Widget build(BuildContext context) {
    PriorityStatus tempStatus = widget.status;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Priority", style: StyleConstant.black500Regular16),
            5.horizontalSpace,
            Text("*", style: StyleConstant.red600Regular15),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<PriorityStatus>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.black,
              overlayColor: Colors.transparent,
              selectedForegroundColor: AppColors.white,
              selectedBackgroundColor: tempStatus.getBackgroundColor(),
            ),
            segments: const <ButtonSegment<PriorityStatus>>[
              ButtonSegment<PriorityStatus>(
                value: PriorityStatus.low,
                label: Text('Low'),
              ),
              ButtonSegment<PriorityStatus>(
                value: PriorityStatus.medium,
                label: Text('Medium'),
              ),
              ButtonSegment<PriorityStatus>(
                value: PriorityStatus.high,
                label: Text('High'),
              ),
            ],
            expandedInsets: EdgeInsets.zero,
            selected: <PriorityStatus>{tempStatus},
            onSelectionChanged: (Set<PriorityStatus> newSelection) {
              widget.onTap.call(newSelection.first);
            },
          ),
        ),
      ],
    );
  }
}
