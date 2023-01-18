import 'package:flutter/material.dart';
import 'package:mx_exchange/common/utils/log_util.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/presentation/screens/home/home_screen.dart';
import 'package:mx_exchange/presentation/screens/onboard/onboard_screen.dart';
import 'package:mx_exchange/presentation/screens/overview/overview_screen.dart';
import 'package:mx_exchange/presentation/screens/overview/overview_state.dart';
import 'package:mx_exchange/presentation/screens/quiz/quiz_screen.dart';
import 'package:mx_exchange/presentation/screens/review_screen/review_screen.dart';
import 'package:mx_exchange/presentation/screens/splash/splash_screen.dart';
import 'package:mx_exchange/presentation/screens/subscription/trial_screen.dart';
import 'package:page_transition/page_transition.dart';

class R {
  static const String _ = '/';
  static const String splash = '${_}splash';
  static const String onboard = '${_}onboard';
  static const String trial = '${_}trial';
  static const String home = '${_}home';
  static const String quiz = '${_}quiz';
  static const String overview = '${_}overview';
  static const String review = '${_}review';
}

class Routes {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory Routes() => _instance;

  Routes._internal();

  static final Routes _instance = Routes._internal();

  static Routes get instance => _instance;

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) async {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateAndRemove(String routeName, {dynamic arguments}) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
          (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateAndReplace(String routeName, {dynamic arguments}) async {
    return navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateAndReplaceName(String routeName, {dynamic arguments}) async {
    return navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  dynamic pop({dynamic result}) {
    return navigatorKey.currentState?.pop(result);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    LOG.info('Route name: ${settings.name}');

    switch (settings.name) {
      case R.splash:
        return _pageRoute(page: const SplashScreen(), setting: settings);
      case R.onboard:
        return _pageRoute(page: const OnboardScreen(), setting: settings);
      case R.trial:
        return _pageRoute(page: TrialScreen(fromHome: settings.arguments as bool?,), setting: settings);
      case R.home:
        return _pageRoute(page: const HomeScreen(), setting: settings);
      case R.quiz:
        return _pageRoute(page: QuizScreen(items: settings.arguments as List<CategoryItem>), setting: settings);
      case R.overview:
        return _pageRoute(page: OverviewScreen(arguments: settings.arguments as OverviewArguments), setting: settings);
      case R.review:
        return _pageRoute(page: ReviewScreen(ids: settings.arguments as List<int>), setting: settings);
      default:
      return _pageRoute(page: const SplashScreen(), setting: settings);
    }
  }

  static PageTransition _pageRoute({
    PageTransitionType? transition,
    RouteSettings? setting,
    required Widget page,
  }) =>
      PageTransition(
        child: page,
        type: PageTransitionType.fade,
        settings: RouteSettings(arguments: setting?.arguments, name: setting?.name),
      );

  static MaterialPageRoute _emptyRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Center(
              child: Text(
                'Back',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        body: Center(
          child: Text('No path for ${settings.name}'),
        ),
      ),
    );
  }
}
