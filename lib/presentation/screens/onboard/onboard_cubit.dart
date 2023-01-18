import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/presentation/screens/onboard/models/onboard_model.dart';
import 'package:mx_exchange/presentation/screens/onboard/onboard_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  OnboardCubit() : super(const OnboardState(currentIndex: 0));

  void onNext() {
    final nextValue = state.currentIndex + 1;
    emit(state.copyWith(nextValue));
  }
}
