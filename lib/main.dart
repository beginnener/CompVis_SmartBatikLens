import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// Variabel global untuk menyimpan daftar kamera yang tersedia
List<CameraDescription> cameras = [];

Future<void> main() async {
  // Pastikan plugin terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Ambil daftar kamera yang tersedia di perangkat
  cameras = await availableCameras();

  runApp(const SmartBatikApp());
}

class SmartBatikApp extends StatelessWidget {
  const SmartBatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Batik Lens',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF795548),
          primary: const Color(0xFF5D4037),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/camera': (context) => const LensScreen(),
        '/history': (context) => const HistoryPage(),
        '/favorites': (context) => const FavoritesPage(),
      },
    );
  }
}

// Splash Screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/camera'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo_smartbatik.png', width: 200), // Replace with your logo asset
              const SizedBox(height: 20),
              const Text(
                'Smart Batik Lens',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Camera View
class LensScreen extends StatefulWidget {
  const LensScreen({super.key});

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(child: CameraPreview(_controller));
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                );
              }
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
          _buildActionButton(Icons.photo_library, "Galeri"),
          _buildCaptureButton(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/favorites'),
            child: _buildActionButton(Icons.favorite, "Favorit"),
          ),
        ],
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
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: () async {
        try {
          await _initializeControllerFuture;
          final image = await _controller.takePicture();
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
          child: Icon(Icons.lens, size: 40, color: Color(0xFF5D4037)),
        ),
      ),
    );
  }
}

// History Page
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histori'),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: Center(
        child: const Text('Histori Page Content'),
      ),
    );
  }
}

// Favorites Page
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: Center(
        child: const Text('Favorit Page Content'),
      ),
    );
  }
}