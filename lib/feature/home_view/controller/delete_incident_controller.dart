import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_incident/feature/common/constants/firebase_collection.dart';
import 'package:smart_incident/feature/incident_form/model/incident_model.dart';
import 'package:smart_incident/utils/app_config.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';

final deleteIncidentController =
    StateNotifierProvider<DeleteIncidentController, GenericState>(
      (ref) => DeleteIncidentController(InitialState()),
    );

class DeleteIncidentController extends StateNotifier<GenericState> {
  DeleteIncidentController(super.state);

  Future<void> deleteIncident({required String createdDate}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Future.delayed(Duration.zero);
    try {
      final docRef = db
          .collection(FirebaseCollection.incidentCollection)
          .doc(AppConfig.instance.userId ?? "")
          .collection(FirebaseCollection.userIncidentCollection);
      docRef.doc(createdDate).delete();
    } catch (e) {
      print("Erorrr:$e");
    }
  }
}
