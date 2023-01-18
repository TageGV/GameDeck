import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_state.dart';
import 'package:mx_exchange/common/exceptions/network_exceptions.dart';
import 'package:mx_exchange/common/utils/constant.dart';
import 'package:mx_exchange/common/utils/http_utils.dart';
import 'package:mx_exchange/common/utils/sf_util.dart';
import 'package:mx_exchange/common/exceptions/server_exceptions.dart';
import 'app_header.dart';
import 'config.dart';
import 'http.dart';
import 'network_info.dart';
import 'package:mx_exchange/common/utils/log_util.dart';
import 'package:mx_exchange/common/base/bloc/alert/alert_cubit.dart';

class AppClient {
  AppHeader header = AppHeader();
  final NetworkInfoImpl networkInfoImpl;
  final AppAlertCubit appAlertCubit;
  final SnackBarCubit snackBarCubit;

  AppClient(
      this.networkInfoImpl,
      this.appAlertCubit,
      this.snackBarCubit
      );

  set setHeader(AppHeader header) {
    this.header = header;
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParams}) async {
    final token = await SPrefUtil.instance.getString(SPrefConstants.token);
    if (token != null) {
      header.accessToken = token;
    }

    LOG.v('[GET]\n'
        'url: ${ConfigNetwork.apiUrl}$url \n'
        'queryParams: $queryParams\n'
        'headers: ${header.toJson()}');
    try {
      await _checkConnection();
      final response = await dio.get(
        url,
        queryParameters: queryParams,
        options: Options(
          headers: header.toJson(),
        ),
      );
      LOG.warn('Response: ${response.data}');
      return HttpUtils.handleResponse(response, snackBarCubit);
    } on ServerException catch (e) {
      appAlertCubit.showAlert(title: 'Error', message: e.message.toString());
      rethrow;
    } catch (e) {
      appAlertCubit.showAlert(title: 'Error', message: 'Request Error. Please try again!');
      rethrow;
    }
  }

  Future<dynamic> post(
      String url, {
        dynamic body,
        String? contentType,
        Map<String, dynamic>? queryParams,
        bool? isNoData,
      }) async {
    final token = await SPrefUtil.instance.getString(SPrefConstants.token);
    if (token != null) {
      header.accessToken = token;
    }

    LOG.v('[POST]\n'
        'url: ${ConfigNetwork.apiUrl}$url \n'
        'body: $body\n'
        'contentType: $contentType\n'
        'header: ${header.toJson()}');
    try {
      await _checkConnection();
      final response = await dio.post(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: header.toJson(),
          // contentType: contentType ?? 'application/json',
        ),
      );
      LOG.warn('Response: ${response.data}');
      return HttpUtils.handleResponse(response, snackBarCubit, noData: isNoData);
    } on ServerException catch (e) {
      appAlertCubit.showAlert(title: 'Error', message: e.message.toString());
      rethrow;
    } catch (e) {
      appAlertCubit.showAlert(title: 'Error', message: 'Request Error. Please try again!');
      rethrow;
    }
  }

  Future<dynamic> put(
      String url, {
        dynamic body,
        Map<String, dynamic>? queryParams,
      }) async {
    final token = await SPrefUtil.instance.getString(SPrefConstants.token);
    if (token != null) {
      header.accessToken = token;
    }

    LOG.v('[PUT]\n'
        'url: ${ConfigNetwork.apiUrl}$url \n'
        'body: $body \n'
        'queryParams: $queryParams \n'
        'header: ${header.toJson()}');
    try {
      await _checkConnection();
      final response = await dio.put(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: header.toJson(),
        ),
      );
      LOG.warn('Response: ${response.data}');
      return HttpUtils.handleResponse(response, snackBarCubit);
    } on ServerException catch (e) {
      appAlertCubit.showAlert(title: 'Error', message: e.message.toString());
      rethrow;
    } catch (e) {
      appAlertCubit.showAlert(title: 'Error', message: 'Request Error. Please try again!');
      rethrow;
    }
  }

  Future<dynamic> delete(
      String url, {
        Map<String, dynamic>? queryParams,
        dynamic body,
      }) async {
    final token = await SPrefUtil.instance.getString(SPrefConstants.token);
    if (token != null) {
      header.accessToken = token;
    }

    LOG.v('[DELETE]\n'
        'url: ${ConfigNetwork.apiUrl}$url \n'
        'body: $body \n'
        'queryParams: $queryParams \n'
        'header: ${header.toJson()}');

    try {
      await _checkConnection();
      final response = await dio.delete(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: header.toJson(),
        ),
      );
      LOG.warn('Response: ${response.data}');
      return HttpUtils.handleResponse(response, snackBarCubit);
    } on ServerException catch (e) {
      appAlertCubit.showAlert(title: 'Error', message: e.message.toString());
      rethrow;
    } catch (e) {
      appAlertCubit.showAlert(title: 'Error', message: 'Request Error. Please try again!');
      rethrow;
    }
  }

  Future<dynamic> getResponseFromApi({@required String? api}) async {
    LOG.verbose('HTTP GET\n'
        'API: $api\n'
        '');
    await _checkConnection();
    try {
      final Response response = await Dio().get(api!);
      return json.decode(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future _checkConnection() async {
    var internet = await networkInfoImpl.isConnected;
    if (!internet) {
      // TODO: ShowAlert network error
      appAlertCubit.showAlert(title: "Error", message: "Please check your internet connection!");
      return;
    }
  }
}


