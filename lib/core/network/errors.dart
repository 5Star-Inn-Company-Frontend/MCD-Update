abstract class Failure {
  String get message;
}

class ServerFailure extends Failure {
  final String message;

  ServerFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

class NetworkFailure extends Failure {
  final String message;

  NetworkFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

class AuthenticationFailure extends Failure {
  final String message;

  AuthenticationFailure(this.message);

  @override
  String toString() {
    return message;
  }
}