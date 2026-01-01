import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class Recognition {
  final String label;
  final double confidence;
  final List<double> location; // [x, y, width, height] normalized 0-1

  Recognition({
    required this.label,
    required this.confidence,
    required this.location,
  });
}

class TFLiteService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;

  // Model input/output shapes for YOLOv8-style model
  static const int inputSize = 640; // 640x640 input
  static const int numResults = 20; // Max detections from 8400 predictions
  static const double threshold = 0.6; // Confidence threshold (higher = faster)
  static const int numPredictions = 8400; // Total predictions from model
  static const int processEveryNPredictions =
      3; // Process every 3rd prediction for speed

  bool get isInitialized => _isInitialized;

  /// Initialize TFLite model
  Future<void> initialize({
    required String modelPath,
    required String labelsPath,
  }) async {
    try {
      // Load the model
      _interpreter = await Interpreter.fromAsset(modelPath);

      // Load labels
      _labels = await _loadLabels(labelsPath);

      _isInitialized = true;
      print('TFLite model initialized successfully');
      print('Input shape: ${_interpreter!.getInputTensors()}');
      print('Output shape: ${_interpreter!.getOutputTensors()}');
    } catch (e) {
      throw Exception('Failed to load TFLite model: $e');
    }
  }

  /// Load labels from asset file
  Future<List<String>> _loadLabels(String labelsPath) async {
    try {
      // Import needed: import 'package:flutter/services.dart';
      final labelsData = await rootBundle.loadString(labelsPath);
      return labelsData.split('\n').where((label) => label.isNotEmpty).toList();
    } catch (e) {
      throw Exception('Failed to load labels: $e');
    }
  }

  /// Run inference on camera image
  Future<List<Recognition>> detectObjects(CameraImage image) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('Model not initialized');
    }

    try {
      // Convert CameraImage to processable format
      final inputImage = _convertCameraImage(image);

      // Preprocess image with letterbox (black background)
      final input = _preprocessImageWithLetterbox(inputImage);

      // Prepare output buffers for YOLOv8 format
      // Output 0: [1, 38, 8400] - predictions
      // Output 1: [1, 160, 160, 32] - feature map (not used for detection)
      var output0 = List.filled(
        1 * 38 * numPredictions,
        0.0,
      ).reshape([1, 38, numPredictions]);
      var output1 = List.filled(
        1 * 160 * 160 * 32,
        0.0,
      ).reshape([1, 160, 160, 32]);

      var outputs = {0: output0, 1: output1};

      // Run inference
      _interpreter!.runForMultipleInputs([input], outputs);

      // Parse YOLOv8 results (only using output0)
      return _parseYOLOv8Results(output0);
    } catch (e) {
      throw Exception('Detection failed: $e');
    }
  }

  /// Run inference on static image (for captured photos)
  Future<List<Recognition>> detectObjectsFromImage(img.Image image) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('Model not initialized');
    }

    try {
      // Preprocess image with letterbox (black background)
      final input = _preprocessImageWithLetterbox(image);

      // Prepare output buffers for YOLOv8 format
      var output0 = List.filled(
        1 * 38 * numPredictions,
        0.0,
      ).reshape([1, 38, numPredictions]);
      var output1 = List.filled(
        1 * 160 * 160 * 32,
        0.0,
      ).reshape([1, 160, 160, 32]);

      var outputs = {0: output0, 1: output1};

      // Run inference
      _interpreter!.runForMultipleInputs([input], outputs);

      // Parse YOLOv8 results (only using output0)
      return _parseYOLOv8Results(output0);
    } catch (e) {
      throw Exception('Detection failed: $e');
    }
  }

  /// Convert CameraImage to img.Image
  img.Image _convertCameraImage(CameraImage image) {
    try {
      // Handle different image formats
      if (image.format.group == ImageFormatGroup.yuv420) {
        return _convertYUV420ToImage(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        return _convertBGRA8888ToImage(image);
      }
      throw Exception('Unsupported image format');
    } catch (e) {
      throw Exception('Image conversion failed: $e');
    }
  }

  /// Convert YUV420 to img.Image (optimized)
  img.Image _convertYUV420ToImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    var imgData = img.Image(width: width, height: height);
    final yPlane = image.planes[0].bytes;
    final uPlane = image.planes[1].bytes;
    final vPlane = image.planes[2].bytes;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvPixelStride * (x >> 1) + uvRowStride * (y >> 1);
        final int index = y * width + x;

        final int yp = yPlane[index];
        final int up = uPlane[uvIndex];
        final int vp = vPlane[uvIndex];

        // Simplified YUV to RGB conversion for speed
        int r = (yp + ((vp - 128) * 1.402)).toInt().clamp(0, 255);
        int g = (yp - ((up - 128) * 0.344) - ((vp - 128) * 0.714))
            .toInt()
            .clamp(0, 255);
        int b = (yp + ((up - 128) * 1.772)).toInt().clamp(0, 255);

        imgData.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    return imgData;
  }

  /// Convert BGRA8888 to img.Image
  img.Image _convertBGRA8888ToImage(CameraImage image) {
    return img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: img.ChannelOrder.bgra,
    );
  }

  /// Preprocess image with letterbox (black background) for model input
  List<List<List<List<double>>>> _preprocessImageWithLetterbox(
    img.Image image,
  ) {
    // Calculate scaling to fit image in 640x640 with aspect ratio preserved
    final scale =
        inputSize / (image.width > image.height ? image.width : image.height);
    final newWidth = (image.width * scale).round();
    final newHeight = (image.height * scale).round();

    // Resize image maintaining aspect ratio
    var resizedImage = img.copyResize(
      image,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.linear,
    );

    // Create 640x640 black background image
    var letterboxImage = img.Image(width: inputSize, height: inputSize);

    // Fill with black
    img.fill(letterboxImage, color: img.ColorRgb8(0, 0, 0));

    // Calculate offset to center the resized image
    final offsetX = (inputSize - newWidth) ~/ 2;
    final offsetY = (inputSize - newHeight) ~/ 2;

    // Paste resized image onto black background
    img.compositeImage(
      letterboxImage,
      resizedImage,
      dstX: offsetX,
      dstY: offsetY,
    );

    // Normalize pixel values to [0, 1] for float32 input
    var input = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(inputSize, (x) {
          var pixel = letterboxImage.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );

    return input;
  }

  /// Parse YOLOv8 detection results from [1, 38, 8400] output
  /// Format: [batch, features, predictions] where features = [x, y, w, h, ...class_scores...]
  List<Recognition> _parseYOLOv8Results(List output) {
    List<Recognition> recognitions = [];

    // YOLOv8 output format: [1, 38, 8400]
    // First 4 values: bbox (x_center, y_center, width, height)
    // Remaining values include class scores
    // For 2 classes, we expect scores at indices 4 and 5 (or similar)

    for (int i = 0; i < numPredictions; i++) {
      // Get bbox coordinates (normalized 0-1)
      double xCenter = output[0][0][i];
      double yCenter = output[0][1][i];
      double width = output[0][2][i];
      double height = output[0][3][i];

      // Get class scores (assuming indices 4-5 for 2 classes)
      // If your model has different layout, adjust these indices
      double class0Score = output[0][4][i];
      double class1Score = output[0][5][i];

      // Find max class score and index
      double maxScore = class0Score > class1Score ? class0Score : class1Score;
      int classIndex = class0Score > class1Score ? 0 : 1;

      // Apply threshold
      if (maxScore > threshold) {
        // Convert from center format to corner format (x, y, w, h)
        // Already normalized to 0-1
        var location = <double>[
          (xCenter - width / 2).clamp(0.0, 1.0), // left x
          (yCenter - height / 2).clamp(0.0, 1.0), // top y
          width.clamp(0.0, 1.0), // width
          height.clamp(0.0, 1.0), // height
        ];

        String label = classIndex < _labels.length
            ? _labels[classIndex]
            : 'Unknown';

        recognitions.add(
          Recognition(label: label, confidence: maxScore, location: location),
        );
      }
    }

    // Apply Non-Maximum Suppression (NMS) to remove overlapping boxes
    recognitions = _applyNMS(recognitions);

    // Return top N results
    recognitions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return recognitions.take(numResults).toList();
  }

  /// Apply Non-Maximum Suppression to remove overlapping detections
  List<Recognition> _applyNMS(
    List<Recognition> detections, {
    double iouThreshold = 0.45,
  }) {
    if (detections.isEmpty) return [];

    // Sort by confidence (highest first)
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    List<Recognition> selected = [];
    List<bool> active = List.filled(detections.length, true);

    for (int i = 0; i < detections.length; i++) {
      if (!active[i]) continue;

      selected.add(detections[i]);

      // Suppress overlapping boxes
      for (int j = i + 1; j < detections.length; j++) {
        if (!active[j]) continue;

        double iou = _calculateIOU(
          detections[i].location,
          detections[j].location,
        );
        if (iou > iouThreshold) {
          active[j] = false;
        }
      }
    }

    return selected;
  }

  /// Calculate Intersection over Union (IoU) between two boxes
  double _calculateIOU(List<double> box1, List<double> box2) {
    // box format: [x, y, width, height]
    double x1 = box1[0], y1 = box1[1], w1 = box1[2], h1 = box1[3];
    double x2 = box2[0], y2 = box2[1], w2 = box2[2], h2 = box2[3];

    double x1_max = x1 + w1, y1_max = y1 + h1;
    double x2_max = x2 + w2, y2_max = y2 + h2;

    // Calculate intersection
    double intersectX =
        (x1_max < x2_max ? x1_max : x2_max) - (x1 > x2 ? x1 : x2);
    double intersectY =
        (y1_max < y2_max ? y1_max : y2_max) - (y1 > y2 ? y1 : y2);

    if (intersectX <= 0 || intersectY <= 0) return 0.0;

    double intersectArea = intersectX * intersectY;
    double box1Area = w1 * h1;
    double box2Area = w2 * h2;
    double unionArea = box1Area + box2Area - intersectArea;

    return unionArea > 0 ? intersectArea / unionArea : 0.0;
  }

  /// Close the interpreter
  void dispose() {
    _interpreter?.close();
    _isInitialized = false;
  }
}
