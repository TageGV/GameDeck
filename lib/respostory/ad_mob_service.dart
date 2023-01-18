import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mx_exchange/common/utils/constant.dart';
import 'package:mx_exchange/common/utils/sf_util.dart';

class AdMobService {
  AdMobService._internal();

  static final AdMobService instance = AdMobService._internal();

  FlagAds? flagAds;

  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6279637778690752/4095478551";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6279637778690752/6224147555";
    }
    return null;
  }


  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6279637778690752/1933548754";
    } else {
      return "ca-app-pub-6279637778690752/4176568717";
    }
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
      onAdLoaded: (ad) => debugPrint('Ad Loaded'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('Ad Failed to load: $error');
      },
      onAdOpened: (ad) => debugPrint("Ad Opened"),
      onAdClicked: (ad) => debugPrint("Ad Click"));

  void initialize() async {

    MobileAds.instance
    ..initialize()
    ..updateRequestConfiguration(RequestConfiguration(testDeviceIds: ["B38B23B894CD0D2FAFA8FAD1F63760B9", "8907a24bd8aefa165e1e492d104b7da8"]));

    final flag = await getFlag();
     flagAds = flag;
     if(flag != null && !flag.isToday) {
       final date = DateTime.now();
       String dateFormat = DateFormat('dd-MM-yyyy').format(date);
       final flag = FlagAds(day: dateFormat, number: 1);
       flagAds = await _saveFlag(flag);
     } else if (flag == null) {
       final date = DateTime.now();
       String dateFormat = DateFormat('dd-MM-yyyy').format(date);
       final flag = FlagAds(day: dateFormat, number: 1);
       flagAds = await _saveFlag(flag);
     }
  }

  Future<FlagAds> _saveFlag(FlagAds flag) async {
    String jsonString = jsonEncode(flag);
    await SPrefUtil.instance.setString(SPrefConstants.flagLimitAds, jsonString);
    return flag;
  }


  Future<FlagAds?> getFlag() async {
    final jsonString =
        await SPrefUtil.instance.getString(SPrefConstants.flagLimitAds);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    } else {
      Map<String, dynamic> json = jsonDecode(jsonString!);
      return FlagAds.fromJson(json);
    }
  }

  Future<FlagAds?> updateFlag() async {
    final flag = await getFlag();
    if(flag != null && !flag.isToday) {
      final date = DateTime.now();
      String dateFormat = DateFormat('dd-MM-yyyy').format(date);
      final newFlag = FlagAds(day: dateFormat, number: 1);
      flagAds = await _saveFlag(newFlag);
      return newFlag;
    } else if(flag != null && flag.isToday) {
      final date = DateTime.now();
      final newFlag = FlagAds(day: flag.day, number: flag.number + 1);
      flagAds = await _saveFlag(newFlag);
      return newFlag;
    } else {
      return flag;
    }
  }
}

class FlagAds {
  final String day;
  final int number;

  DateTime get date => DateFormat('dd-MM-yyyy').parse(day);

  DateTime get currentDate => DateTime.now();

  bool get isToday => (date.day == currentDate.day &&
      date.month == currentDate.month &&
      date.year == currentDate.year);

  const FlagAds({required this.day, required this.number});

  factory FlagAds.fromJson(Map<String, dynamic> parsedJson) {
    return FlagAds(
        day: parsedJson['day'] ?? "", number: parsedJson['number'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {"day": day, "number": number};
  }

}
