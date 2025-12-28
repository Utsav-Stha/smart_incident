import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_incident/feature/common/constants/firebase_collection.dart';
import 'package:smart_incident/feature/common/enum/priority_status.dart';
import 'package:smart_incident/feature/incident_form/model/incident_model.dart';
import 'package:smart_incident/utils/app_config.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';

final incidentFormController =
    StateNotifierProvider<IncidentFormController, GenericState<bool>>(
      (ref) => IncidentFormController(InitialState<bool>()),
    );

class IncidentFormController extends StateNotifier<GenericState<bool>> {
  IncidentFormController(super.state);

  Future<void> createNewIncident({
    required String title,
    required String incidentType,
    required String description,
    required PriorityStatus priority,
    String? imageUrl,
  }) async {
    try {
      state = LoadingState<bool>();
      FirebaseFirestore db = FirebaseFirestore.instance;
      await Future.delayed(Duration.zero);
      final incidentFormModel = IncidentModel(
        title: title,
        incidentTypes: incidentType,
        description: description,
        priority: priority,
        createdDate: DateTime.now().toIso8601String(),
        imageUrl: "aaasdfasdf",
      );
      final docRef = db
          .collection(FirebaseCollection.incidentCollection)
          .doc(AppConfig.instance.userId ?? "")
          .collection(FirebaseCollection.userIncidentCollection)
          .doc(DateTime.now().toIso8601String());
      await docRef.set(incidentFormModel.toJson());
      state = SuccessState(data: true);
    } catch (e, s) {
      state = ErrorState<bool>(error: e.toString(), stackTrace: s);
    }
  }
}
