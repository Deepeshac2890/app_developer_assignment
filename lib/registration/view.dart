import 'package:app_developer_assignment/login/view.dart';
import 'package:app_developer_assignment/registration/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../Resources/WidgetConstants.dart';
import 'bloc.dart';
import 'event.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  static String id = "RegistrationPage";
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late String emailId = '';
  late String password = '';
  late String fName = '';
  late String userName = '';
  final RegistrationBloc rb = RegistrationBloc();
  bool isFullNameTextIncorrect = false;
  bool isUserNameIncorrect = false;
  bool isEmailIDIncorrect = false;
  bool isPasswordIncorrect = false;

  @override
  void dispose() {
    rb.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      bloc: rb,
      listener: (BuildContext context, state) {
        if (state is RegistrationSuccess) {
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'RegSuccessful'.i18n(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
            Navigator.popAndPushNamed(context, LoginPage.id);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        } else if (state is UserNameDuplicate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "UserNameDuplicateError".i18n(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          );

          setState(() {
            emailId = "";
            password = "";
            userName = "";
            fName = "";
          });
        }
      },
      builder: (BuildContext context, state) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);

        if (state is InitEvent) {
          return initUI(context);
        } else if (state is LoadingState) {
          return loadingWidget();
        } else {
          return initUI(context);
        }
      },
    );
  }

  Widget initUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Container(
                height: 200.0,
                child: Image.asset(
                  'assets/logo.jpg',
                  height: 200.0,
                  width: 200.0,
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            GestureDetector(
              onHorizontalDragDown: (dragDownDetails) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  if (value.length > 3) {
                    isFullNameTextIncorrect = false;
                  } else {
                    isFullNameTextIncorrect = true;
                  }
                  fName = value;
                  setState(() {
                    isFullNameTextIncorrect = isFullNameTextIncorrect;
                  });
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "FullNameHint".i18n(),
                  errorText:
                      isFullNameTextIncorrect ? "InvalidFullName".i18n() : null,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onHorizontalDragDown: (dragDownDetails) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  if (value.length > 3 && value.contains('@')) {
                    isEmailIDIncorrect = false;
                  } else {
                    isEmailIDIncorrect = true;
                  }

                  emailId = value;
                  setState(() {
                    isEmailIDIncorrect = isEmailIDIncorrect;
                  });
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "EmailIDHint".i18n(),
                  errorText: isEmailIDIncorrect ? "InvalidEmail".i18n() : null,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onHorizontalDragDown: (dragDownDetails) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value.length > 3 && value.length < 12) {
                    isUserNameIncorrect = false;
                  } else {
                    isUserNameIncorrect = true;
                  }

                  userName = value;
                  setState(() {
                    isUserNameIncorrect = isUserNameIncorrect;
                  });
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'UsernameHint'.i18n(),
                  errorText:
                      isUserNameIncorrect ? "InvalidUsername".i18n() : null,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onHorizontalDragDown: (dragDownDetails) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value.length > 3 && value.length < 12) {
                    isPasswordIncorrect = false;
                  } else {
                    isPasswordIncorrect = true;
                  }
                  password = value;
                  setState(() {
                    isPasswordIncorrect = isPasswordIncorrect;
                  });
                },
                decoration: kTextFieldDecoration.copyWith(
                  errorText:
                      isPasswordIncorrect ? "InvalidPassword".i18n() : null,
                ),
              ),
            ),
            SizedBox(height: 24),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: (!isFullNameTextIncorrect &&
                          !isUserNameIncorrect &&
                          !isEmailIDIncorrect &&
                          !isPasswordIncorrect &&
                          fName.isNotEmpty &&
                          emailId.isNotEmpty &&
                          password.isNotEmpty &&
                          userName.isNotEmpty)
                      ? Colors.blueAccent
                      : Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: (!isFullNameTextIncorrect &&
                            !isUserNameIncorrect &&
                            !isEmailIDIncorrect &&
                            !isPasswordIncorrect &&
                            fName.isNotEmpty &&
                            emailId.isNotEmpty &&
                            password.isNotEmpty &&
                            userName.isNotEmpty)
                        ? () async {
                            rb.add(RegisterUser(
                                fName, emailId, userName, password));
                          }
                        : null,
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      "Register".i18n(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateInputsLength(
      String emailId, String password, String fName, String userName) {
    // Used multi if to make it readable
    if (emailId.isNotEmpty && isEmailIDIncorrect) {
      if (password.isNotEmpty && isPasswordIncorrect) {
        if (fName.isNotEmpty &&
            isFullNameTextIncorrect &&
            userName.isNotEmpty &&
            isUserNameIncorrect) {
          return true;
        }
      }
    }
    return false;
  }
}
