import 'package:flutter/cupertino.dart';
import 'package:mx_exchange/resources/images.dart';

class BaseWidget extends StatelessWidget {
  final Widget child;

  const BaseWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          GDImages.background,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        child
      ],
    );
  }
}
