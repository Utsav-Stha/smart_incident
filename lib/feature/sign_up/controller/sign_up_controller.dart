import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';
import 'package:smart_incident/feature/common/widgets/custom_toast.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';

final signUpController = ChangeNotifierProvider((ref) => SignUpController());

class SignUpController extends ChangeNotifier {
  bool isUploading = false;

  Future<bool> userSignUp({
    required String email,
    required String password,
  }) async {
    try {
      isUploading = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Logger().e(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CustomToast(
          message: 'The password provided is too weak.',
          toastEnum: ToastEnum.warning,
        );
      } else if (e.code.contains('email-already-in-use')) {
        CustomToast(
          message: 'The account already exists for that email.',
          toastEnum: ToastEnum.warning,
        );
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
