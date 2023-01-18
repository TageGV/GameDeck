
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/alert/alert_cubit.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/presentation/screens/home/home_state.dart';
import 'package:mx_exchange/respostory/datasources.dart';


class HomeCubit extends Cubit<HomeState> {
  final DataSources dataSources;
  final SnackBarCubit snackBarCubit;
  final LoadingCubit loadingCubit;
  final AppAlertCubit alertCubit;

  int page = 1;

  HomeCubit(this.dataSources, this.snackBarCubit, this.loadingCubit, this.alertCubit)
      : super(HomeState(items: []));

  void updateItemAt(int index, bool value) {

    state.items[index].isSelected = value;
    emit(state.copyWith(state.items));
  }

  void handleSwitchOnChange({required int index,required bool value, Function(CategoryItem)? showDialog}) {
    final item = state.items[index];

    if (value && !state.availableSelectItem(item)) {
        alertCubit.showAlert(title: "Alert", message: "");

      // snackBarCubit.showSnackBar(SnackBarType.error, "You cannot choose both free and premium decks at the same time.");
      return;
    }

    if (item.isComplete && value == true) {
      if(showDialog != null) {
        showDialog(item);
      }
    } else {
      updateItemAt(index, value);
    }
  }

  void onSelectItem(int index) {
    if (state.items[index].isPremium == 0 || state.items[index].hasQuestionAds) {
      state.items[index].isSelected = !state.items[index].isSelected;
      state.items[index].totalQuestionAnswer = null;
      emit(state.copyWith(state.items));
    }
  }

  void getItems() async {
    loadingCubit.showLoading();
    final items = await dataSources.getCategory(page);
    loadingCubit.hideLoading();
    emit(state.copyWith(items));
  }

  void reset(int index) async {
    final id = state.items[index].id;
    loadingCubit.showLoading();
    try {
      await dataSources.reset(id!);
      loadingCubit.hideLoading();
      onSelectItem(index);
    } catch (e) {
      loadingCubit.hideLoading();
    }
  }

  Future<bool> watchVideos(int categoryId) async {
    loadingCubit.showLoading();
    try {
      final result = await dataSources.watchVideo(categoryId);
      final items = await dataSources.getCategory(page);
      final index = items.map((e) => e.id).toList().indexOf(categoryId);
      final item = items[index];
      item.isSelected = true;
      state.items[index] = item;
      emit(state.copyWith(state.items));
      loadingCubit.hideLoading();
    } catch (e) {
      loadingCubit.hideLoading();
    }
    return true;
  }

  void handleResetCategoryWith({required CategoryItem item}) async {
    loadingCubit.showLoading();
    try {
      final items = await dataSources.getCategory(page);
      final index = items.map((e) => e.id).toList().indexOf(item.id!);
      items[index].isSelected = true;
      items[index].totalQuestionAnswer = 0;
      emit(state.copyWith(items));
      loadingCubit.hideLoading();
    } catch (e) {
      loadingCubit.hideLoading();
    }
  }


  void handleReload(List<CategoryItem> items) async {
    loadingCubit.showLoading();
    try {
      final categories = await dataSources.getCategory(page);
      for (var category in items) {
        final id = category.id;
        final index = categories.map((e) => e.id!).toList().indexOf(id!);
        final item = items[index];
        item.isSelected = !item.isComplete;
        state.items[index] = item;
      }
      emit(state.copyWith(state.items));
      loadingCubit.hideLoading();
    } catch (e) {
      loadingCubit.hideLoading();
    }
  }

  void handleSelectItem(
      int index,{ Function(CategoryItem)? showPremiumDialog, Function(CategoryItem)? showDialog}) {
    final item = state.items[index];

    if (!state.availableSelectItem(item)) {
      /// Check if item unavailable select => Show snack bar.
      alertCubit.showAlert(title: "Alert", message: "You cannot choose both free and premium decks at the same time.");
    }
    else if (item.isPremiumCategory && !item.hasQuestionAds){
      /// Check category is Premium and item don't have Question from watch videos => Show Premium dialog.
      if(showPremiumDialog != null) {
        showPremiumDialog(item);
      }
    }
    else if (item.isComplete && item.isSelected == false) {
      /// Check if item isComplete and item unselected => show dialog play again.
      if(showDialog != null) {
        showDialog(item);
      }
    } else {
      /// Update state of items.
      onSelectItem(index);
    }
  }
}
