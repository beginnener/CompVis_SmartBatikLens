import 'package:flutter/material.dart';
// import '../../../shared/constant/app_colors.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import '../services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class LensScreen extends StatefulWidget {
  const LensScreen({super.key});

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> {
  late CameraService cameraService;

  @override
  void initState() {
    super.initState();
    cameraService = CameraService();
  }

  @override
  void dispose() {
    cameraService.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked != null) {
    final bytes = await picked.readAsBytes();

    await StorageService.addToHistory(
      path: picked.path,
      bytes: bytes,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraService.initializeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(child: CameraPreview(cameraService.controller));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          _buildTopBar(context),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/history'),
            child: _circleIcon(Icons.history),
          ),
          const Text(
            'SMART BATIK LENS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          _circleIcon(Icons.flash_on),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _pickFromGallery,
            child: _buildActionButton(Icons.photo_library, "Galeri"),
          ),
          _buildCaptureButton(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/favorites'),
            child: _buildActionButton(Icons.favorite, "Favorit"),
          ),
        ],
      ),
    );
  }


  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: () async {
        try {
          final image = await cameraService.capture();
          final bytes = await image.readAsBytes();

          // simpan ke histori
          await StorageService.addToHistory(
            path: image.path,
            bytes: bytes,
          );

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Foto tersimpan: ${image.path}')),
          );
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: const CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          child: Icon(Icons.lens, size: 40, color: Colors.white),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return CircleAvatar(
      backgroundColor: Colors.black45,
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildActionButton(IconData icon, String label) { 
    return Column( 
      mainAxisSize: MainAxisSize.min, 
      children: [ 
        CircleAvatar( 
          radius: 25, 
          backgroundColor: Colors.black45, 
          child: Icon(icon, color: Colors.white), 
        ), 
        const SizedBox(height: 8), 
        Text(
          label, 
          style: const TextStyle(color: Colors.white, fontSize: 12)), 
      ],
    ); 
  }
}
