import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mx_exchange/common/style/app_colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class OverviewText extends StatefulWidget {
  final int progress;
  final bool blueShadow;

  const OverviewText({super.key, this.progress = 0, this.blueShadow = false})
      : assert(progress >= 0 && progress <= 100);

  @override
  State<StatefulWidget> createState() => _OverviewTextState();
}

class _OverviewTextState extends State<OverviewText> with SingleTickerProviderStateMixin {

  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: numbers());
  }

  List<Widget> numbers() {
    List<Widget> items = [];
    if (widget.progress == 0) {
      items.add(
          Padding(padding: EdgeInsets.only(right: 8.sp), child: _items(0)));
      items.add(
          Padding(padding: EdgeInsets.only(right: 8.sp), child: _items(0)));
    } else if (widget.progress == 100) {
      items.add(
          Padding(padding: EdgeInsets.only(right: 8.sp), child: _items(1)));
      items.add(
          Padding(padding: EdgeInsets.only(right: 8.sp), child: _items(0)));
      items.add(
          Padding(padding: EdgeInsets.only(right: 8.sp), child: _items(0)));
    } else {
      var digits =
          widget.progress.toString().split('').map((e) => int.parse(e));
      for (var element in digits) {
        items.add(Padding(
            padding: EdgeInsets.only(right: 8.sp), child: _items(element)));
      }
    }

    items.add(Text('%',
        style: TextStyle(
            color: Colors.white,
            fontSize: 40.sp,
            fontWeight: FontWeight.w600)));

    return items;
  }

  Widget _items(int number) {
    
    AnimatedTextKit(
      animatedTexts: [
        RotateAnimatedText()
      ],
    )
    
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: AppColors.textGradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          boxShadow: widget.blueShadow
              ? [
                  BoxShadow(
                      color: HexColor("#00FFF2").withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 64,
                      offset: const Offset(0, 14)),
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 6))
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 6))
                ]),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.w),
      child: Text(
        '$number',
        style: style(),
      ),
    );
  }

  TextStyle style() {
    return const TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.w600);
  }
}
