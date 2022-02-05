abstract class LoginEvent {}

class InitEvent extends LoginEvent {}

class PageLoaded extends LoginEvent {}

class LoginUsingMailEvent extends LoginEvent {
  final String emailID;
  final String password;

  LoginUsingMailEvent(this.emailID, this.password);
}
