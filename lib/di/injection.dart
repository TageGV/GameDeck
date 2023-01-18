import 'package:get_it/get_it.dart';
import 'package:mx_exchange/common/base/bloc/alert/alert_cubit.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/common/network/client.dart';
import 'package:mx_exchange/common/network/network_info.dart';
import 'package:mx_exchange/presentation/screens/home/event_cubit/home_event_cubit.dart';
import 'package:mx_exchange/presentation/screens/home/home_cubit.dart';
import 'package:mx_exchange/presentation/screens/onboard/onboard_cubit.dart';
import 'package:mx_exchange/presentation/screens/quiz/quiz_cubit.dart';
import 'package:mx_exchange/presentation/screens/review_screen/review_cubit.dart';
import 'package:mx_exchange/presentation/screens/splash/splash_cubit.dart';
import 'package:mx_exchange/presentation/screens/subscription/trial_cubit.dart';
import 'package:mx_exchange/respostory/datasources.dart';

final inject = GetIt.instance;

Future<void> init() async {
  _configureCubit();
  _configureCommon();
  _configureDataSources();
}

void _configureCubit() {
  inject.registerLazySingleton(() => LoadingCubit());
  inject.registerLazySingleton(() => AppAlertCubit());
  inject.registerLazySingleton(() => SnackBarCubit());
  inject.registerLazySingleton(() => SplashCubit(
      dataSources: inject(), snackBarCubit: inject(), loadingCubit: inject()));
  inject.registerLazySingleton(() => OnboardCubit());
  inject.registerLazySingleton(() => HomeEventCubit());
  inject.registerLazySingleton(() => HomeCubit(inject(), inject(), inject(), inject()));
  inject.registerLazySingleton(() => QuizCubit(inject(), inject(), inject()));
  inject.registerLazySingleton(() => ReviewCubit(inject(), inject(), inject(), inject()));
  inject.registerLazySingleton(() => TrialCubit(inject(), inject(), inject()));

}

void _configureCommon() {
  inject.registerLazySingleton(() => AppClient(inject(), inject(), inject()));
  inject.registerLazySingleton(() => NetworkInfoImpl());
}

void _configureDataSources() {
  inject.registerLazySingleton(() => DataSources(inject()));
}
