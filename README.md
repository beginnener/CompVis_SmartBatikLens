# Smart Batik Lens 🎨

> **Status**: 🚀 Ready for Model Integration | 📱 App Fully Functional | 🧪 Awaiting Trained Model

**Implementasi Object Detection untuk Identifikasi Motif Batik pada Produk Kreatif dan Fashion**

Smart Batik Lens adalah aplikasi mobile berbasis Computer Vision yang mampu mendeteksi dan mengidentifikasi motif batik secara real-time menggunakan teknologi YOLO (You Only Look Once). Aplikasi ini dapat mengenali motif batik pada berbagai media, termasuk pakaian yang terlipat, aksesoris, dan produk kreatif lainnya.

## ⚡ Quick Start

```bash
# Clone repository
git clone https://github.com/beginnener/CompVis_SmartBatikLens.git
cd CompVis_SmartBatikLens

# Install dependencies
flutter pub get

# Add your trained model
# Place model.tflite in lib/assets/models/

# Run app
flutter run
```

**Prerequisites**: Flutter 3.10.4+, Android Studio/Xcode, Trained TFLite model

---

## 🎯 Latar Belakang

Batik Indonesia telah diakui oleh UNESCO sebagai Warisan Budaya Tak Benda sejak 2 Oktober 2009. Meskipun penggunaan batik meningkat pesat dalam kehidupan modern, pengetahuan mendalam mengenai motif spesifik seringkali minim, terutama di kalangan generasi muda. Fenomena "Tahu Batik tapi Tidak Tahu Namanya" menjadi ironi di era digital ini.

Metode konvensional seperti bertanya kepada ahli atau mencari di katalog dirasa tidak praktis. Solusi berbasis AI yang ada saat ini mayoritas menggunakan **Image Classification** yang memiliki keterbatasan: pengguna harus memotret motif secara datar dan close-up. Padahal dalam kondisi nyata, motif batik seringkali terdistorsi (terlipat, melengkung, atau sebagian tertutup).

**Smart Batik Lens** hadir dengan pendekatan **Object Detection** yang lebih canggih, mampu mendeteksi motif batik meskipun berada dalam kondisi yang kompleks dan tidak ideal.

---

## ✨ Fitur Utama

### 🎯 Implemented Features (v1.0.0)

- ✅ **Real-time Detection**: Deteksi motif batik secara langsung melalui kamera dengan TFLite
- ✅ **Robust Object Detection**: Menggunakan arsitektur YOLO/SSD untuk deteksi pada objek terdistorsi
- ✅ **Bounding Box Visualization**: Custom painter untuk overlay detection results
- ✅ **Camera Integration**: Streaming camera dengan `camera` package
- ✅ **Gallery Support**: Import dan analisis foto dari galeri dengan `image_picker`
- ✅ **Photo Capture**: Simpan snapshot hasil deteksi
- ✅ **History Management**: Riwayat lengkap semua deteksi dengan persistent storage
- ✅ **Favorites System**: Tandai dan simpan deteksi favorit
- ✅ **Persistent Storage**: SharedPreferences untuk menyimpan history & favorites
- ✅ **Error Handling**: Comprehensive error states & user feedback
- ✅ **Material Design 3**: Modern UI dengan custom color scheme
- ✅ **Multi-Object Detection**: Deteksi multiple motif dalam satu frame

### 🎨 Detection Capabilities

- 🔍 **Multi-Pattern Recognition**: Support untuk deteksi simultan multiple motif
- 📊 **Confidence Scoring**: Menampilkan confidence percentage untuk setiap deteksi
- 🎯 **Adaptive Thresholding**: Configurable confidence threshold
- 📐 **Precise Localization**: Bounding box dengan koordinat akurat
- 🏷️ **Label Display**: Nama motif dan confidence ditampilkan on-screen

### Motif yang Dapat Dideteksi (dengan model yang sesuai)

| Motif | Asal | Karakteristik |
|-------|------|---------------|
| **Megamendung** | Cirebon | Motif awan berarak dengan gradasi warna |
| **Parang** | Yogyakarta/Solo | Motif garis diagonal menyerupai huruf 'S' |
| _Extensible_ | - | Tambahkan motif lain dengan retrain model |

---

## 🛠️ Teknologi yang Digunakan

### Mobile Application
- **Framework**: Flutter 3.x (SDK ^3.10.4)
- **Language**: Dart
- **State Management**: StatefulWidget (Native Flutter State)
- **ML Integration**: TensorFlow Lite Flutter (`tflite_flutter: ^0.11.0`)
- **Camera**: `camera: ^0.11.0`
- **Storage**: SharedPreferences (`shared_preferences: ^2.5.4`)
- **Image Processing**: `image: ^4.0.17`, `image_picker: ^1.0.0`

### Computer Vision & Machine Learning
- **Model Architecture**: YOLOv8 Nano (recommended) / SSD MobileNet / Custom
- **Framework**: Ultralytics YOLO / TensorFlow Object Detection API
- **Runtime**: TensorFlow Lite (on-device inference)
- **Input Format**: RGB images (300x300 or 640x640)
- **Output Format**: Bounding boxes, class IDs, confidence scores
- **Supported Formats**: `.tflite` (non-quantized or INT8)

### App Services Architecture
```
📦 Core Services:
├── TFLiteService      # ML inference engine
│   ├── Model loading & initialization
│   ├── Image preprocessing (YUV/BGRA → RGB)
│   ├── Object detection inference
│   └── Result parsing & filtering
├── CameraService      # Camera management
│   ├── Camera initialization
│   ├── Image stream handling
│   └── Photo capture
└── StorageService     # Data persistence
    ├── History management (SharedPreferences)
    ├── Favorites management
    └── Photo storage
```

### Dataset Composition (for training)
```
📊 Recommended Dataset Breakdown:
├── Target Classes: 500+ images each
├── Background: 10-15% of total
└── Augmented: 2-3x original

📦 Object Types Variety:
├── Kain Datar (Plain): ~25%
├── Pakaian (Fashion): ~50%
└── Aksesoris (Merchandise): ~25%
```

---

## 🚀 Instalasi dan Setup

### Prerequisites

Pastikan sistem Anda telah terinstal:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.0 atau lebih baru)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / Xcode (untuk development)
- Git

### Clone Repository

```bash
git clone https://github.com/beginnener/CompVis_SmartBatikLens.git
cd CompVis_SmartBatikLens
```

### Install Dependencies

```bash
flutter pub get
```

### Setup TFLite Model

1. **Place your trained model** in `lib/assets/models/`:
   - `model.tflite` - Your YOLOv8 or SSD MobileNet model
   - `labels.txt` - Class labels (one per line)

2. **Configure model settings** (if needed) in `lib/features/lens/services/tflite_service.dart`:
   ```dart
   static const int inputSize = 300;        // Match your model's input size
   static const int numResults = 10;        // Max detections
   static const double threshold = 0.5;     // Confidence threshold
   ```

3. **Verify model format**: The app expects Object Detection models (not classification)

For detailed setup instructions, see [`lib/assets/models/README.md`](lib/assets/models/README.md)

### Run Application

```bash
# Android
flutter run

# iOS (Mac only - requires Xcode)
flutter run

# Note: Web is not supported due to camera and TFLite requirements
```

### Platform-Specific Setup

**Android**: No additional setup required

**iOS**: 
1. Add camera permissions to `ios/Runner/Info.plist`:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Camera needed for batik detection</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>Access photos to detect batik patterns</string>
   ```

---

## 📁 Struktur Proyek

```
CompVis_SmartBatikLens/
├── lib/
│   ├── main.dart                       # Entry point - Camera initialization
│   ├── app/
│   │   └── smart_batik_app.dart        # Root widget & routing
│   ├── assets/
│   │   └── models/
│   │       ├── README.md               # Model setup guide
│   │       ├── labels.txt              # Sample labels file
│   │       ├── MODEL_CONFIG.md         # Model configuration
│   │       └── model.tflite            # (Place your model here)
│   ├── features/                       # Feature-based architecture
│   │   ├── splash/
│   │   │   └── splash_screen.dart      # Splash screen with navigation
│   │   ├── lens/                       # Main detection feature
│   │   │   ├── presentation/
│   │   │   │   ├── lens_screen.dart    # Camera & detection UI
│   │   │   │   └── widgets/
│   │   │   │       └── bounding_box_painter.dart  # Detection overlay
│   │   │   └── services/
│   │   │       ├── camera_service.dart      # Camera management
│   │   │       ├── storage_service.dart     # History/favorites storage
│   │   │       └── tflite_service.dart      # ML inference engine
│   │   ├── history/
│   │   │   └── history_page.dart       # Detection history
│   │   └── favorites/
│   │       └── favorite_page.dart      # Saved favorites
│   ├── core/                           # Core infrastructure (prepared)
│   │   ├── constants/
│   │   ├── di/                         # Dependency injection
│   │   ├── errors/                     # Error handling
│   │   ├── models/                     # Data models
│   │   ├── routes/                     # Route management
│   │   ├── services/                   # Core services
│   │   └── utils/                      # Utilities
│   └── shared/                         # Shared resources
│       └── constant/
│           └── app_colors.dart         # App color scheme
├── android/                            # Android native code
├── ios/                                # iOS native code
├── test/                               # Unit & widget tests
├── pubspec.yaml                        # Dependencies
├── IMPLEMENTATION_SUMMARY.md           # Detailed implementation notes
├── MODEL_READY.md                      # Model integration status
└── README.md                           # This file
```

### Architecture Highlights

- **Clean Architecture**: Feature-based module structure
- **Service Layer**: Separated camera, storage, and ML services
- **Custom Rendering**: Optimized bounding box painter
- **Error Handling**: Comprehensive error states throughout

---

## 🎓 Cara Penggunaan

### First Time Setup

1. **Launch Application**: Buka Smart Batik Lens di perangkat Android/iOS
2. **Grant Permissions**: Izinkan akses kamera dan penyimpanan
3. **Wait for Model Load**: Splash screen akan memuat model TFLite (pertama kali ~2-3 detik)

### Detection Flow

1. **Main Screen**: Tap tombol **"Scan"** untuk membuka kamera
2. **Position Camera**: Arahkan kamera ke produk batik
   - Jarak ideal: 30-50 cm
   - Pastikan pencahayaan cukup
   - Motif harus terlihat jelas (tidak blur)
3. **Real-time Detection**: 
   - Bounding box akan muncul otomatis di sekitar motif
   - Label dan confidence score ditampilkan di atas box
   - Support multiple detections dalam satu frame
4. **Capture**: Tap tombol kamera untuk menyimpan snapshot
5. **Gallery Import**: Tap tombol galeri untuk analisis foto existing

### Managing Results

- **History**: Akses semua deteksi yang pernah dilakukan
- **Favorites**: Tandai deteksi favorit dengan tap ikon bintang
- **Delete**: Swipe atau tap delete untuk menghapus entry

### Tips untuk Hasil Terbaik

✅ **DO**:
- Gunakan pencahayaan natural atau cahaya putih
- Jaga kamera stabil (hindari blur)
- Biarkan motif memenuhi 30-70% frame
- Coba berbagai sudut jika deteksi tidak optimal

❌ **DON'T**:
- Jangan terlalu dekat (under 20 cm) - motif terpotong
- Hindari backlight ekstrem
- Jangan gunakan zoom digital berlebihan
- Hindari refleksi cahaya pada kain

### Troubleshooting

| Issue | Solution |
|-------|----------|
| No bounding box appears | Lower confidence threshold di `tflite_service.dart` |
| Detection too slow | Reduce model input size atau skip frames |
| Wrong detections | Retrain model dengan dataset lebih beragam |
| App crashes on open | Check camera permissions & model file exists |

---

## 🧪 Model Training & Integration

### Using Pre-trained Model

Aplikasi ini ready untuk model TFLite format Object Detection:

**Compatible Model Types**:
- YOLOv8 Nano (recommended - lightweight)
- SSD MobileNet
- EfficientDet Lite
- Custom object detection models

**Model Requirements**:
- Input: RGB image (typically 300x300 or 640x640)
- Output: Bounding boxes, class IDs, confidence scores
- Format: `.tflite` (non-quantized or int8 quantized)

### Training Your Own Model

#### Option 1: Using Ultralytics YOLO

```bash
# Install Ultralytics
pip install ultralytics

# Train YOLOv8 Nano
yolo detect train data=data.yaml model=yolov8n.pt epochs=100 imgsz=640

# Export to TFLite
yolo export model=runs/detect/train/weights/best.pt format=tflite int8=True
```

#### Option 2: TensorFlow Object Detection API

```bash
# Convert saved_model to TFLite
tflite_convert \
  --saved_model_dir=./saved_model \
  --output_file=model.tflite \
  --input_shapes=1,300,300,3 \
  --input_arrays=normalized_input_image_tensor
```

### Dataset Guidelines

Untuk hasil optimal, gunakan dataset dengan karakteristik:

**Composition**:
- Minimum 500 images per class
- Include 10-15% background/negative samples
- Balanced class distribution

**Diversity**:
- Various lighting conditions (natural, indoor, outdoor)
- Different angles and perspectives
- Multiple object states (flat, folded, on clothing, accessories)
- Scale variety (close-up to far shots)

**Augmentation** (recommended):
- Auto-Orient
- Resize: Match your target input size
- Horizontal & Vertical Flip
- Rotation: ±15°
- Brightness: ±25%
- Gaussian Blur: 0-1.5px
- Generation: 2-3x

### Post-Training Integration

1. Place `model.tflite` in `lib/assets/models/`
2. Update `labels.txt` with your class names
3. Adjust `tflite_service.dart` constants if needed:
   - `inputSize`: Match training input
   - `threshold`: Start at 0.5, tune based on results
4. Test thoroughly on target devices

For detailed training guide, see [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md)

---

## 🎯 Tantangan dan Solusi

### 1. Variasi Objek dan Distorsi Geometris
**Tantangan**: Motif pada pakaian terlipat, permukaan melengkung, atau sebagian tertutup  
**Solusi**: 
- Dataset beragam dengan berbagai kondisi objek
- Augmentasi geometris intensif (rotation, flip, perspective)
- Object detection vs classification approach

### 2. Kemiripan Visual dan Pola Repetitif
**Tantangan**: Pola dekoratif lain yang mirip batik (false positive), pola repetitif yang kompleks  
**Solusi**: 
- Penambahan kelas "background" dengan negative samples
- Training dengan konteks lingkungan (bukan hanya close-up motif)
- Fine-tuning confidence threshold

### 3. Keterbatasan Resource Perangkat Mobile
**Tantangan**: Real-time inference pada perangkat mid-to-low end  
**Solusi**: 
- YOLOv8 Nano (parameter minimal, optimized untuk mobile)
- TFLite quantization (INT8)
- Adaptive frame skip based on device performance
- Efficient image preprocessing

### 4. Lighting & Image Quality Variations
**Tantangan**: Performa menurun pada kondisi cahaya buruk atau blur  
**Solusi**:
- Dataset mencakup berbagai kondisi pencahayaan
- Brightness augmentation saat training
- Auto-exposure feedback ke user
- Motion blur detection & warning

---

## 📊 Performa Model & App

### Model Performance (Expected with YOLOv8n)

| Metric | Target Value | Notes |
|--------|--------------|-------|
| **Model Size** | ~6 MB | TFLite quantized |
| **Inference Time** | 50-150ms | On mid-range Android (Snapdragon 600+) |
| **mAP@0.5** | 75-85% | Depends on training quality |
| **mAP@0.5:0.95** | 45-55% | Standard COCO metric |
| **FPS** | 10-20 FPS | Real-time detection |

### App Performance

| Platform | Status | Notes |
|----------|--------|-------|
| **Android** | ✅ Supported | Min SDK 21 (Lollipop) |
| **iOS** | ✅ Supported | iOS 11.0+ |
| **Web** | ❌ Not supported | TFLite & camera limitations |
| **Desktop** | ⚠️ Experimental | Camera support varies |

### System Requirements

**Minimum**:
- Android 5.0 (API 21) / iOS 11.0
- 2GB RAM
- Camera with autofocus
- 100MB free storage

**Recommended**:
- Android 8.0+ / iOS 13.0+
- 4GB RAM
- 12MP+ camera
- 200MB free storage

### Performance Optimization Tips

If experiencing lag:
1. Reduce `inputSize` in `tflite_service.dart` (e.g., 320x320 instead of 640x640)
2. Use quantized INT8 model
3. Skip frames: Process every 2nd or 3rd frame
4. Lower `numResults` to reduce post-processing
5. Test on physical device (not emulator)

---

## 🤝 Kontributor

Proyek ini dikembangkan sebagai Proyek Akhir mata kuliah **Computer Vision** - Universitas Pendidikan Indonesia (2025)

**Tim Pengembang**:
- **Zakiyah Hasanah** (2305274) - [kiyahh@upi.edu](mailto:kiyahh@upi.edu)  
  _Project Lead, ML Engineer, Mobile Developer_
  
- **Hafsah Hamidah** (2311474) - [hafsahhamidah25@upi.edu](mailto:hafsahhamidah25@upi.edu)  
  _ML Engineer, Dataset Curator_
  
- **Natasha Adinda Cantika** (2312120) - [natashadind@upi.edu](mailto:natashadind@upi.edu)  
  _Mobile Developer, UI/UX Designer_

**Dosen Pengampu**:  
Yaya Wihardi, S.Kom., M.Kom.  
_Fakultas Pendidikan Matematika dan Ilmu Pengetahuan Alam_

---

## 📄 Dokumentasi Tambahan

- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Detailed technical implementation
- [MODEL_READY.md](MODEL_READY.md) - Model integration status
- [QUICK_START.md](QUICK_START.md) - Quick setup guide
- [lib/assets/models/README.md](lib/assets/models/README.md) - Model setup instructions

---

## 📝 Lisensi

Proyek ini dibuat untuk keperluan akademis sebagai Proyek Akhir mata kuliah Computer Vision di Universitas Pendidikan Indonesia.

**Penggunaan**:
- ✅ Pembelajaran dan penelitian akademis
- ✅ Pengembangan non-komersial
- ✅ Fork dan modifikasi dengan atribusi

Untuk penggunaan komersial atau kolaborasi, silakan hubungi tim pengembang.

---

## 🙏 Acknowledgments

- **UNESCO** - Pengakuan Batik sebagai Warisan Budaya Tak Benda Manusia (2009)
- **[Ultralytics](https://github.com/ultralytics/ultralytics)** - YOLO framework untuk object detection
- **[Roboflow](https://roboflow.com/)** - Platform preprocessing dan augmentasi dataset
- **[TensorFlow Lite](https://www.tensorflow.org/lite)** - On-device ML inference
- **[Flutter Team](https://flutter.dev)** - Cross-platform UI framework
- **Komunitas Batik Indonesia** - Inspirasi dan motivasi untuk melestarikan budaya
- **Dosen & Asisten Lab CV UPI** - Bimbingan dan dukungan teknis

### Special Thanks
- Museum Batik Indonesia - Referensi motif dan sejarah
- Pengrajin batik Cirebon & Solo - Wawasan tentang motif tradisional
- Beta testers - Feedback untuk improvement aplikasi

---

## 📞 Kontak & Support

### Untuk Pertanyaan Teknis
- **GitHub Issues**: [Create Issue](https://github.com/beginnener/CompVis_SmartBatikLens/issues)
- **Email**: [kiyahh@upi.edu](mailto:kiyahh@upi.edu)

### Untuk Kolaborasi
- **Email**: [kiyahh@upi.edu](mailto:kiyahh@upi.edu)
- **Subject**: "Smart Batik Lens Collaboration - [Your Topic]"

### Bug Reports
Saat melaporkan bug, sertakan:
1. Device & OS version
2. App version
3. Steps to reproduce
4. Screenshots/videos (jika ada)
5. Error logs (jika ada)

---

## 🌟 Star History

Jika proyek ini membantu Anda, jangan lupa untuk memberikan ⭐ di GitHub!

---

## 📸 Screenshots

_[Coming soon - Add actual app screenshots here]_

---

### Current Version (v1.0.0)
- ✅ Real-time object detection
- ✅ Camera & gallery support
- ✅ History & favorites
- ✅ TFLite integration
- ✅ Bounding box visualization

### Planned Features

**v1.1.0** (Q1 2026)
- [ ] Expand motif library (Kawung, Truntum, Sekar Jagad, dll)
- [ ] Offline batik encyclopedia
- [ ] Detection confidence history graph
- [ ] Dark mode support

**v1.2.0** (Q2 2026)
- [ ] Multi-language support (English, Indonesia)
- [ ] Share detection results to social media
- [ ] Export results as PDF report
- [ ] Cloud sync for history (optional)

**v2.0.0** (Q3 2026)
- [ ] AR visualization (overlay motif info in AR)
- [ ] Marketplace integration for batik products
- [ ] Community features (share & discover batik)
- [ ] Advanced analytics dashboard

### Research & Development
- [ ] Segmentation model for precise motif boundaries
- [ ] Style transfer: Apply batik patterns to custom designs
- [ ] Region-specific classification (Java, Sumatra, Kalimantan, etc.)
- [ ] Historical context & cultural significance database

---

<p align="center">
  <strong>Lestarikan Budaya dengan Teknologi 🇮🇩</strong><br>
  Made with ❤️ in Bandung, Indonesia
</p>
