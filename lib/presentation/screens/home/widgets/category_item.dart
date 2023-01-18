import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mx_exchange/common/style/app_colors.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/resources/icons.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryItem item;
  final ValueSetter<bool> onChange;
  final VoidCallback onSelect;

  const CategoryItemWidget(
      {super.key,
      required this.item,
      required this.onChange,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        decoration: BoxDecoration(
            border: item.isSelected
                ? Border.all(color: AppColors.borderColor, width: 2)
                : (item.isComplete
                    ? Border.all(
                        color: AppColors.green.withOpacity(0.25), width: 2)
                    : null),
            boxShadow: item.isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 6)),
                    BoxShadow(
                        color: AppColors.borderColor.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 64,
                        offset: const Offset(0, 14))
                  ]
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
                colors: item.isSelected
                    ? AppColors.gradientColors
                    : (item.isComplete
                        ? AppColors.completeGradientColors
                        : AppColors.gradientColors),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: Image.network(
                      item.cover ?? "",
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  item.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: item.isSelected
                          ? AppColors.white
                          : item.isComplete
                              ? AppColors.green
                              : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Visibility(
                    visible: !item.isComplete && item.hasQuestionAds,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "Unlocked ",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300)),
                        TextSpan(
                            text: "${item.totalQuestionAds ?? 0}",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600))
                      ])),
                    )),
                Visibility(
                    visible: item.isComplete && !item.isSelected,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: RichText(
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
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [statusText(), statusIcon()],
                )
              ],
            ),
            Container(
                alignment: Alignment.topRight,
                child: Visibility(
                    visible: !item.isSelected && item.isComplete,
                    child: Image.asset(
                      AppIcons.icChecked,
                      width: 18,
                      height: 18,
                    )))
          ],
        ),
      ),
    );
  }

  Widget statusIcon() {
    if (item.isPremium == 0 || (item.totalQuestionAds ?? 0) != 0) {
      return Switch(
          activeTrackColor: AppColors.trackColor,
          inactiveTrackColor: AppColors.trackColor,
          thumbColor: MaterialStateProperty.all<Color>(AppColors.thumbColor),
          value: item.isSelected,
          onChanged: (bool value) => onChange(value));
    } else {
      return SizedBox(
          height: 48,
          child: SvgPicture.asset(AppIcons.lock, width: 24, height: 24));
    }
  }

  Widget statusText() {
    String data;
    if (item.isPremium == 0 || (item.totalQuestionAds ?? 0) != 0) {
      if (item.isSelected) {
        data = "ON";
      } else {
        data = "OFF";
      }
    } else {
      data = "LOCKED";
    }
    return Text(
      data,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
    );
  }
}
