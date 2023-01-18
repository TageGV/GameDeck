import 'app_exceptions.dart';
class ServerException extends AppException {
  ServerException({String? message})
      : super(
    message: message ?? '',
  );
}
