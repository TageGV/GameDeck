import 'package:flutter/material.dart';
import 'package:mx_exchange/common/base/base_widget.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/di/injection.dart';
import 'package:mx_exchange/presentation/screens/splash/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

@override
  State<StatefulWidget> createState() => _SplashScreenState();


}

class _SplashScreenState extends State<SplashScreen> {
  late SplashCubit _cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = inject();
    _cubit.checkFlow();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget(child: Container());
  }
}