abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure() : super('Erro no servidor');
}

class CacheFailure extends Failure {
  CacheFailure() : super('Erro no cache');
}

class AuthFailure extends Failure {
  AuthFailure() : super('Falha na autenticação');
}

class UnauthorizerFailure extends Failure {
  UnauthorizerFailure() : super('Usuário ou senha inválidos');
}

class CustomMessageFailure extends Failure {
  CustomMessageFailure(super.message);
}
