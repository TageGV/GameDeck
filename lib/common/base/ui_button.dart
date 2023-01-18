import 'package:flutter/material.dart';
import 'package:mx_exchange/common/style/app_colors.dart';

class UIButton extends StatelessWidget {
  final VoidCallback? onPress;
  final String title;
  final bool isGradient;
  final Color? backgroundColor;
  final bool enable;

  const UIButton(
      {super.key,
        this.onPress,
      required this.title,
      this.isGradient = true,
      this.enable = true,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: enable ? onPress:null,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: isGradient
                ? LinearGradient(
                    colors: AppColors.pinkGradientColors.reversed.toList())
                : null),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
