import 'app_exceptions.dart';

class NetworkException extends AppException {
  NetworkException({String? message}) : super(message: message ?? 'Please check your internet!');
}
