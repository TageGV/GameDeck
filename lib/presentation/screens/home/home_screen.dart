import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mx_exchange/common/base/base_widget.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/di/injection.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/presentation/screens/home/event_cubit/home_event_cubit.dart';
import 'package:mx_exchange/presentation/screens/home/event_cubit/home_event_state.dart';
import 'package:mx_exchange/presentation/screens/home/home_cubit.dart';
import 'package:mx_exchange/presentation/screens/home/home_state.dart';
import 'package:mx_exchange/presentation/screens/home/widgets/category_item.dart';
import 'package:mx_exchange/presentation/screens/home/widgets/dialog_play_again.dart';
import 'package:mx_exchange/presentation/screens/home/widgets/play_widget.dart';
import 'package:mx_exchange/presentation/screens/home/widgets/popup_deck.dart';
import 'package:mx_exchange/resources/icons.dart';
import 'package:mx_exchange/respostory/ad_mob_service.dart';
import 'package:platform_device_id/platform_device_id.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeCubit _cubit;
  RewardedAd? _rewardedAd;
  late HomeEventCubit _eventCubit;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _cubit = inject();
    _cubit.getItems();
    _eventCubit = inject();
    _createRewardedAd();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdMobService.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => _rewardedAd = ad,
            onAdFailedToLoad: (error) {
              _rewardedAd = null;
            }));
  }

  void _showRewardedAd(CategoryItem item) async {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createRewardedAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createRewardedAd();
      });

      final deviceId = await PlatformDeviceId.getDeviceId;
      _rewardedAd!.setServerSideOptions(ServerSideVerificationOptions(
          userId: deviceId!, customData: "${item.id!}"));

      _rewardedAd!.show(onUserEarnedReward: (ad, reward) async {
        await _cubit.watchVideos(item.id!);
        Routes.instance.navigateTo(R.quiz, arguments: [item]);
        AdMobService.instance.updateFlag();
      });
      _rewardedAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<HomeEventCubit, HomeEventState>(
      bloc: _eventCubit,
      listener: (context, state) {
        debugPrint(state.chooseOtherDeck.toString());
        if (state.chooseOtherDeck) {
          _cubit.getItems();
        }
      },
      child: Scaffold(
        body: BaseWidget(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 44),
                      padding: const EdgeInsets.only(left: 26),
                      width: MediaQuery.of(context).size.width,
                      height: 44,
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(
                          AppIcons.menu,
                          width: 32,
                          height: 32,
                        ),
                      )),
                  const SizedBox(height: 12),
                  FadeInUp(
                    duration: const Duration(milliseconds: 200),
                    child: const Text(
                      "Game Decks",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                      child: BlocBuilder<HomeCubit, HomeState>(
                    bloc: _cubit,
                    builder: (context, state) {
                      return GridView.builder(
                          itemCount: state.items.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 18,
                                  mainAxisSpacing: 18,
                                  childAspectRatio: 154 / 213),
                          padding: const EdgeInsets.only(
                              left: 32, right: 32, bottom: 132),
                          itemBuilder: (context, index) {
                            return CategoryItemWidget(
                                item: state.items[index],
                                onChange: (bool value) =>
                                    _cubit.handleSwitchOnChange(
                                        index: index,
                                        value: value,
                                        showDialog: (item) =>
                                            showPlayAgainDialog(
                                                context, item, index)),
                                onSelect: () {
                                  _cubit.handleSelectItem(index,
                                      showPremiumDialog: (item) =>
                                          showPremiumDialog(context, item),
                                      showDialog: (item) => showPlayAgainDialog(
                                          context, item, index));
                                });
                          });
                    },
                  ))
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                alignment: Alignment.bottomCenter,
                child: BlocBuilder<HomeCubit, HomeState>(
                  bloc: _cubit,
                  builder: (context, state) {
                    final items =
                        state.items.where((element) => element.isSelected);
                    return PlayWidget(
                        itemSelecteds: items.toList(),
                        action: () async {
                          if (items.isNotEmpty) {
                            final result = await Routes.instance
                                .navigateTo(R.quiz, arguments: items.toList());
                            if (result != null) {
                              _cubit.handleReload(items.toList());
                            }
                          }
                        });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showPlayAgainDialog(
          BuildContext context, CategoryItem item, int index) =>
      showDialog(
          context: context,
          builder: (context) {
            return DialogPlayDeckAgain(
              item: item,
              onPlayAgain: () {
                _cubit.reset(index);
                Navigator.of(context).pop();
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            );
          });

  void showPremiumDialog(BuildContext context, CategoryItem item) async {
    showDialog(
        context: context,
        builder: (context) {
          return DialogPremium(
              item: item,
              onPremium: () async {
                Navigator.of(context).pop();
                final response =
                    await Routes.instance.navigateTo(R.trial, arguments: true);
                if (response != null) {
                  _cubit.handleResetCategoryWith(item: item);
                }
              },
              onWatchAds: () {
                if ((AdMobService.instance.flagAds?.number ?? 1) <= 3) {
                  _showRewardedAd(item);
                }
                Navigator.of(context).pop();
              });
        });
  }
}
