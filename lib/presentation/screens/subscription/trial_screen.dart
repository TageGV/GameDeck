import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mx_exchange/common/base/base_widget.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/common/style/app_colors.dart';
import 'package:mx_exchange/di/injection.dart';
import 'package:mx_exchange/presentation/screens/subscription/trial_cubit.dart';
import 'package:mx_exchange/resources/icons.dart';

class TrialScreen extends StatefulWidget {

  final bool? fromHome;
  const TrialScreen({super.key, this.fromHome = false});

  @override
  State<StatefulWidget> createState() => _TrialScreenState();
}

class _TrialScreenState extends State<TrialScreen> {

  late final TrialCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = inject<TrialCubit>();
    _cubit.trackingSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BaseWidget(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 32, right: 22),
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 44,
                  height: 44,
                  child: InkWell(
                    onTap: () {
                      if (widget.fromHome == true) {
                          Routes.instance.pop();
                      } else {
                        Routes.instance.navigateAndReplace(R.home);
                      }
                    },
                    child:
                        SvgPicture.asset(AppIcons.close, width: 24, height: 24),
                  ),
                ),
              ),
              BounceInDown(
                duration: const Duration(milliseconds: 500),
                from: 100,
                child: Image.asset(
                  AppIcons.star,
                  width: 140,
                  height: 140,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              BounceInRight(
                duration: const Duration(milliseconds: 500),
                child: const Text(
                  "Go Premium!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 29),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 55, vertical: 16),
                height: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              const Text(
                "7 days FREE TRIAL\nUnlock Dirty Cards and more\nFREE content updates\nCreate your custom Cards\nAd-Free Experience\nCancel Anytime",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  height: 1.7,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 16, bottom: 50, left: 55, right: 55),
                height: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              BounceInUp(
                child: Text("First 7 days for free,",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.borderColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        height: 1.25)),
              ),
              BounceInUp(
                child: const Text("then \$3.99/week",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        height: 1.5)),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BounceInUp(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Text("Terms of Service",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.25)),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        InkWell(
                          onTap: () {},
                          child: const Text("Privacy Policy",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.25)),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _cubit.subscriptions();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      height: 56,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                              colors: AppColors.pinkGradientColors)),
                      child: const Center(
                        child: Text(
                          "Start Free Trial",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
