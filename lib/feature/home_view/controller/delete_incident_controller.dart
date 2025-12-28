import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';
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
    state = LoadingState();
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Future.delayed(Duration.zero);
    try {
      final collectionRef = db
          .collection(FirebaseCollection.incidentCollection)
          .doc(AppConfig.instance.userId ?? "")
          .collection(FirebaseCollection.userIncidentCollection);

      final querySnapshot = await collectionRef
          .where('createdDate', isEqualTo: createdDate)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
      } else {
        await collectionRef.doc(createdDate).delete();
      }
      // final a = await docRef.doc(createdDate).delete();
      state = SuccessState(data: true);
    } catch (e, s) {
      state = ErrorState(error: e.toString(), stackTrace: s);
    }
  }
}
