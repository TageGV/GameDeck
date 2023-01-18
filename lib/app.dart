import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:mx_exchange/common/base/bloc/alert/alert_cubit.dart';
import 'package:mx_exchange/common/base/bloc/alert/alert_state.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_state.dart';
import 'package:mx_exchange/common/base/bloc/ui_alert.dart';
import 'package:mx_exchange/common/base/loading_app.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/di/injection.dart';

class App extends StatelessWidget {
  List<BlocProvider> _getProviders() =>
      [
        BlocProvider<LoadingCubit>(
          create: (_) => inject<LoadingCubit>(),
        ),
        BlocProvider<SnackBarCubit>(
          create: (_) => inject<SnackBarCubit>(),
        ),
        BlocProvider<AppAlertCubit>(
          create: (_) => inject<AppAlertCubit>(),
        )
      ];

  List<BlocListener> _getBlocListener(context) =>
      [
        BlocListener<AppAlertCubit, AppAlertState>(
            listener: _mapListenerAppAlertState),
        BlocListener<SnackBarCubit, SnackBarState>(listener: _mapListenerSnackBarState),
      ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiBlocProvider(
        providers: _getProviders(),
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'GameDeck',
                theme: ThemeData(fontFamily: "Lexend"),
                navigatorKey: Routes.instance.navigatorKey,
                onGenerateRoute: Routes.generateRoute,
                navigatorObservers: [defaultLifecycleObserver],
                initialRoute: R.splash,
                builder: (ctx, widget) {
                  ScreenUtil.init(ctx);
                  return LoadingApp(
                    child: MultiBlocListener(
                      listeners: _getBlocListener(ctx),
                      child: widget ?? Container(),),
                  );
                },
            );
          },
        ));
  }

  void _mapListenerAppAlertState(BuildContext context, AppAlertState state) {
    debugPrint(state.message ?? "");
    if (state is ShowAlertState) {
      // TODO: Show Alert
      showDialog(context: Routes.instance.navigatorKey.currentContext!, builder: (context) {
         return UIAlert(message: state.message ?? "");
      });
    }
  }

  void _mapListenerSnackBarState(BuildContext context, SnackBarState state) {
    if (state is ShowSnackBarState) {
      var icon;
      var color;
      var title;
      switch (state.type) {
        case SnackBarType.success:
        // TODO: Handle this case.
          icon = const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          );
          color = HexColor('#33B44A');
          title = "Success";
          break;
        case SnackBarType.error:
        // TODO: Handle this case.
          icon = const Icon(
            Icons.error_outline,
            color: Colors.white,
          );
          color = HexColor('#F63E43');
          title = "Error";
          break;
        case SnackBarType.warning:
        // TODO: Handle this case.
          icon = const Icon(
            Icons.error_outline,
            color: Colors.white,
          );
          color = Colors.orange;
          title = "Warning";
          break;
        default:
          break;
      }

      showFlash(
        context: Routes.instance.navigatorKey.currentContext!,
        duration: state.duration ?? const Duration(milliseconds: 1400),
        builder: (context, controller) {
          return Flash.bar(
            controller: controller,
            backgroundColor: color,
            position: FlashPosition.top,
            horizontalDismissDirection: HorizontalDismissDirection.startToEnd,
            margin: const EdgeInsets.all(8),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            forwardAnimationCurve: Curves.easeOutBack,
            reverseAnimationCurve: Curves.easeInCubic,
            child: FlashBar(
              title: Text(
                title,
                style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
              ),
              content: Text(
                state.mess!,
                style: const TextStyle(color: Colors.white),
              ),
              icon: icon,
              shouldIconPulse: true,
              showProgressIndicator: false,
            ),
          );
        },
      );
    }
  }

}
