import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_incident/feature/common/constants/firebase_collection.dart';
import 'package:smart_incident/feature/common/widgets/custom_toast.dart';
import 'package:smart_incident/main.dart';
import 'package:smart_incident/utils/app_config.dart';

final signUpController = ChangeNotifierProvider((ref) => SignUpController());

class SignUpController extends ChangeNotifier {
  bool isUploading = false;

  Future<bool> userSignUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      isUploading = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      AppConfig.instance.userId = credential.user?.uid;

      final docRef = db
          .collection(FirebaseCollection.userCollection)
          .doc(AppConfig.instance.userId ?? "")
          .collection(FirebaseCollection.userDetail)
          .doc(AppConfig.instance.userId ?? "");
      await docRef.set({"name": name, "email": email});
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        final context = MyApp.navigatorKey.currentContext;
        if (context != null && context.mounted) {
          CustomToast.show(
            context,
            message: 'The password provided is too weak.',
            toastEnum: ToastEnum.warning,
          );
        }
      } else if (e.code.contains('email-already-in-use')) {
        final context = MyApp.navigatorKey.currentContext;
        if (context != null && context.mounted) {
          CustomToast.show(
            context,
            message: 'The account already exists for that email.',
            toastEnum: ToastEnum.warning,
          );
        }
      }
      return false;
    } catch (e, s) {
      print(e);
      return false;
      // state = ErrorState(error: e as DioException, stackTrace: s);
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}
