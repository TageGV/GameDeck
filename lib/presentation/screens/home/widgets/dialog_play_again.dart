import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mx_exchange/common/base/ui_button.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/common/style/app_colors.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/resources/icons.dart';

class DialogPlayDeckAgain extends StatelessWidget {
  final CategoryItem item;
  final VoidCallback onPlayAgain;
  final VoidCallback onCancel;

  const DialogPlayDeckAgain(
      {super.key,
      required this.item,
      required this.onPlayAgain,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: AppColors.gradientColors
            ),
            borderRadius: BorderRadius.circular(10)
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 63,
                  height: 63,
                  child: Image.network(item.cover ?? "",
                      width: 63, height: 63, fit: BoxFit.cover),
                ),
                SizedBox(width: 18.w),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(item.name ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            AppIcons.icChecked,
                            width: 18,
                            height: 18,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: RichText(
                            overflow: TextOverflow.ellipsis,

                            text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      "You relate with ${item.categoryOverview ?? 0}%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text: "\nof our users",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w300))
                            ])),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                "You’ve already played this Deck.\nPlaying it again will reset your results.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: UIButton(onPress: onPlayAgain, title: 'Play Deck Again'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: UIButton(
                onPress: onCancel,
                title: "Cancel",
                backgroundColor: Colors.white.withOpacity(0.25),
                isGradient: false,
              ),
            )
          ],

        ),
      ),
    );
  }
}
