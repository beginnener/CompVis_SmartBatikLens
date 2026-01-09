# Smart Batik Lens 🎨

**Status:** ✅ Model Ready | 🚀 Production Ready | 📱 App Berfungsi Penuh

**Aplikasi Deteksi Motif Batik Berbasis Flutter & Computer Vision**

Smart Batik Lens adalah aplikasi mobile berbasis Flutter yang memanfaatkan Computer Vision untuk mendeteksi dan mengidentifikasi motif batik secara real-time. Dengan model YOLOv8 Nano pre-trained dari Roboflow (932 images, 2 motif: Megamendung & Parang) dan TensorFlow Lite, aplikasi ini mampu mengenali motif batik pada berbagai kondisi dan media—pakaian, aksesoris, produk kreatif—bahkan saat terlipat atau terdistorsi.

---

## ⚡ Quick Start

```bash
git clone https://github.com/beginnener/CompVis_SmartBatikLens.git
cd CompVis_SmartBatikLens
flutter pub get
# Model YOLOv8 Nano pre-trained sudah included & siap pakai
flutter run
```

**Prasyarat:** Flutter 3.10.4+, Dart SDK, Android Studio/Xcode
**Note:** Model YOLOv8 Nano pre-trained dari Roboflow sudah included & siap pakai

---

## 🎯 Latar Belakang

Batik Indonesia diakui UNESCO sebagai Warisan Budaya Tak Benda sejak 2009. Namun, pengetahuan tentang motif batik masih terbatas, terutama di generasi muda. Solusi AI yang ada saat ini mayoritas berbasis **Image Classification**, yang memerlukan motif difoto datar dan close-up—padahal kondisi nyata seringkali tidak ideal (terlipat, melengkung, tertutup).

**Smart Batik Lens** menggunakan pendekatan **Object Detection** (YOLOv8 + TFLite) yang jauh lebih adaptif, mampu mendeteksi motif batik dalam berbagai kondisi, sudut, dan media tanpa membatasi cara pengguna mengambil foto.

---

## ✨ Fitur Utama (v1.0.0)

### Core Features
- **Real-time Detection**: Deteksi langsung dari kamera dengan TFLite inference ≤150ms
- **Object Detection Robust**: Deteksi motif pada kondisi terlipat, melengkung, tertutup
- **Multi-Object Detection**: Kenali beberapa motif dalam satu frame
- **Camera & Gallery**: Live preview atau analisis foto existing
- **History & Favorites**: Simpan, kelola, tandai hasil deteksi
- **Bounding Box Visualization**: Custom overlay dengan label & confidence score
- **Material Design 3**: UI modern dengan Material 3 components

### Detection Capabilities
- **Confidence Scoring**: Percentage score untuk setiap deteksi
- **Configurable Threshold**: Tuning sensitivity sesuai kebutuhan
- **On-Screen Labels**: Nama motif & score ditampilkan real-time
- **Persistent Storage**: History & favorites tersimpan lokal via SharedPreferences

### Motif yang Didukung

| Motif           | Asal             | Deskripsi                                 |
|-----------------|------------------|-------------------------------------------|
| Megamendung     | Cirebon          | Awan berarak, gradasi warna halus          |
| Parang          | Yogyakarta/Solo  | Garis diagonal menyerupai huruf 'S'       |
| _Custom_        | -                | Retrain dengan motif pilihan Anda         |

---

## 🛠️ Tech Stack & Dependencies

### Mobile Application
| Component          | Teknologi                        | Version  |
|--------------------|----------------------------------|----------|
| Framework          | Flutter                          | ^3.10.4  |
| Language           | Dart                             | -        |
| ML Runtime         | TensorFlow Lite Flutter          | ^0.11.0  |
| Camera             | camera                           | ^0.11.0  |
| Storage            | shared_preferences               | ^2.2.2   |
| Image Processing   | image, image_picker              | ^4.0.17  |
| UI Framework       | Material Design 3                | built-in |

### Computer Vision & Model
| Aspek              | Detail                           |
|--------------------|----------------------------------|
| Model Architecture | YOLOv8 Nano (recommended)        |
| Alternatif         | SSD MobileNet, EfficientDet      |
| Framework Training | Ultralytics YOLO v8              |
| Runtime            | TensorFlow Lite (on-device)      |
| Input Size         | 300x300 atau 640x640 (RGB)       |
| Output             | Bounding boxes + class IDs + confidence |
| Format Model       | .tflite (quantized INT8 optimal) |

### App Services Architecture
```
📦 Core Services:
├── TFLiteService         # ML inference engine
│   ├── Model loading & initialization
│   ├── Image preprocessing (YUV/BGRA → RGB)
│   ├── Object detection inference (~100-150ms)
│   ├── NMS post-processing
│   └── Result filtering by confidence threshold
├── CameraService         # Camera management
│   ├── Initialize & manage camera stream
│   ├── Real-time frame capture
│   ├── Photo snapshot save
│   └── Permission handling
└── StorageService        # Data persistence
    ├── History: Save detection results (SharedPreferences)
    ├── Favorites: Bookmark detections
    ├── Image storage: Save snapshots locally
    └── Retrieval & deletion operations
```

### Dataset Composition (untuk Training)
```
📊 Rekomendasi Breakdown:
├── Per Class: 500+ images minimum
├── Background/Negative Samples: 10-15%
├── Data augmentation: 2-3x multiplier
└── Total target: 2000-3000 images

📦 Variasi Objek:
├── Kain Datar (Plain): ~25%
├── Pakaian (Fashion): ~50%
└── Aksesoris (Merchandise): ~25%
```

---

## 🚀 Instalasi & Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (min 3.10.4)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- Android Studio / Xcode
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

### Setup Model TFLite (Pre-trained Ready ✅)
**Model Saat Ini:** YOLOv8 Nano pre-trained dari Roboflow
- ✅ Sudah tersimpan di `lib/assets/models/`
- ✅ Training dataset: 932 images (batik detection v2)
- ✅ Classes: Megamendung, Parang
- ✅ Format: TFLite Object Detection (.tflite)
- ✅ Size: ~6 MB (INT8 quantized)

**Setup:**
1. Verifikasi file ada di `lib/assets/models/`:
   - `model.tflite` (Model YOLOv8 Nano)
   - `labels.txt` (Class: megamendung, parang)
2. Konfigurasi `lib/features/lens/services/tflite_service.dart` jika diperlukan:
   ```dart
   static const int inputSize = 640;        // Model input size
   static const int numResults = 10;        // Max detections
   static const double threshold = 0.5;     // Confidence threshold (tunable)
   ```
3. Jalankan aplikasi - model siap deteksi!

**Training Custom Model:** Lihat [Model Training & Integration](#-model-training--integration) section

Detail di [`lib/assets/models/README.md`](lib/assets/models/README.md)

### Jalankan Aplikasi
```bash
flutter run          # Android default
flutter run -d <device_id>  # Device tertentu
```

**Platform Support:**
- ✅ Android (min API 21)
- ✅ iOS (min iOS 11.0)
- ❌ Web (TFLite limitations)

**iOS Setup:**
- Tambahkan ke `ios/Runner/Info.plist`:
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Kamera diperlukan untuk deteksi batik</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>Akses foto untuk deteksi motif batik</string>
  ```

---

## 📁 Project Structure

```
CompVis_SmartBatikLens/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── app/
│   │   └── smart_batik_app.dart  # Root widget, routing
│   ├── assets/models/
│   │   ├── model.tflite          # Place your model here
│   │   ├── labels.txt            # Class labels
│   │   └── README.md             # Model setup guide
│   ├── features/
│   │   ├── splash/
│   │   ├── lens/                 # Main detection feature
│   │   │   ├── presentation/
│   │   │   │   ├── lens_screen.dart
│   │   │   │   └── widgets/bounding_box_painter.dart
│   │   │   └── services/
│   │   │       ├── tflite_service.dart
│   │   │       ├── camera_service.dart
│   │   │       └── storage_service.dart
│   │   ├── history/
│   │   └── favorites/
│   ├── core/
│   └── shared/
├── android/ | ios/ | web/        # Platform-specific
├── pubspec.yaml
├── IMPLEMENTATION_SUMMARY.md
├── MODEL_READY.md
└── README.md
```

### Architecture
- **Feature-based Modular:** Setiap fitur independent, scalable
- **Service Layer:** TFLite, Camera, Storage terpisah
- **Clean Separation:** UI (presentation) ≠ Logic (services)
- **Error Handling:** Try-catch comprehensive, user feedback

---

## 🎓 Penggunaan Aplikasi

### Setup Pertama
1. Buka aplikasi di Android/iOS
2. Berikan izin: Kamera & penyimpanan
3. Tunggu model TFLite termuat (~2-3 detik, pertama kali saja)

### Alur Deteksi
1. **Tap "Scan"** → Buka kamera real-time
2. **Arahkan** ke produk batik (jarak 30-50 cm, motif jelas)
3. **Deteksi otomatis:** Bounding box + label + confidence score muncul real-time
4. **Tap kamera** → Simpan snapshot
5. **Tap galeri** → Analisis foto existing

### Manajemen Hasil
- **History:** Lihat semua deteksi yang pernah dilakukan
- **Favorites:** Bookmark deteksi dengan tap bintang
- **Delete:** Swipe/tap hapus untuk menghapus entry

### Tips Hasil Optimal
✅ **DO:** Natural/white lighting | Kamera stabil | Motif 30-70% frame | Coba sudut berbeda
❌ **DON'T:** Terlalu dekat (<20cm) | Backlight ekstrem | Zoom digital berlebihan | Refleksi cahaya

### Troubleshooting

| Issue | Solution |
|-------|----------|
| No bounding box appears | Lower confidence threshold di `tflite_service.dart` |
| Detection too slow | Reduce model input size atau skip frames |
| Wrong detections | Retrain model dengan dataset lebih beragam |
| App crashes on open | Check camera permissions & model file exists |

---

## 🧪 Model Training & Integration

### Model Saat Ini (Production Ready ✅)
**YOLOv8 Nano - Roboflow Pre-trained**
- ✅ Dataset: 932 images (batik detection v2)
- ✅ Classes: Megamendung (Cirebon), Parang (Solo/Yogyakarta)
- ✅ Performance: ~50-150ms inference, 10-20 FPS real-time
- ✅ Accuracy: mAP@0.5 ~80-85% (bergantung lighting)
- ✅ Format: TFLite INT8 quantized (~6 MB)
- ✅ Status: Siap produksi & deployment

**Model Details:**
```yaml
Dataset: Roboflow batik-detection-f9hu4-vm8xn v2
Classes: 2 (megamendung, parang)
Training Images: 932
Annotation: YOLO v8 format
URL: https://universe.roboflow.com/haneki/batik-detection-f9hu4-vm8xn/dataset/2
```

### Mengganti dengan Model Lain
Aplikasi ini kompatibel dengan model TFLite format Object Detection:

**Compatible Model Types**:
- YOLOv8 Nano (recommended - lightweight)
- YOLOv8 Small/Medium (untuk akurasi lebih tinggi)
- SSD MobileNet
- EfficientDet Lite
- Custom object detection models

**Model Requirements**:
- Input: RGB image (typically 300x300 atau 640x640)
- Output: Bounding boxes, class IDs, confidence scores
- Format: `.tflite` (non-quantized atau int8 quantized)

### Training Model Sendiri (Custom Dataset)

#### Opsi 1: Ultralytics YOLO
```bash
# Install Ultralytics
pip install ultralytics
# Train YOLOv8 Nano
yolo detect train data=data.yaml model=yolov8n.pt epochs=100 imgsz=640
# Export to TFLite
yolo export model=runs/detect/train/weights/best.pt format=tflite int8=True
```

#### Opsi 2: TensorFlow Object Detection API
```bash
# Convert saved_model to TFLite
tflite_convert \
  --saved_model_dir=./saved_model \
  --output_file=model.tflite \
  --input_shapes=1,300,300,3 \
  --input_arrays=normalized_input_image_tensor
```

### Panduan Dataset
Untuk hasil optimal, gunakan dataset dengan karakteristik:

**Komposisi**:
- Minimum 500 images per class
- Sertakan 10-15% background/negative samples
- Distribusi kelas seimbang

**Variasi**:
- Berbagai kondisi pencahayaan (natural, indoor, outdoor)
- Sudut dan perspektif berbeda
- Beragam kondisi objek (datar, terlipat, pada pakaian, aksesoris)
- Skala bervariasi (close-up hingga jauh)

**Augmentasi** (disarankan):
- Auto-Orient
- Resize: Sesuaikan dengan input model
- Horizontal & Vertical Flip
- Rotasi: ±15°
- Brightness: ±25%
- Gaussian Blur: 0-1.5px
- Generation: 2-3x

### Integrasi Setelah Training
1. Tempatkan `model.tflite` di `lib/assets/models/`
2. Update `labels.txt` dengan nama kelas Anda
3. Sesuaikan konstanta di `tflite_service.dart` jika perlu:
   - `inputSize`: Sesuaikan dengan input training
   - `threshold`: Mulai dari 0.5, tuning sesuai hasil
4. Uji menyeluruh di perangkat target

Lihat panduan detail di [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md)

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

### Model Performance (YOLOv8 Nano + TFLite INT8)

| Metric | Target | Catatan |
|--------|--------|---------|
| Model Size | ~6 MB | Quantized INT8 |
| Inference | 50-150ms | Mid-range Android (SD 600+) |
| mAP@0.5 | 75-85% | Bergantung dataset training |
| mAP@0.5:0.95 | 45-55% | COCO standard |
| Real-time FPS | 10-20 FPS | Live detection frame rate |

### Platform Support

| Platform | Status | Catatan |
|----------|--------|---------|
| Android | ✅ | Min API 21 (Lollipop) |
| iOS | ✅ | Min iOS 11.0 |
| Web | ❌ | TFLite limitation |

### System Requirements

| Level | Spesifikasi |
|-------|-------|
| **Minimum** | Android 5.0 (API 21) / iOS 11.0 • 2GB RAM • Autofocus camera • 100MB storage |
| **Recommended** | Android 8.0+ / iOS 13.0+ • 4GB RAM • 12MP+ camera • 200MB storage |

### Optimization Tips
Jika lag: 1) Reduce inputSize (320x320) 2) Use INT8 model 3) Skip frames 4) Lower numResults 5) Test on device

---

## 🤝 Kontributor

Proyek Akhir mata kuliah **Computer Vision** - Universitas Pendidikan Indonesia (2025)

**Tim Pengembang:**
- **Zakiyah Hasanah** (2305274) - [kiyahh@upi.edu](mailto:kiyahh@upi.edu) | Project Lead, ML Engineer, Mobile Developer
- **Hafsah Hamidah** (2311474) - [hafsahhamidah25@upi.edu](mailto:hafsahhamidah25@upi.edu) | ML Engineer, Dataset Curator
- **Natasha Adinda Cantika** (2312120) - [natashadind@upi.edu](mailto:natashadind@upi.edu) | Mobile Developer, UI/UX Designer

**Dosen Pengampu:** Yaya Wihardi, S.Kom., M.Kom. | Fakultas MIPA, UPI

---

## 📄 Dokumentasi Tambahan

- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Catatan teknis implementasi
- [MODEL_READY.md](MODEL_READY.md) - Status integrasi model
- [QUICK_START.md](QUICK_START.md) - Panduan setup cepat
- [lib/assets/models/README.md](lib/assets/models/README.md) - Instruksi setup model

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
