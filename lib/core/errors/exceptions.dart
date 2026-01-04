class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);
}

class UnauthorizedException implements Exception {}

class ServerException implements Exception {}

class CacheException implements Exception {}

class TimeoutException implements Exception {}

class CancelException implements Exception {}

class UnknownException implements Exception {}
