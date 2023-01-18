import 'package:flutter/cupertino.dart';

class UILabel extends StatelessWidget {

  final String text;

  const UILabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      text
    );
  }


}