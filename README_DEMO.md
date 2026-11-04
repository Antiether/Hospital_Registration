# Sehatin - Demo Registrasi Rumah Sakit

Aplikasi Flutter mockup untuk sisi pasien. Login sengaja dilewati dan aplikasi langsung membuka dashboard.

## Menjalankan

```bash
flutter pub get
flutter run -d chrome
```

Untuk Android:

```bash
flutter run
```

## Fitur demo

- Dashboard pasien
- Daftar jadwal dokter dengan pencarian dan filter poliklinik
- Registrasi pasien lama dan pasien baru
- Pilihan pembayaran umum/BPJS (tanpa validasi eksternal)
- Pemilihan poli, dokter, tanggal, dan sesi
- Ringkasan pendaftaran dan e-ticket antrean simulasi

## Catatan

Seluruh data dokter, jadwal, identitas, nomor antrean, nomor rekam medis, dan QR code adalah data dummy. Tidak ada backend, database, autentikasi, integrasi BPJS, atau integrasi sistem rumah sakit. Aplikasi ini hanya untuk demonstrasi alur dan antarmuka.
