import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:mx_exchange/common/base/base_widget.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/common/utils/screen_util.dart';
import 'package:mx_exchange/di/injection.dart';
import 'package:mx_exchange/presentation/screens/onboard/models/onboard_model.dart';
import 'package:mx_exchange/presentation/screens/onboard/onboard_cubit.dart';
import 'package:mx_exchange/presentation/screens/onboard/onboard_state.dart';
import 'package:mx_exchange/presentation/screens/onboard/widgets/dot_indicator.dart';
import 'package:mx_exchange/resources/icons.dart';
import 'package:mx_exchange/resources/images.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen>
    with TickerProviderStateMixin {
  late OnboardCubit _cubit;
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = inject<OnboardCubit>();
    _animationController =
        AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseWidget(
            child: BlocBuilder<OnboardCubit, OnboardState>(
              bloc: _cubit,
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(bottom: 32),
                          alignment: Alignment.bottomLeft,
                          child: Lottie.asset(getJson(state.currentIndex),
                              controller: _animationController,
                              onLoaded: (composition) {
                                _animationController
                                  ..duration = composition.duration
                                  ..reset()
                                  ..forward();
                              },
                              repeat: false,
                              fit: BoxFit.cover,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.85)
                      ),
                    ),
                    animatedWidget(Container(
                      key: UniqueKey(),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: _getTitle(state.currentIndex),
                    )),
                    animatedWidget(Container(
                      margin: const EdgeInsets.only(top: 12),
                      key: UniqueKey(),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: _getSubtitle(state.currentIndex),
                    )),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 74, horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ...List.generate(
                                  3,
                                      (index) =>
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 4),
                                        child: DotIndicator(
                                            isActive: index <=
                                                state.currentIndex),
                                      ))
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              if (state.currentIndex <
                                  getOnboards().length - 1) {
                                _cubit.onNext();
                              } else {
                                Routes.instance.navigateAndRemove(R.trial);
                              }
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                                  gradient: LinearGradient(colors: [
                                    HexColor("#9558C8"),
                                    HexColor("#546DC8")
                                  ])),
                              child: SvgPicture.asset(AppIcons.next),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            )));
    // TODO: implement build
  }

  Text _getTitle(int index) {
    return Text(
      getOnboards()[index].title,
      textAlign: TextAlign.start,
      key: ValueKey<String>(getOnboards()[index].title),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  String getJson(int index) {
    final values = [GDLottie.wc_1, GDLottie.wc_2, GDLottie.wc_3];
    return values[index];
  }

  Text _getSubtitle(int index) {
    return Text(
      getOnboards()[index].subtitle,
      textAlign: TextAlign.start,
      key: ValueKey<String>(getOnboards()[index].subtitle),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget animatedWidget(Widget widget) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: widget,
    );
  }
}
