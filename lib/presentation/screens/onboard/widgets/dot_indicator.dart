import 'package:flutter/material.dart';


class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: isActive ? Colors.white : Colors.white38
      ),
      width: 24,
      height: 8,
    );
  }

}