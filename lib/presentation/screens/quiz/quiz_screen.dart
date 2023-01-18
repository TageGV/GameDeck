import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mx_exchange/common/base/base_widget.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/common/style/app_colors.dart';
import 'package:mx_exchange/di/injection.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/presentation/screens/quiz/quiz_cubit.dart';
import 'package:mx_exchange/presentation/screens/quiz/quiz_state.dart';
import 'package:mx_exchange/resources/icons.dart';
import 'package:mx_exchange/resources/images.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class QuizScreen extends StatefulWidget {
  final List<CategoryItem> items;

  const QuizScreen({super.key, required this.items});

  @override
  State<StatefulWidget> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizCubit _cubit;
  ScreenshotController screenshotController = ScreenshotController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = inject();
    _cubit.initCategories(widget.items);
    _cubit.getQuestion();
  }

  double paddingWith(BuildContext context, String text) {
    final textSize = _textSize(text);
    final screenWidth =
        (MediaQuery.of(context).size.width - textSize.width) / 2;
    return screenWidth - 98;
  }

  Size _textSize(String text) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        body: BaseWidget(
          child: SafeArea(
            child: BlocBuilder<QuizCubit, QuizState>(
              bloc: _cubit,
              builder: (context, state) {
                return Visibility(
                  visible: state.questions.isNotEmpty,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 32, right: 32, top: 18),
                                    child: Text(
                                      "QUESTION",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                            children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "${(state.position ?? 0) + 1}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          TextSpan(
                                              text:
                                                  " out of ${state.getNumberQuestion()}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300))
                                        ])),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 32),
                                      child: Image.asset(
                                        AppIcons.iconShare,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                  onTap: () {
                                    Routes.instance.pop(result: "Reset Deck");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 32),
                                    child: SvgPicture.asset(
                                      AppIcons.close,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                )
                                ],
                              )
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 20),
                              child: Text(
                                state.getQuestContent(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )),
                          Expanded(
                              child: Stack(
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      _cubit.selectAnswer(
                                          state.getAnswerId(isLast: false));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.all(32),
                                        margin: marginTop(
                                            state.getAnswerId(isLast: false),
                                            state.getUserAnswerId()),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(topImageWith(
                                                  state.getAnswerId(
                                                      isLast: false),
                                                  state.getUserAnswerId())),
                                              fit: BoxFit.contain),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Center(
                                              child: Text(
                                                state.getAnswerContent(
                                                    isLast: false),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            )),
                                            Visibility(
                                              visible:
                                                  state.getUserAnswerId() != null,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 12),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                    color: Colors.black),
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Text(
                                                  state.getAnswerVote(
                                                      isLast: false),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      _cubit.selectAnswer(
                                          state.getAnswerId(isLast: true));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        margin: marginBottom(
                                            state.getAnswerId(isLast: true),
                                            state.getUserAnswerId()),
                                        padding: const EdgeInsets.all(32),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(bottomImageWith(
                                                  state.getAnswerId(isLast: true),
                                                  state.getUserAnswerId())),
                                              fit: BoxFit.contain),
                                        ),
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible:
                                                  state.getUserAnswerId() != null,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 12),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                    color: Colors.black),
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Text(
                                                  state.getAnswerVote(
                                                      isLast: true),

                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  state.getAnswerContent(
                                                      isLast: true),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: AppColors.pinkGradientColors),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(49))),
                                    width: 95,
                                    height: 95,
                                    alignment: Alignment.center,
                                    child: Text(
                                      state.getPercentSelect(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 32, right: 32, bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  child: InkWell(
                                    onTap: () => _cubit.onBack(),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.all(16),
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.25),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: SvgPicture.asset(AppIcons.back),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: InkWell(
                                  onTap: () => state.getUserAnswerId() != null ? _cubit.onPressBottomButton():_cubit.skip(),
                                  child: Container(
                                    height: 56,
                                    padding: state.getUserAnswerId() != null ? EdgeInsets.zero : EdgeInsets.only(
                                        left: paddingWith(context, "SKIP")),
                                    decoration: BoxDecoration(
                                        color: state.getUserAnswerId() != null
                                            ? Colors.white.withOpacity(0.25)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10)),
                                    alignment: state.getUserAnswerId() != null ? Alignment.center : Alignment.centerLeft,
                                    child: Text(
                                      state.getUserAnswerId() != null
                                          ? "Next Question"
                                          : "SKIP",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String bottomImageWith(int? answerId, int? selectId) {
    if (selectId == null) {
      return GDImages.bottom;
    } else if (selectId == answerId) {
      return GDImages.bottom;
    } else {
      return GDImages.bottomUnselect;
    }
  }

  String topImageWith(int? answerId, int? selectId) {
    if (selectId == null) {
      return GDImages.top;
    } else if (selectId == answerId) {
      return GDImages.top;
    } else {
      return GDImages.topUnselect;
    }
  }

  EdgeInsets marginTop(int? answerId, int? selectId) {
    if (selectId == null) {
      return const EdgeInsets.only(right: 16, left: 16, top: 16);
    } else if (selectId == answerId) {
      return const EdgeInsets.only(right: 0, left: 0, top: 0);
    } else {
      return const EdgeInsets.only(right: 32, left: 32, top: 32);
    }
  }

  EdgeInsets marginBottom(int? answerId, int? selectId) {
    if (selectId == null) {
      return const EdgeInsets.only(right: 16, left: 16, bottom: 16);
    } else if (selectId == answerId) {
      return const EdgeInsets.only(right: 0, left: 0, bottom: 0);
    } else {
      return const EdgeInsets.only(right: 32, left: 32, bottom: 23);
    }
  }
}
