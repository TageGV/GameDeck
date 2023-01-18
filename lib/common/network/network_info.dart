import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  static final _instance = NetworkInfoImpl._();

  factory NetworkInfoImpl() => _instance;

  final ValueNotifier<bool> notifier = ValueNotifier<bool>(false);

  late InternetConnectionChecker? _checker;

  NetworkInfoImpl._() {
    _checker = InternetConnectionChecker();
    _checker!.onStatusChange.listen((status) {
      notifier.value = status == InternetConnectionStatus.connected;
    });
  }

  Completer<bool>? _checking;

  @override
  Future<bool> get isConnected {
    if (_checking?.isCompleted != false) {
      _checking = Completer<bool>();
      _checker?.hasConnection.then((value) {
        notifier.value = value;
        _checking?.complete(value);
      });
    }
    return _checking!.future;
  }

  void dispose() {
    _checker = null;
    notifier.dispose();
  }
}
