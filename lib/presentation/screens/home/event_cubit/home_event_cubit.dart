import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/presentation/screens/home/event_cubit/home_event_state.dart';

class HomeEventCubit extends Cubit<HomeEventState> {
  HomeEventCubit():super(const HomeEventState());

  void reloadData() {
    emit(state.copyWith(chooseOtherDeck: true));
  }
}