import 'package:camera/camera.dart';

class CameraService {
  late CameraController controller;
  late Future<void> initializeFuture;

  CameraService(CameraDescription camera) {
    controller = CameraController(camera, ResolutionPreset.high);
    initializeFuture = controller.initialize();
  }

  Future<XFile> capture() async {
    try {
      await initializeFuture;
      return await controller.takePicture();
    } catch (e) {
      throw Exception('Failed to capture photo: $e');
    }
  }

  void dispose() {
    controller.dispose();
  }
}
