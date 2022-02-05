import 'package:app_developer_assignment/dashboard/view.dart';
import 'package:app_developer_assignment/login/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../Resources/WidgetConstants.dart';
import 'bloc.dart';
import 'event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static final id = "LoginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String emailId = "";
  String password = "";
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  final LoginBloc loginBloc = LoginBloc();
  bool isLoginDisabled = true;
  bool isUserNameTextIncorrect = false;
  bool isPasswordTextIncorrect = false;

  @override
  void dispose() {
    loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listener: (BuildContext context, state) {
        if (state is LoginSuccess) {
          if (state.success) {
            Navigator.pushNamed(context, DashboardPage.id);
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
        }
      },
      builder: (BuildContext context, state) {
        if (state is InitEvent) {
          return loginInit(context);
        } else if (state is LoadingState) {
          return loadingWidget();
        } else {
          return loginInit(context);
        }
      },
    );
  }

  Widget loginInit(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext innerContext) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Container(
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
                    controller: userNameController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      if (validateText(value)) {
                        isUserNameTextIncorrect = false;
                      } else {
                        isUserNameTextIncorrect = true;
                      }

                      emailId = value;
                      setState(() {
                        isUserNameTextIncorrect = isUserNameTextIncorrect;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'UsernameHint'.i18n(),
                      errorText: isUserNameTextIncorrect
                          ? "InvalidUsername".i18n()
                          : null,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                GestureDetector(
                  onHorizontalDragDown: (dragDownDetails) {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  child: TextField(
                    controller: passwordController,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (value) {
                      if (validateText(value)) {
                        isPasswordTextIncorrect = false;
                      } else {
                        isPasswordTextIncorrect = true;
                      }

                      password = value;
                      setState(() {
                        isPasswordTextIncorrect = isPasswordTextIncorrect;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      errorText: isPasswordTextIncorrect
                          ? "InvalidPassword".i18n()
                          : null,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: (!isPasswordTextIncorrect &&
                            !isUserNameTextIncorrect &&
                            userNameController.text.length != 0 &&
                            passwordController.text.length != 0)
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: (!isPasswordTextIncorrect &&
                              !isUserNameTextIncorrect &&
                              userNameController.text.length != 0 &&
                              passwordController.text.length != 0)
                          ? () async {
                              loginBloc
                                  .add(LoginUsingMailEvent(emailId, password));
                            }
                          : null,
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        "Login".i18n(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool validateText(String value) {
    if ((value.length > 3) && (value.length < 12) && value.isNotEmpty) {
      return true;
    } else if (value.length == 0) {
      return true;
    } else {
      return false;
    }
  }
}
