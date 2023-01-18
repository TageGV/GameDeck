import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mx_exchange/common/base/ui_button.dart';
import 'package:mx_exchange/common/style/app_colors.dart';

class UIAlert extends StatelessWidget {
  String? title;
  String message;

  UIAlert(
      {super.key,
      this.title,
      required this.message});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 38),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Text(
                title ?? "WARNING",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 150),
              child: UIButton(
                isGradient: false,
                backgroundColor: Colors.white38,
                title: "OK",
                onPress: () => Navigator.of(context).pop(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
