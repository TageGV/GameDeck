// ignore_for_file: no_logic_in_create_state

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mx_exchange/common/style/app_colors.dart';

class UIProgressBar extends StatefulWidget {
  final UIProgressBarController? controller;
  final double initValue;

  const UIProgressBar({super.key, this.controller, required this.initValue});

  @override
  UIProgressBarState createState() => UIProgressBarState();

}

class UIProgressBarController {
  UIProgressBarState? _state;
  VoidCallback? _onCompleted;

  void add( UIProgressBarState? state) {
    _state = state;
  }

  void addListener(VoidCallback listener) {
    _onCompleted = listener;
  }

  void dispose() {
    _state = null;
    _state?.dispose();
    _onCompleted = null;
  }

  bool get isAttached => _state != null;
  void startAnimation() {
    _state?.play();
    Future.delayed(const Duration(milliseconds: 500), _onCompleted);
  }
}

class UIProgressBarState extends State<UIProgressBar> {

  double _padding = 0;

  void play() {
    setState(() {
      _padding = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _padding = widget.initValue;
    if(widget.controller != null) {
      widget.controller?.add(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 22,
      width: ScreenUtil.defaultSize.width - 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: AppColors.textGradientColors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
        boxShadow: [
          BoxShadow(
            color: HexColor("#00FFF2").withOpacity(0.3),
            blurRadius: 64,
            spreadRadius: 0,
            offset: const Offset(0, 14)
          ),
          BoxShadow(
              color: HexColor("#000000").withOpacity(0.25),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 6)
          )
        ]
      ),
      child: AnimatedContainer(
        margin: EdgeInsets.only(right: _padding),
        height: 22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: AppColors.progressGradientColors),
        ),
        duration: const Duration(
          milliseconds: 500
        ),
        curve: Curves.easeInOut,
      ),
    );
  }

}