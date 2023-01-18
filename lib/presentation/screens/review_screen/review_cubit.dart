import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/presentation/screens/home/event_cubit/home_event_cubit.dart';
import 'package:mx_exchange/presentation/screens/review_screen/review_state.dart';
import 'package:mx_exchange/respostory/datasources.dart';

class ReviewCubit extends Cubit<ReviewState> {

  final DataSources dataSources;
  final SnackBarCubit snackBarCubit;
  final LoadingCubit loadingCubit;
  final HomeEventCubit chooseOtherDeckCubit;
  List<int> _ids = [];

  ReviewCubit(this.snackBarCubit, this.dataSources, this.loadingCubit, this.chooseOtherDeckCubit) : super(const ReviewState());

  void add(List<int> ids) {
    _ids = ids;
  }
  void getRelate() async {
    final response = await dataSources.getRelateCategories(ids: _ids);
    emit(state.copyWith(true, response.yourRelate));
  }
}