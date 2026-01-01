import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import '../services/storage_service.dart';
import '../services/tflite_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class LensScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const LensScreen({super.key, required this.cameras});

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> {
  late CameraService cameraService;
  final TFLiteService _tfliteService = TFLiteService();

  String? _errorMessage;
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeModel();
  }

  void _initializeCamera() {
    if (widget.cameras.isEmpty) {
      setState(() {
        _errorMessage = 'No cameras available';
      });
      return;
    }

    try {
      cameraService = CameraService(widget.cameras[0]);
      cameraService.initializeFuture.then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize camera: $e';
      });
    }
  }

  Future<void> _initializeModel() async {
    try {
      // TODO: Replace with your actual model and labels paths
      await _tfliteService.initialize(
        modelPath: 'lib/assets/models/model.tflite',
        labelsPath: 'lib/assets/models/labels.txt',
      );
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      print('Model initialization failed: $e');
      // Continue without model - user can still take photos
    }
  }

  @override
  void dispose() {
    _tfliteService.dispose();
    cameraService.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked == null) return;

      if (!mounted) return;

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
      );

      try {
        final bytes = await picked.readAsBytes();

        // Load image for processing
        img.Image? galleryImage = img.decodeImage(bytes);
        List<Recognition> recognitions = [];

        // Run inference if model is loaded
        if (_isModelLoaded && galleryImage != null) {
          try {
            // Store original dimensions
            final originalWidth = galleryImage.width;
            final originalHeight = galleryImage.height;

            recognitions = await _tfliteService.detectObjectsFromImage(
              galleryImage,
            );

            // Draw bounding boxes on the image
            if (recognitions.isNotEmpty) {
              galleryImage = _drawBoundingBoxes(
                galleryImage,
                recognitions,
                originalWidth,
                originalHeight,
              );
            }
          } catch (e) {
            print('Detection error: $e');
          }
        }

        // Encode annotated image
        final annotatedBytes = galleryImage != null
            ? img.encodeJpg(galleryImage)
            : bytes;

        // Save annotated image to history
        await StorageService.addToHistory(
          path: picked.path,
          bytes: annotatedBytes,
        );

        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog

        // Show fullscreen preview
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _ImagePreviewScreen(
              imageBytes: annotatedBytes,
              detections: recognitions,
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to process image: $e')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
              ),
            )
          : Stack(
              children: [
                // Camera Preview
                FutureBuilder(
                  future: cameraService.initializeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: cameraService
                                .controller
                                .value
                                .previewSize!
                                .height,
                            height: cameraService
                                .controller
                                .value
                                .previewSize!
                                .width,
                            child: CameraPreview(cameraService.controller),
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                // UI Elements
                _buildTopBar(context),
                _buildBottomBar(context),
                // Model Status Indicator
                if (!_isModelLoaded)
                  const Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Chip(
                        label: Text('Detection not available'),
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
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
          const SizedBox(width: 40), // Placeholder for symmetry
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
        if (!mounted) return;

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );

        try {
          // Capture photo
          final image = await cameraService.capture();
          final bytes = await image.readAsBytes();

          // Load image for processing
          img.Image? capturedImage = img.decodeImage(bytes);
          List<Recognition> recognitions = [];

          // Run inference if model is loaded
          if (_isModelLoaded && capturedImage != null) {
            try {
              // Store original dimensions
              final originalWidth = capturedImage.width;
              final originalHeight = capturedImage.height;

              recognitions = await _tfliteService.detectObjectsFromImage(
                capturedImage,
              );

              // Draw bounding boxes on the image
              if (recognitions.isNotEmpty) {
                capturedImage = _drawBoundingBoxes(
                  capturedImage,
                  recognitions,
                  originalWidth,
                  originalHeight,
                );
              }
            } catch (e) {
              print('Detection error: $e');
            }
          }

          // Encode annotated image
          final annotatedBytes = capturedImage != null
              ? img.encodeJpg(capturedImage)
              : bytes;

          // Save annotated image to history
          await StorageService.addToHistory(
            path: image.path,
            bytes: annotatedBytes,
          );

          if (!mounted) return;
          Navigator.pop(context); // Close loading dialog

          // Show fullscreen preview
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _ImagePreviewScreen(
                imageBytes: annotatedBytes,
                detections: recognitions,
              ),
            ),
          );
        } catch (e) {
          if (!mounted) return;
          Navigator.pop(context); // Close loading dialog

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to capture: $e')));
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

  // Draw bounding boxes on the image
  img.Image _drawBoundingBoxes(
    img.Image image,
    List<Recognition> recognitions,
    int originalWidth,
    int originalHeight,
  ) {
    // Calculate letterbox parameters used during preprocessing
    const inputSize = 640;
    final scale =
        inputSize /
        (originalWidth > originalHeight ? originalWidth : originalHeight);
    final scaledWidth = (originalWidth * scale).round();
    final scaledHeight = (originalHeight * scale).round();
    final offsetX = (inputSize - scaledWidth) / 2;
    final offsetY = (inputSize - scaledHeight) / 2;

    // Color map for different labels
    final colorMap = {
      'megamendung': img.ColorRgb8(147, 51, 234), // Purple
      'parang': img.ColorRgb8(255, 100, 0), // Orange
    };

    for (var recognition in recognitions) {
      // Get color for this label (default green if not in map)
      final labelKey = recognition.label.toLowerCase().trim();
      final boxColor = colorMap[labelKey] ?? img.ColorRgb8(0, 255, 0);

      // Coordinates from YOLO are in 640x640 letterbox space
      // Convert to original image space
      double x640 = recognition.location[0] * inputSize;
      double y640 = recognition.location[1] * inputSize;
      double w640 = recognition.location[2] * inputSize;
      double h640 = recognition.location[3] * inputSize;

      // Remove letterbox offset
      double xScaled = x640 - offsetX;
      double yScaled = y640 - offsetY;

      // Scale back to original image size
      int x = (xScaled / scale).round();
      int y = (yScaled / scale).round();
      int w = (w640 / scale).round();
      int h = (h640 / scale).round();

      // Clamp to image bounds
      x = x.clamp(0, image.width - 1);
      y = y.clamp(0, image.height - 1);
      w = w.clamp(1, image.width - x);
      h = h.clamp(1, image.height - y);

      // Draw rectangle with label-specific color
      img.drawRect(
        image,
        x1: x,
        y1: y,
        x2: x + w,
        y2: y + h,
        color: boxColor,
        thickness: 8,
      );

      // Draw label
      String label =
          '${recognition.label} ${(recognition.confidence * 100).toInt()}%';

      // Label dimensions
      int labelHeight = 35;
      int labelWidth = (label.length * 12).clamp(80, image.width - x);
      int labelY = (y - labelHeight - 5).clamp(5, image.height - labelHeight);

      // Draw label background
      img.fillRect(
        image,
        x1: x,
        y1: labelY,
        x2: x + labelWidth,
        y2: labelY + labelHeight,
        color: boxColor,
      );

      // Draw text
      img.drawString(
        image,
        label,
        font: img.arial24,
        x: x + 5,
        y: labelY + 5,
        color: img.ColorRgb8(255, 255, 255), // White text
      );
    }
    return image;
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
}

// Fullscreen image preview with detections
class _ImagePreviewScreen extends StatelessWidget {
  final List<int> imageBytes;
  final List<Recognition> detections;

  const _ImagePreviewScreen({
    required this.imageBytes,
    required this.detections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image
          Center(
            child: Image.memory(imageBytes as dynamic, fit: BoxFit.contain),
          ),
          // Close button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
