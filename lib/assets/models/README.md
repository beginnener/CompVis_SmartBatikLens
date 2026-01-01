# TFLite Model Setup Instructions

This guide will help you add and configure your TFLite model for batik pattern detection.

## Prerequisites

- TFLite model file (`.tflite`)
- Labels file (`.txt`) containing class names, one per line

## Setup Steps

### 1. Add Your Model Files

Place your trained TFLite model and labels file in the following directory:

```
lib/assets/models/
├── model.tflite        # Your TFLite model
└── labels.txt          # Class labels file
```

### 2. Labels File Format

Your `labels.txt` should contain one label per line:

```
batik_parang
batik_kawung
batik_mega_mendung
batik_sekar_jagad
```

### 3. Update Model Configuration

If your model has different input/output specifications, update the constants in `lib/features/lens/services/tflite_service.dart`:

```dart
static const int inputSize = 300;        // Change to your model's input size
static const int numResults = 10;        // Max number of detections
static const double threshold = 0.5;     // Confidence threshold (0.0 - 1.0)
```

### 4. Model Types Supported

The service is configured for **Object Detection models** (e.g., SSD MobileNet, YOLO).

#### Expected Model Output Format:

- **Output 0**: Locations `[1, numResults, 4]` - Bounding box coordinates
- **Output 1**: Classes `[1, numResults]` - Class indices
- **Output 2**: Scores `[1, numResults]` - Confidence scores
- **Output 3**: Number of detections `[1]`

#### If Your Model Has Different Output:

You'll need to modify the `detectObjects()` and `_parseResults()` methods in `tflite_service.dart`.

## Training Your Own Model

### Recommended Approach:

1. **Collect batik images** with bounding box annotations
2. **Use TensorFlow Object Detection API** or **AutoML**
3. **Train an SSD MobileNet** model (lightweight, good for mobile)
4. **Convert to TFLite**:
   ```bash
   tflite_convert \
     --saved_model_dir=./saved_model \
     --output_file=model.tflite \
     --input_shapes=1,300,300,3 \
     --input_arrays=normalized_input_image_tensor \
     --output_arrays=TFLite_Detection_PostProcess,TFLite_Detection_PostProcess:1,TFLite_Detection_PostProcess:2,TFLite_Detection_PostProcess:3
   ```

### Alternative: Use Pre-trained Models

For testing, you can use pre-trained models:
- [TensorFlow Hub](https://tfhub.dev/s?deployment-format=lite)
- [MediaPipe Models](https://developers.google.com/mediapipe/solutions/vision/object_detector)

## Testing

After adding your model:

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

3. **Point the camera at batik patterns** - bounding boxes should appear around detected patterns

## Troubleshooting

### Model Not Loading

- **Check file paths** in `lens_screen.dart` line ~51
- **Verify file names** match exactly (case-sensitive)
- **Check model format** is TFLite (`.tflite` extension)

### No Detections Appearing

- **Lower the confidence threshold** in `tflite_service.dart`
- **Check input image preprocessing** matches your training
- **Verify model is for object detection**, not classification

### App Crashes

- **Check model input/output shapes** match the configuration
- **Enable detailed logging** in `tflite_service.dart` to debug

### Performance Issues

- **Reduce input size** (e.g., from 300x300 to 224x224)
- **Limit detection frequency** by adding delay in image stream
- **Use quantized models** (8-bit) for faster inference

## Image Preprocessing

The current implementation:
- Resizes to `inputSize x inputSize`
- Normalizes pixel values to `[0, 1]`

If your model uses different preprocessing (e.g., `[-1, 1]` normalization), modify `_preprocessImage()` in `tflite_service.dart`:

```dart
// For [-1, 1] normalization:
return [
  (pixel.r - 127.5) / 127.5,
  (pixel.g - 127.5) / 127.5,
  (pixel.b - 127.5) / 127.5,
];
```

## Additional Resources

- [TFLite Flutter Plugin](https://pub.dev/packages/tflite_flutter)
- [TensorFlow Lite Guide](https://www.tensorflow.org/lite/guide)
- [Object Detection Guide](https://www.tensorflow.org/lite/examples/object_detection/overview)
- [Training Custom Models](https://www.tensorflow.org/lite/models/modify/model_maker/object_detection)

## Next Steps

1. Add your model files to `lib/assets/models/`
2. Update `labels.txt` with your batik pattern classes
3. Adjust model configuration if needed
4. Test and iterate on confidence thresholds
5. Optimize performance for your target devices
