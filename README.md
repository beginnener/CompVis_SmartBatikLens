# Smart Batik Lens 🎨

**Implementasi Object Detection untuk Identifikasi Motif Batik pada Produk Kreatif dan Fashion**

Smart Batik Lens adalah aplikasi mobile berbasis Computer Vision yang mampu mendeteksi dan mengidentifikasi motif batik secara real-time menggunakan teknologi YOLO (You Only Look Once). Aplikasi ini dapat mengenali motif batik pada berbagai media, termasuk pakaian yang terlipat, aksesoris, dan produk kreatif lainnya.

---

## 🎯 Latar Belakang

Batik Indonesia telah diakui oleh UNESCO sebagai Warisan Budaya Tak Benda sejak 2 Oktober 2009. Meskipun penggunaan batik meningkat pesat dalam kehidupan modern, pengetahuan mendalam mengenai motif spesifik seringkali minim, terutama di kalangan generasi muda. Fenomena "Tahu Batik tapi Tidak Tahu Namanya" menjadi ironi di era digital ini.

Metode konvensional seperti bertanya kepada ahli atau mencari di katalog dirasa tidak praktis. Solusi berbasis AI yang ada saat ini mayoritas menggunakan **Image Classification** yang memiliki keterbatasan: pengguna harus memotret motif secara datar dan close-up. Padahal dalam kondisi nyata, motif batik seringkali terdistorsi (terlipat, melengkung, atau sebagian tertutup).

**Smart Batik Lens** hadir dengan pendekatan **Object Detection** yang lebih canggih, mampu mendeteksi motif batik meskipun berada dalam kondisi yang kompleks dan tidak ideal.

---

## ✨ Fitur Utama

- 🔍 **Real-time Detection**: Deteksi motif batik secara langsung melalui kamera
- 🎯 **Robust Detection**: Mampu mengenali motif pada objek terdistorsi (lipatan pakaian, permukaan melengkung)
- 📱 **Mobile-First**: Dioptimasi untuk perangkat mobile dengan performa tinggi
- 🎨 **Multi-Object Detection**: Dapat mendeteksi multiple motif dalam satu frame
- 📚 **Informasi Edukatif**: Memberikan penjelasan tentang motif yang terdeteksi
- 💾 **History & Favorites**: Simpan dan tandai hasil deteksi favorit

### Motif yang Dapat Dideteksi

| Motif | Asal | Karakteristik |
|-------|------|---------------|
| **Megamendung** | Cirebon | Motif awan berarak dengan gradasi warna |
| **Parang** | Yogyakarta/Solo | Motif garis diagonal menyerupai huruf 'S' |

---

## 🛠️ Teknologi yang Digunakan

### Mobile Application
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: [Sesuaikan dengan yang digunakan]
- **ML Integration**: TensorFlow Lite / ONNX Runtime

### Computer Vision & Machine Learning
- **Model Architecture**: YOLOv8 Nano
- **Framework**: Ultralytics YOLO
- **Dataset Size**: 1.087+ citra (2.800+ setelah augmentasi)
- **Image Size**: 640x640 pixels
- **Platform Preprocessing**: Roboflow

### Dataset Composition
```
📊 Dataset Breakdown:
├── Megamendung: 554 images (51%)
├── Parang: 383 images (35%)
└── Background: 150 images (14%)

📦 Object Types:
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

### Download Model (Jika Diperlukan)

Jika model tidak disertakan dalam repository, download dari:
```bash
# Letakkan model di folder assets/models/
# Model file: yolov8n_batik.tflite atau format lainnya
```

### Run Application

```bash
# Android
flutter run

# iOS (Mac only)
flutter run

# Web
flutter run -d chrome
```

---

## 📁 Struktur Proyek

```
CompVis_SmartBatikLens/
├── lib/
│   ├── main.dart                 # Entry point aplikasi
│   ├── app/
│   │   └── smart_batik_app.dart  # Root widget
│   ├── features/                 # Feature modules
│   │   ├── splash/               # Splash screen
│   │   ├── lens/                 # Detection feature
│   │   ├── history/              # History feature
│   │   └── favorites/            # Favorites feature
│   ├── pages/                    # UI Pages
│   │   ├── lens.dart
│   │   └── lens/
│   └── shared/                   # Shared resources
│       └── constant/             # Constants & configs
├── assets/                       # Assets (images, models)
├── test/                         # Unit & widget tests
└── pubspec.yaml                  # Dependencies
```

---

## 🎓 Cara Penggunaan

1. **Buka Aplikasi**: Launch Smart Batik Lens di perangkat Anda
2. **Akses Kamera**: Tap tombol "Scan" untuk mengaktifkan kamera
3. **Arahkan ke Motif**: Arahkan kamera ke produk batik yang ingin diidentifikasi
4. **Lihat Hasil**: Aplikasi akan menampilkan bounding box dan nama motif secara real-time
5. **Simpan Hasil**: Tap untuk menyimpan ke history atau favorites

### Tips untuk Hasil Terbaik
- Pastikan pencahayaan cukup
- Dekatkan kamera ke motif (jarak ideal 30-50 cm)
- Motif terlihat jelas tanpa blur berlebihan
- Aplikasi dapat mendeteksi motif pada lipatan atau permukaan melengkung

---

## 🧪 Model Training (Opsional)

Jika ingin melakukan training ulang model:

### Dataset
Dataset tersedia di folder terpisah: `batik detection.v2-dataset-batik.yolov12/`

### Training Pipeline
```bash
# Install Ultralytics
pip install ultralytics

# Run training
yolo detect train data=data.yaml model=yolov8n.pt epochs=100 imgsz=640

# Export to TFLite
yolo export model=runs/detect/train/weights/best.pt format=tflite
```

### Data Augmentation
- Auto-Orient
- Resize: 640x640
- Horizontal & Vertical Flip
- Rotation: -15° to +15°
- Brightness: ±25%
- Generation: 3x

---

## 🎯 Tantangan dan Solusi

### 1. Variasi Objek dan Distorsi Geometris
**Tantangan**: Motif pada pakaian terlipat, permukaan melengkung  
**Solusi**: Dataset beragam dengan augmentasi geometris intensif

### 2. Kemiripan Visual dan Pola Repetitif
**Tantangan**: Pola lain yang mirip batik (false positive)  
**Solusi**: Penambahan kelas "background" dan training dengan negative samples

### 3. Keterbatasan Resource Perangkat
**Tantangan**: Inference real-time di mobile  
**Solusi**: Menggunakan YOLOv8 Nano + TFLite optimization

---

## 📊 Performa Model

| Metric | Value |
|--------|-------|
| **Model Size** | ~6 MB (TFLite) |
| **Inference Time** | ~50-100ms (on mobile) |
| **mAP@0.5** | [Akan diupdate setelah training] |
| **FPS** | ~10-20 FPS |

---

## 🤝 Kontributor

Proyek ini dikembangkan sebagai Proyek Akhir mata kuliah Computer Vision - Universitas Pendidikan Indonesia (2025)

**Tim Pengembang**:
- **Zakiyah Hasanah** (2305274) - kiyahh@upi.edu
- **Hafsah Hamidah** (2311474) - hafsahhamidah25@upi.edu  
- **Natasha Adinda Cantika** (2312120) - natashadind@upi.edu

**Dosen Pengampu**:  
Yaya Wihardi, S.Kom., M.Kom.

---

## 📝 Lisensi

Proyek ini dibuat untuk keperluan akademis. Untuk penggunaan komersial, silakan hubungi tim pengembang.

---

## 🙏 Acknowledgments

- UNESCO untuk pengakuan Batik sebagai Warisan Budaya Dunia
- [Ultralytics](https://github.com/ultralytics/ultralytics) untuk YOLO framework
- [Roboflow](https://roboflow.com/) untuk platform preprocessing dataset
- Komunitas batik Indonesia yang telah menginspirasi proyek ini

---

## 📞 Kontak & Support

Untuk pertanyaan, bug report, atau kontribusi:
- **GitHub Issues**: [Create Issue](https://github.com/beginnener/CompVis_SmartBatikLens/issues)
- **Email**: kiyahh@upi.edu

---

## 🔮 Roadmap

- [ ] Tambah support untuk motif batik lainnya (Kawung, Truntum, dll)
- [ ] Integrasi dengan database ensiklopedia batik
- [ ] Fitur AR untuk visualisasi motif
- [ ] Export hasil deteksi sebagai laporan PDF
- [ ] Multi-language support (English, Indonesia)
- [ ] Integration dengan marketplace batik untuk auto-tagging produk

---

<p align="center">
  <strong>Lestarikan Budaya dengan Teknologi 🇮🇩</strong><br>
  Made with ❤️ in Bandung, Indonesia
</p>
