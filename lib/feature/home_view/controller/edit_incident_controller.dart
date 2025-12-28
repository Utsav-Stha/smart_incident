import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_incident/feature/common/constants/firebase_collection.dart';
import 'package:smart_incident/feature/common/enum/priority_status.dart';
import 'package:smart_incident/feature/incident_form/model/incident_model.dart';
import 'package:smart_incident/utils/app_config.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';

final editIncidentController =
    StateNotifierProvider<EditIncidentController, GenericState>(
      (ref) => EditIncidentController(InitialState()),
    );

class EditIncidentController extends StateNotifier<GenericState> {
  EditIncidentController(super.state);

  Future<void> editIncident({
    required String title,
    required String incidentType,
    required String description,
    required PriorityStatus priority,
    required String createdDate,
    String? imageUrl,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Future.delayed(Duration.zero);
    try {
      final incidentFormModel = IncidentModel(
        title: title,
        incidentTypes: incidentType,
        description: description,
        priority: priority,
        createdDate: createdDate,
        imageUrl: imageUrl ?? "",
      );
      final docRef = db
          .collection(FirebaseCollection.incidentCollection)
          .doc(AppConfig.instance.userId ?? "")
          .collection(FirebaseCollection.userIncidentCollection)
          .doc(DateTime.now().toIso8601String());
      docRef.update(incidentFormModel.toJson());
    } catch (e) {
      print("Erorrr:$e");
    }
  }
}
