import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/utils/log_util.dart';


class SupervisorBloc extends BlocObserver{
  @override
  void onEvent(Bloc bloc, Object? event) {
    // TODO: implement onEvent
    super.onEvent(bloc, event);
    LOG.info('Event ${event.runtimeType} of ${bloc.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    LOG.verbose('Transition ${bloc.runtimeType}\n'
        'Current state: ${transition.currentState.runtimeType}\n'
        'Event: ${transition.event.runtimeType}\n'
        'Next state: ${transition.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    LOG.warn('${cubit.runtimeType} Errored', error, stackTrace);
  }
}