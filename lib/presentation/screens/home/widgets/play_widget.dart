import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mx_exchange/app.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/common/style/app_colors.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/resources/icons.dart';

class PlayWidget extends StatelessWidget {
  final List<CategoryItem> itemSelecteds;
  final VoidCallback action;
  int _totalQuestion() {
    return itemSelecteds.map((e) => e.totalQuestion ?? 0).reduce((value, element) => value + element);
  }

  const PlayWidget({super.key, required this.itemSelecteds, required this.action});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
        margin: const EdgeInsets.only(bottom: 12),
        height: 90,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppColors.playBgColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PLAY",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: itemSelecteds.isNotEmpty
                          ? AppColors.borderColor
                          : Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 29),
                ),
                const SizedBox(height: 8,),
                Text(
                  itemSelecteds.isEmpty
                      ? "0 Deck selected"
                      : "${itemSelecteds.length} Deck${itemSelecteds.length > 1 ? "s":""} selected, ${_totalQuestion()} Question${_totalQuestion() > 1 ? "s":""}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: itemSelecteds.isEmpty ? AppColors.white60 : AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
            InkWell(
              onTap: action,
              child: Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7.5),
                child: SvgPicture.asset(
                  itemSelecteds.isEmpty ? AppIcons.outlinePlay : AppIcons.play,
                  width: 20,
                  height: 33,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

