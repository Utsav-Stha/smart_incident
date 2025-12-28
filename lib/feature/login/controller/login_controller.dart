import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';
import 'package:smart_incident/feature/common/widgets/custom_toast.dart';
import 'package:smart_incident/utils/app_config.dart';
import 'package:smart_incident/main.dart';

final loginController = ChangeNotifierProvider((ref) => LoginController());

class LoginController extends ChangeNotifier {
  bool isRememberMeChecked = false;
  bool isLoading = false;

  void toggleRememberMe() {
    isRememberMeChecked = !isRememberMeChecked;
    notifyListeners();
  }

  Future<bool> userLogin({
    required String email,
    required String password,
  }) async {
    await Future.delayed(Duration.zero);
    try {
      isLoading = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppConfig.instance.userId = credential.user?.uid;

      Logger().e("heeeere: $credential");
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Logger().e('No user found for that email.');
      } else if (e.code == 'invalid-credential') {
        final context = MyApp.navigatorKey.currentContext;
        if (context != null) {
          CustomToast.show(
            context,
            message: 'Please enter correct email / password.',
            toastEnum: ToastEnum.error,
          );
        }
      }
      return false;
    } catch (e) {
      Logger().e(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
