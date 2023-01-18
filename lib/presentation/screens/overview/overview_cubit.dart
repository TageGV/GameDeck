import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/presentation/screens/overview/overview_state.dart';
import 'package:mx_exchange/respostory/datasources.dart';

class OverviewCubit extends Cubit<OverviewState> {

  final DataSources dataSources;
  final SnackBarCubit snackBarCubit;
  final LoadingCubit loadingCubit;

  OverviewCubit(this.dataSources, this.snackBarCubit, this.loadingCubit) : super(OverviewState());



}