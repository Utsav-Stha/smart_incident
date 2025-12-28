import 'dart:ui';
import 'package:smart_incident/feature/common/constants/app_colors.dart';

enum PriorityStatus {
  low,
  medium,
  high;

  static PriorityStatus mapToEnum(String value) {
    switch (value) {
      case "low":
        return PriorityStatus.low;
      case "medium":
        return PriorityStatus.medium;
      case "high":
        return PriorityStatus.high;
      default:
        return PriorityStatus.low;
    }
  }

  Color getBackgroundColor() {
    switch (this) {
      case PriorityStatus.low:
        return AppColors.approvedStatusColor;
      case PriorityStatus.medium:
        return AppColors.pendingStatusColor;
      case PriorityStatus.high:
        return AppColors.rejectedStatusColor;
    }
  }
}
