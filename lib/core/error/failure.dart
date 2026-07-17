abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Không có kết nối mạng. Vui lòng kiểm tra lại.'}) : super(message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({String message = 'Yêu cầu kết nối quá hạn. Vui lòng thử lại.'}) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure(super.message, {this.errors});
}

class UnknownFailure extends Failure {
  const UnknownFailure({String message = 'Đã xảy ra lỗi không xác định.'}) : super(message);
}
