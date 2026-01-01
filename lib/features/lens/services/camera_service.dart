import 'package:camera/camera.dart';
import '../../../main.dart';

class CameraService {
  late CameraController controller;
  late Future<void> initializeFuture;

  CameraService() {
    controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    initializeFuture = controller.initialize();
  }

  Future<XFile> capture() async {
    await initializeFuture;
    return await controller.takePicture();
  }

  void dispose() {
    controller.dispose();
  }
}