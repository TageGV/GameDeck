import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mx_exchange/common/base/ui_button.dart';
import 'package:mx_exchange/common/style/app_colors.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/resources/icons.dart';
import 'package:mx_exchange/respostory/ad_mob_service.dart';

class DialogPremium extends StatelessWidget {
  final CategoryItem item;
  final VoidCallback onPremium;
  final VoidCallback onWatchAds;

  const DialogPremium(
      {super.key,
      required this.item,
      required this.onPremium,
      required this.onWatchAds});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: AppColors.gradientColors
            ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 63,
                    height: 63,
                    child: Image.network(item.cover ?? "",
                        width: 63, height: 63, fit: BoxFit.cover)),
                SizedBox(width: 18.w),
                Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(item.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Image.asset(
                                AppIcons.icLock18,
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: SizedBox(
                            child: Text("This Deck is Locked",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600)),
                          ),
                        )
                      ],
                    ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                "To play this Deck, you need a \nPremium Subscription,",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: UIButton(
                  backgroundColor: Colors.white.withOpacity(0.25),
                  isGradient: false,
                  onPress: onPremium,
                  title: 'Go Premium'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "or watch a video to unlock ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300)),
                    TextSpan(
                        text: "10 ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: "questions.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300))
                  ]),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: UIButton(
                onPress: onWatchAds,
                title: (AdMobService.instance.flagAds?.number ?? 1) <= 3 ? "Watch Video (${AdMobService.instance.flagAds?.number ?? 1}/3)":"Watch Video",
              ),
            )
          ],
        ),
      ),
    );
  }
}
