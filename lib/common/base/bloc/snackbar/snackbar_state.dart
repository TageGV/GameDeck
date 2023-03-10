import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning }

abstract class SnackBarState {
  final String? mess;
  final SnackBarType? type;
  final Duration? duration;

  SnackBarState({this.mess, this.type,this.duration});
}

class SnackBarInitialState extends SnackBarState {}

class ShowSnackBarState extends SnackBarState {
  ShowSnackBarState({
    @required type,
    String? mess,
    Duration? duration,
  }) : super(
      type: type,
      mess: mess ?? '',
      duration: duration
  );
}