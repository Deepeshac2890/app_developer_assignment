import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localization/localization.dart';

import '../Resources/StringConstants.dart';
import 'event.dart';
import 'state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationState().init());
  final fa = FirebaseAuth.instance;
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  bool isUserNameUnique = true;
  String error = '';

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    } else if (event is RegisterUser) {
      yield LoadingState();
      bool isUserNameUnique = await validateUserNameUniqueness(event.userName);
      if (isUserNameUnique) {
        bool success = await _register(
            event.emailID, event.password, event.name, event.userName);
        yield RegistrationSuccess(error, success);
      } else {
        yield UserNameDuplicate();
      }
    }
  }

  Future<bool> validateUserNameUniqueness(String userName) async {
    var userNameEntry = await fs.collection('Usernames').doc(userName).get();
    if (userNameEntry.exists) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> _register(
      String emailId, String password, String fName, String userName) async {
    try {
      var userCred = await fa.createUserWithEmailAndPassword(
          email: emailId, password: password);
      var uid = await userCred.user?.uid;

      Random random = Random();
      int tp = random.nextInt(100);
      int tw = random.nextInt(tp);
      double percentage = tw / tp * 100;
      int maxRating = 4000;
      int minRating = 2000;
      int rating = minRating + random.nextInt(maxRating - minRating);
      int cieledIntPercentage = percentage.ceil();
      await fs.collection('Users').doc(uid).set({
        'Name': fName,
        'ProfileImage': defaultProfileImage,
        'Tp': '$tp',
        'Tw': '$tw',
        'Rating': '$rating',
        'Percentage': '$cieledIntPercentage%'
      });

      fs.collection('Usernames').doc(userName).set({'emailID': emailId});

      await userCred.user?.sendEmailVerification();
      return true;
    } catch (e) {
      print(e);
      if (e
          .toString()
          .contains('The email address is already in use by another account')) {
        print('aaya tha yaha');
        error = "RegistrationError1".i18n();
      } else {
        error = 'RegistrationError2'.i18n();
      }
      return false;
    }
  }

  Future<RegistrationState> init() async {
    return state.clone();
  }
}
