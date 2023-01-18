import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_state.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/presentation/screens/subscription/trial_state.dart';
import 'package:mx_exchange/respostory/datasources.dart';
import 'package:mx_exchange/respostory/purchase_service.dart';

class TrialCubit extends Cubit<TrialState> {

  final DataSources dataSources;
  final SnackBarCubit snackBarCubit;
  final LoadingCubit loadingCubit;

  TrialCubit(this.dataSources, this.loadingCubit, this.snackBarCubit):super(TrialState());

  void trackingSubscriptions() async {
    PaymentService.instance.addToProStatusChangedListeners(() {
      loadingCubit.hideLoading();
      Routes.instance.pop(result: "reset");
    });

    PaymentService.instance.addToErrorListeners((message){
      loadingCubit.hideLoading();
      if (message != null) {
        snackBarCubit.showSnackBar(SnackBarType.error, message);
      }
    });
  }

  subscriptions() async {
    loadingCubit.showLoading();
    final products = await PaymentService.instance.products;
   for (var product in products) {
     // TODO: - change product Id;
      if (product.productId == "user_premium") {
        try {
          await PaymentService.instance.buyProduct(product);
          loadingCubit.hideLoading();
        } catch (e) {
          loadingCubit.hideLoading();
        }
      }
   }
  }


}