# KipCount - Smart Personal Finance Tracker 💸

KipCount adalah aplikasi manajemen keuangan pribadi berbasis mobile yang dibangun menggunakan **Flutter** dan **Firebase**. Aplikasi ini dirancang untuk membantu pengguna melacak pemasukan, pengeluaran, serta menganalisis kesehatan finansial mereka secara real-time dengan antarmuka yang modern dan intuitif.

## 🌟 Fitur Utama

- **Real-time Synchronized Dashboard:** Pantau Total Saldo, Pemasukan, Pengeluaran, dan Tabungan secara langsung dengan integrasi Firestore.
- **Manajemen Transaksi:** Tambah transaksi (Income/Expense) dengan mudah beserta kategori, nominal, kalender, dan catatan.
- **Financial Report & Analytics:**
  - Grafik *Bar Chart* untuk tren Pemasukan vs Pengeluaran.
  - Grafik *Donut Chart* untuk analisis persentase pengeluaran per kategori.
  - Indikator Kesehatan Finansial (*Excellent, Good, Meh, Needs Attention*).
  - Perbandingan periode (Mingguan, Bulanan, Tahunan).
- **Manajemen Dompet (Wallets):** Pantau berbagai sumber dana (Rekening, Tabungan, Kartu Kredit).
- **Sistem Autentikasi:** Login dan Register yang aman menggunakan Firebase Authentication.
- **Manajemen Profil:** Fitur edit nama (*Change Name*) yang otomatis ter-update di database dan UI.
- **Swipe Navigation:** Navigasi mulus antar menu menggunakan gesture geser (*PageView*).

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)
- **State Management & Routing:** GetX
- **Backend/Database:** Firebase Authentication & Cloud Firestore
- **Data Visualization:** `fl_chart`
- **Formatting:** `intl` (Format Rupiah - IDR dan format Tanggal)
- **Architecture:** Clean Architecture Pattern (App, Core, Features)

## 📁 Struktur Folder

```
lib/
├── app/                  # Konfigurasi Tema (Warna, Tipografi) & Routing GetX
├── core/                 # Reusable Widgets (Custom Button, TextField, Cards)
└── features/             # Modul Utama Aplikasi (Clean Architecture per Fitur)
    ├── auth/             # Login & Register Screen + Controller
    ├── dashboard/        # Halaman Utama (Overview)
    ├── navigation/       # Wrapper Bottom Navigation Bar
    ├── profile/          # Halaman Pengaturan & Akun
    ├── report/           # Halaman Laporan & Grafik Keuangan
    ├── transaction/      # Form Input Transaksi
    └── wallet/           # Halaman Daftar Rekening/Dompet
```

## 🚀 Cara Menjalankan Project

1. Pastikan Anda sudah menginstal **Flutter SDK** dan **Dart**.
2. Clone repository ini.
3. Buka terminal di folder project dan jalankan:
   ```bash
   flutter pub get
   ```
4. Pastikan Firebase project sudah terhubung dengan aplikasi Anda (file `google-services.json` untuk Android, `GoogleService-Info.plist` untuk iOS, dan setup *firebase_options.dart*).
5. Jalankan aplikasi di emulator atau physical device:
   ```bash
   flutter run
   ```

## ✒️ Author
- **Rakha Alghifary Iban Pameling**
