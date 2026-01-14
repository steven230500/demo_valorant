sealed class AppError {
  final String message;
  const AppError(this.message);
}

class NetworkError extends AppError {
  const NetworkError(super.message);
}

class ServerError extends AppError {
  const ServerError(super.message);
}

class UnknownError extends AppError {
  const UnknownError(super.message);
}