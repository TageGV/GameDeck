
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/supervisor_bloc.dart';
import 'package:mx_exchange/di/injection.dart' as di;
import 'package:mx_exchange/respostory/ad_mob_service.dart';
import 'package:mx_exchange/respostory/purchase_service.dart';
import 'package:platform_device_id/platform_device_id.dart';


initialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Bloc.observer = SupervisorBloc();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, systemNavigationBarColor: Colors.transparent));
  await di.init();
  PaymentService.instance.initConnection();
  PaymentService.instance.addDataSources(di.inject());
  AdMobService.instance.initialize();
  final deviceId = await PlatformDeviceId.getDeviceId ?? "Unknow";
  debugPrint("DEVICE_ID: =====> $deviceId");
}
