import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Resources/StringConstants.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState().init());

  final FirebaseAuth fa = FirebaseAuth.instance;

  final FirebaseFirestore fs = FirebaseFirestore.instance;
  String error = "";

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    } else if (event is LoginUsingMailEvent) {
      yield LoadingState();
      bool success = await loginUsingEmail(event.userName, event.password);

      if (success) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('AlreadyLoggedIn', true);
        error = "";
      }

      yield LoginSuccess(success, error);
    }
  }

  Future<bool> loginUsingEmail(String userName, String password) async {
    try {
      // Get emailId from Username
      var data = await fs.collection('Usernames').doc(userName).get();
      var objData = await data.data();
      if (objData != null) {
        String emailID = await objData['emailID'];
        await fa.signInWithEmailAndPassword(email: emailID, password: password);
        return true;
      } else {
        error = "LoginError".i18n();
        return false;
      }
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
