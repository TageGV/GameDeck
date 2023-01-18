import 'package:dio/dio.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_state.dart';
import 'package:mx_exchange/common/exceptions/server_exceptions.dart';
import 'package:mx_exchange/models/base.dart';

class HttpUtils {
  static dynamic handleResponse(Response response, SnackBarCubit cubit, {bool? noData}) {
    switch(response.statusCode) {
      case 200:
        return _successResponse(response, cubit, isNodata: noData);
      default:
        throw ServerException(message: "Request Error. Please try again!");
    }
  }

  static dynamic _successResponse(Response response, SnackBarCubit snackBarCubit, {bool? isNodata}) {
    if (isNodata == true) {
      return response.data;
    } else {
      final res = ResModel.fromJson(response.data);
      if (res.success == true) {
        return res;
      } else {
        final message = res.error != null ? res.error?.content ?? "" : "Request Error. Please try again!";
        throw ServerException(message: message);
      }
    }
  }
}
