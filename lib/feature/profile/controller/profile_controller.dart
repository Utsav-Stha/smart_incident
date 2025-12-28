import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';
import 'package:smart_incident/feature/common/constants/firebase_collection.dart';
import 'package:smart_incident/feature/profile/model/user_model.dart';
import 'package:smart_incident/utils/app_config.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';

final profileController =
    StateNotifierProvider<ProfileController, GenericState<UserModel>>(
      (ref) => ProfileController(InitialState()),
    );

class ProfileController extends StateNotifier<GenericState<UserModel>> {
  ProfileController(super.state);

  Future<void> fetchUserProfile() async {
    await Future.delayed(Duration.zero);
    state = LoadingState();

    try {
      final userId = AppConfig.instance.userId;
      if (userId == null) {
        state = ErrorState(
          error: "User ID not found",
          stackTrace: StackTrace.current,
        );
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection(FirebaseCollection.userCollection)
          .doc(userId)
          .collection(FirebaseCollection.userDetail)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromJson(doc.data()!);
        state = SuccessState(data: user);
      } else {
        state = ErrorState(
          error: "User not found",
          stackTrace: StackTrace.current,
        );
      }
    } catch (e, s) {
      state = ErrorState(error: e.toString(), stackTrace: s);
    }
  }

  Future<bool> updateUserProfile(String name) async {
    try {
      final userId = AppConfig.instance.userId;
      if (userId == null) return false;

      await FirebaseFirestore.instance
          .collection(FirebaseCollection.userCollection)
          .doc(userId)
          .collection(FirebaseCollection.userDetail)
          .doc(userId)
          .update({"name": name});

      await fetchUserProfile();
      return true;
    } catch (e) {
      return false;
    }
  }
}
