import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mx_exchange/common/base/base_widget.dart';
import 'package:mx_exchange/common/base/ui_button.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/presentation/screens/overview/overview_state.dart';
import 'package:mx_exchange/presentation/screens/overview/split_text.dart';
import 'package:mx_exchange/resources/icons.dart';
import 'package:mx_exchange/respostory/ad_mob_service.dart';

class OverviewScreen extends StatefulWidget {
  final OverviewArguments arguments;

  const OverviewScreen({super.key, required this.arguments});

  @override
  State<StatefulWidget> createState() => OverviewScreenState();
}

class OverviewScreenState extends State<OverviewScreen> {
  BannerAd? _banner;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId!,
        listener: AdMobService.bannerAdListener,
        request: const AdRequest())
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BaseWidget(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Image.asset(AppIcons.iconOverview,
                      width: 140, height: 140)),
              Text(
                "Progress Overview!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'you’ve answered\n',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            height: 1.28)),
                    TextSpan(
                        text: '${widget.arguments.current} ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.6)),
                    TextSpan(
                        text:
                            'out of ${widget.arguments.totalQuestion} questions',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            height: 1.6)),
                  ]),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 42.h),
                child: Text(
                  "So far you can relate to ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 32.h),
                  child: OverviewText(
                    progress: widget.arguments.relate,
                    blueShadow: true,
                  )),
              Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: Text(
                  "of our users!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 42.h, left: 32, right: 32),
                child: UIButton(
                    onPress: () {
                      Routes.instance.pop();
                    },
                    title: "Keep going"),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.bottomCenter,
                child: _banner == null
                    ? null
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 28.w),
                        height: 52,
                        child: AdWidget(ad: _banner!)),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
