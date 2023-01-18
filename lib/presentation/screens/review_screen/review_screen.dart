import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mx_exchange/common/base/base_widget.dart';
import 'package:mx_exchange/common/base/ui_button.dart';
import 'package:mx_exchange/common/base/ui_progress_bar.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/di/injection.dart';
import 'package:mx_exchange/presentation/screens/overview/split_text.dart';
import 'package:mx_exchange/presentation/screens/review_screen/review_cubit.dart';
import 'package:mx_exchange/presentation/screens/review_screen/review_state.dart';
import 'package:mx_exchange/resources/icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mx_exchange/resources/images.dart';
import 'package:mx_exchange/respostory/ad_mob_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ReviewScreen extends StatefulWidget {

  final List<int> ids;
  const ReviewScreen({super.key, required this.ids});

  @override
  State<StatefulWidget> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  UIProgressBarController? _controller;
  bool _selected = false;
  bool isVisible = false;
  bool isRightPosition = true;
  BannerAd? _banner;

  final ReviewCubit _cubit = inject<ReviewCubit>();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit.add(widget.ids);
    _cubit.getRelate();
    _controller = UIProgressBarController();

    _controller?.addListener(() {
        setState(() {
          _selected = true;
          isVisible = true;
        });
    });

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Screenshot(
          controller: screenshotController,
          child: BaseWidget(
            child: BlocListener<ReviewCubit, ReviewState>(
              bloc: _cubit,
              listener: (context, state){
                if (state.loadingComplete) {
                  _controller?.startAnimation();
                }
              },
              child: BlocBuilder<ReviewCubit, ReviewState>(
                bloc: _cubit,
                builder: (context, state) {
                  return Stack(
                    children: [
                      Visibility(
                        visible: isVisible,
                        child: Opacity(
                            opacity: 0.2,
                            child: Image.asset(
                              GDImages.confetti,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height,
                              fit: BoxFit.fill,
                            )),
                      ),
                      SafeArea(
                        child: Stack(
                          children: [
                            Visibility(
                                visible: isVisible,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    BounceInRight(
                                      duration: const Duration(milliseconds: 1000),
                                      child: Image.asset(
                                        AppIcons.iconChart,
                                        width: 138,
                                        height: 138,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 44.h),
                                      child: Text(
                                        "You can relate to ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 32.h),
                                        child: OverviewText(progress: state.relate ?? 0,)),
                                    Padding(
                                      padding: EdgeInsets.only(top: 32.h),
                                      child: Text(
                                        "of our users!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 54.h),
                                      child: BounceInDown(
                                        duration: const Duration(milliseconds: 1000),
                                        child: InkWell(
                                          onTap: () async {
                                            _cubit.loadingCubit.showLoading();
                                            final bytes = await screenshotController.capture();
                                            if (bytes != null) {
                                              final directory = await getApplicationDocumentsDirectory();
                                              final imagePath = await File('${directory.path}/screen_shot.png').create();
                                              await imagePath.writeAsBytes(bytes);
                                              _cubit.loadingCubit.hideLoading();
                                              final xFile = XFile(imagePath.path);
                                              Share.shareXFiles([xFile]);
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 56,
                                            decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.25),
                                                borderRadius: BorderRadius.circular(
                                                    10)),
                                            margin:
                                            EdgeInsets.only(left: 32.w, right: 32.w),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                Image.asset(
                                                  AppIcons.iconShare,
                                                  width: 32,
                                                  height: 32,
                                                ),
                                                SizedBox(
                                                  width: 12.w,
                                                ),
                                                const Text(
                                                  "Share your Results",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 16, left: 32, right: 32),
                                      child: UIButton(
                                          title: "Choose another Deck",
                                          onPress: () {
                                            Routes.instance.pop();
                                            _cubit.chooseOtherDeckCubit.reloadData();
                                          }),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 26.h),
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)),
                                        margin: EdgeInsets.only(
                                            left: 32.w, right: 32.w),
                                        child: _banner == null ? null:AdWidget(ad: _banner!),
                                      ),
                                    ),
                                  ],
                                )),
                            AnimatedSlide(
                              duration: const Duration(milliseconds: 200),
                              offset: Offset(_selected ? -1 : 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      AppIcons.iconDart, width: 140, height: 140),
                                  Padding(
                                    padding: EdgeInsets.only(top: 42.h),
                                    child: Text(
                                      "You’ve answered\nall the questions!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 63.h),
                                    child: Text(
                                      "We are calculating your stats",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                      EdgeInsets.only(top: 32.h, left: 55, right: 55),
                                      child: UIProgressBar(
                                        controller: _controller,
                                        initValue:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width - 132,
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ));
  }
}
