import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'app/smart_batik_app.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const SmartBatikApp());
}
