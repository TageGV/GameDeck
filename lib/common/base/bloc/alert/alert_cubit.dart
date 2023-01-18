import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/alert/alert_state.dart';

class AppAlertCubit extends Cubit<AppAlertState> {
  AppAlertCubit() : super(AppAlertState());

  void showAlert({String? title, String? message}) {
    emit(ShowAlertState(title: title, message: message));
  }
}
