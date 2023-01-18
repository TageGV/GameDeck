import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/common/utils/constant.dart';
import 'package:mx_exchange/common/utils/sf_util.dart';
import 'package:mx_exchange/presentation/screens/splash/splash_state.dart';
import 'package:mx_exchange/respostory/datasources.dart';

class SplashCubit extends Cubit<SplashState> {

  final DataSources dataSources;
  final SnackBarCubit snackBarCubit;
  final LoadingCubit loadingCubit;

  SplashCubit({required this.dataSources, required this.snackBarCubit, required this.loadingCubit}):super(SplashState());

  void checkFlow() async {
    final token = await SPrefUtil.instance.getString(SPrefConstants.token);
    if (token != null && token.isNotEmpty) {
      Routes.instance.navigateAndRemove(R.home);
    } else {
      loadingCubit.showLoading();
      try {
        final authentication = await dataSources.login();
        SPrefUtil.instance.setString(
            SPrefConstants.token, authentication.accessToken ?? "");
        loadingCubit.hideLoading();
        Routes.instance.navigateAndRemove(R.onboard);
      } catch (e) {
        debugPrint(e.toString());
        loadingCubit.hideLoading();
      }
    }
  }
}