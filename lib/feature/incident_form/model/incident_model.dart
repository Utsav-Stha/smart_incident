import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_incident/feature/common/enum/priority_status.dart';

class IncidentModel {
  String title;
  String incidentTypes;
  String description;
  PriorityStatus priority;
  String createdDate;
  String imageUrl;

  IncidentModel({
    required this.title,
    required this.incidentTypes,
    required this.priority,
    required this.description,
    required this.createdDate,
    required this.imageUrl,
  });

  factory IncidentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return IncidentModel(
      title: data?['title'] ?? "",
      incidentTypes: data?['incidentTypes'] ?? "",
      priority: PriorityStatus.mapToEnum(data?['priority'] ?? ""),
      description: data?['description'] ?? "",
      createdDate: data?['createdDate'] ?? "",
      imageUrl: data?['imageUrl'] ?? "",
    );
  }

  Map<String, String> toJson() {
    return {
      "title": title,
      "incidentTypes": incidentTypes,
      "priority": priority.name,
      "description": description,
      "createdDate": createdDate,
      "imageUrl": imageUrl,
    };
  }

  factory IncidentModel.fromJson(Map<String, dynamic> data) => IncidentModel(
    title: data['title'] ?? "",
    incidentTypes: data['incidentTypes'] ?? "",
    priority: PriorityStatus.mapToEnum(data['priority'] ?? ""),
    description: data['description'] ?? "",
    createdDate: data['createdDate'] ?? "",
    imageUrl: data['imageUrl'] ?? "",
  );

  static List<IncidentModel> listFromJson(Object data) {
    if ((data as List).isEmpty) {
      return [];
    } else {
      return (data).map((e) => IncidentModel.fromJson(e)).toList();
    }
  }
}
