# YOLOv8 Model Configuration

## Your Model Specifications

### Input
- **Shape**: `float32[1, 640, 640, 3]`
- **Format**: RGB image, normalized to [0, 1]
- **Preprocessing**: 
  - Resize with aspect ratio preserved
  - Fit to 640x640 with black letterbox padding
  - Normalize pixels: `pixel_value / 255.0`

### Outputs

#### Output 0: Predictions `float32[1, 38, 8400]`
- **Format**: `[batch, features, predictions]`
- **8400 predictions** from multiple detection heads
- **38 features per prediction**:
  - Index 0: x_center (normalized 0-1)
  - Index 1: y_center (normalized 0-1)
  - Index 2: width (normalized 0-1)
  - Index 3: height (normalized 0-1)
  - Index 4: megamendung score
  - Index 5: parang score
  - Index 6-37: Additional features (possibly for masks/keypoints)

#### Output 1: Feature Map `float32[1, 160, 160, 32]`
- **Not used** for object detection
- Likely for segmentation or additional features

### Labels
1. **megamendung** (index 0)
2. **parang** (index 1)

## Configuration Applied

### In tflite_service.dart:

```dart
static const int inputSize = 640;           // 640x640 input
static const int numResults = 100;          // Max detections to return
static const double threshold = 0.5;        // Confidence threshold
static const int numPredictions = 8400;     // Total predictions from model
```

### Preprocessing Method:
- `_preprocessImageWithLetterbox()` - Maintains aspect ratio with black padding

### Detection Flow:
1. Camera image → YUV/BGRA conversion
2. Letterbox resize to 640x640
3. Normalize to [0, 1]
4. Model inference
5. Parse [1, 38, 8400] output
6. Apply NMS (Non-Maximum Suppression)
7. Return top detections

### Post-processing:
- **NMS IoU Threshold**: 0.45 (removes overlapping boxes)
- **Confidence Threshold**: 0.5 (filters low-confidence detections)
- **Max Results**: 100 (top detections returned)

## Adjusting Performance

### If too many false positives:
```dart
// In tflite_service.dart, line 25
static const double threshold = 0.6; // Increase from 0.5
```

### If missing detections:
```dart
static const double threshold = 0.3; // Decrease from 0.5
```

### If too many overlapping boxes:
```dart
// In _applyNMS method, line 254
List<Recognition> _applyNMS(List<Recognition> detections, 
    {double iouThreshold = 0.5}) { // Increase from 0.45
```

### If boxes are disappearing:
```dart
{double iouThreshold = 0.3} // Decrease from 0.45
```

## Model Coordinate System

Your model outputs normalized coordinates (0-1):
- **x_center**: 0.0 (left edge) to 1.0 (right edge)
- **y_center**: 0.0 (top edge) to 1.0 (bottom edge)
- **width**: 0.0 to 1.0 (fraction of image width)
- **height**: 0.0 to 1.0 (fraction of image height)

These are automatically converted to corner format (x, y, w, h) for display.

## Testing Your Model

1. **Place your model file**: `lib/assets/models/model.tflite`
2. **Labels are ready**: `lib/assets/models/labels.txt` (megamendung, parang)
3. **Run the app**: `flutter run`
4. **Point camera** at batik patterns

### Expected Behavior:
- Green bounding boxes around detected patterns
- Labels showing "megamendung" or "parang"
- Confidence percentage (e.g., "95%")

### Troubleshooting:

#### No detections appearing:
- Lower threshold: `threshold = 0.3`
- Check model file is in correct location
- Verify labels.txt has exactly 2 lines

#### Wrong labels or indices:
- Ensure labels.txt order matches training:
  - Line 1: megamendung (class 0)
  - Line 2: parang (class 1)

#### App crashes on detection:
- Check model outputs exactly [1, 38, 8400] and [1, 160, 160, 32]
- Verify model is float32 format
- Check Flutter logs: `flutter logs`

#### Bounding boxes in wrong position:
- Model might output pixel coordinates instead of normalized
- Check if coordinates need scaling differently

## Advanced Adjustments

### If your model uses different class score indices:

Edit `_parseYOLOv8Results()` in tflite_service.dart:

```dart
// Currently assumes indices 4 and 5 for 2 classes
double class0Score = output[0][4][i];
double class1Score = output[0][5][i];

// If your model has different layout, adjust indices
// For example, if scores start at index 6:
// double class0Score = output[0][6][i];
// double class1Score = output[0][7][i];
```

### If coordinates are in pixel space instead of normalized:

```dart
// In _parseYOLOv8Results(), after getting coordinates:
// Divide by 640 to normalize
double xCenter = output[0][0][i] / 640.0;
double yCenter = output[0][1][i] / 640.0;
double width = output[0][2][i] / 640.0;
double height = output[0][3][i] / 640.0;
```

## Performance Metrics

### Expected Performance:
- **Inference Time**: ~50-150ms per frame (varies by device)
- **FPS**: ~7-20 FPS during detection
- **Memory**: ~100-200MB additional

### Optimization Tips:
1. Test on physical device (emulator is slower)
2. Reduce detection frequency if laggy
3. Use INT8 quantized model for speed
4. Close other apps to free memory

## Next Steps

1. ✅ Model configuration applied
2. ✅ Labels updated (megamendung, parang)
3. ✅ Preprocessing matches training (640x640, letterbox, black bg)
4. 📋 **Place model.tflite in lib/assets/models/**
5. 🚀 **Run app and test detection**

---

**Your app is now configured for your YOLOv8 batik detection model!**
