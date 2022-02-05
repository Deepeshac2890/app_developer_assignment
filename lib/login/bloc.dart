import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Resources/StringConstants.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState().init());

  final FirebaseAuth fa = FirebaseAuth.instance;
  String error = "";

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    } else if (event is LoginUsingMailEvent) {
      yield LoadingState();
      bool success = await loginUsingEmail(event.emailID, event.password);

      if (success) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('AlreadyLoggedIn', true);
        error = "";
      }

      yield LoginSuccess(success, error);
    }
  }

  Future<bool> loginUsingEmail(String emailID, String password) async {
    try {
      await fa.signInWithEmailAndPassword(email: emailID, password: password);
      return true;
    } catch (e) {
      print(e);
      if (e.toString().contains(incorrectPasswordErrorFirebase)) {
        error = "InvalidPasswordSnackBar".i18n();
      }
      return false;
    }
  }

  Future<LoginState> init() async {
    return state.clone();
  }
}
