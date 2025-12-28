import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/enum/priority_status.dart';
import 'package:smart_incident/feature/common/widgets/row_detail.dart';
import 'package:smart_incident/feature/common/widgets/status_card.dart';
import 'package:smart_incident/feature/incident_form/model/incident_model.dart';
import 'package:smart_incident/feature/incident_form/model/incident_type_model.dart';

class IncidentCard extends StatelessWidget {
  final IncidentModel data;

  const IncidentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          RowDetail(
            rightTitle: "Incident Type",
            rightValue: data.incidentTypes,
            leftTitle: "Title",
            leftValue: data.title,
          ),
          10.verticalSpace,
          RowDetail(
            rightTitle: "Status",
            rightValue: "",
            rightWidget: StatusCard(status: data.priority),
            leftTitle: "Created At",
            leftValue: data.createdDate,
          ),
        ],
      ),
    );
  }
}
