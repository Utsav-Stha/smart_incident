import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_incident/feature/common/constants/firebase_collection.dart';
import 'package:smart_incident/feature/incident_form/model/incident_model.dart';
import 'package:smart_incident/utils/app_config.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';

final homeController =
    StateNotifierProvider<HomeController, GenericState<List<IncidentModel>>>(
      (ref) => HomeController(InitialState()),
    );

class HomeController extends StateNotifier<GenericState<List<IncidentModel>>> {
  HomeController(super.state);

  Future<void> fetchIncidentList() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Future.delayed(Duration.zero);
    state = LoadingState();
    try {
      final docRef = await db
          .collection(FirebaseCollection.incidentCollection)
          .doc(AppConfig.instance.userId ?? "")
          .collection(FirebaseCollection.userIncidentCollection)
          .get();

      state = SuccessState(
        data: IncidentModel.listFromJson(
          docRef.docs.map((e) => e.data()).toList(),
        ),
      );
    } catch (e, s) {
      state = ErrorState(error: e.toString(), stackTrace: s);
    }
  }
}
