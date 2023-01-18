import 'package:flutter/material.dart';
import 'package:mx_exchange/app.dart';
import 'package:mx_exchange/setup.dart';


void main() async {
  await initialized();
  runApp(App());
}
