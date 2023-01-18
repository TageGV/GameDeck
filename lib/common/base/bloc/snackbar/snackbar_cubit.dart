import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_state.dart';

class SnackBarCubit extends Cubit<SnackBarState> {
  SnackBarCubit() : super(SnackBarInitialState());

  void showSnackBar(SnackBarType snackBarType, String msg,{Duration? duration}) {
    emit(ShowSnackBarState(type: snackBarType, mess: msg,duration: duration));
  }
}