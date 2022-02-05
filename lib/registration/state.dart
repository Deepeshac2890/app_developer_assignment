class RegistrationState {
  RegistrationState init() {
    return RegistrationState();
  }

  RegistrationState clone() {
    return RegistrationState();
  }
}

class RegistrationSuccess extends RegistrationState {
  final String error;
  final bool success;

  RegistrationSuccess(this.error, this.success);
}

class LoadingState extends RegistrationState {}

class UserNameDuplicate extends RegistrationState {}
