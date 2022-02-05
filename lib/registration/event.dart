abstract class RegistrationEvent {}

class InitEvent extends RegistrationEvent {}

class RegisterUser extends RegistrationEvent {
  final String name;
  final String emailID;
  final String userName;
  final String password;

  RegisterUser(this.name, this.emailID, this.userName, this.password);
}
