abstract class LoginEvent {}

class InitEvent extends LoginEvent {}

class PageLoaded extends LoginEvent {}

class LoginUsingMailEvent extends LoginEvent {
  final String userName;
  final String password;

  LoginUsingMailEvent(this.userName, this.password);
}
