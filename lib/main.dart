import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'app/smart_batik_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final cameras = await availableCameras();
    runApp(SmartBatikApp(cameras: cameras));
  } catch (e) {
    runApp(const SmartBatikApp(cameras: []));
  }
}
