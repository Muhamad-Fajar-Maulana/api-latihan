# 🏪 Mini Inventory API

API Inventaris Barang Sederhana menggunakan **Dart** dengan package `shelf` dan `shelf_router`.

## 📋 Deskripsi

Projek ini adalah REST API sederhana untuk mengelola inventaris barang. Dibuat dengan menerapkan konsep **Object-Oriented Programming (OOP)** menggunakan class untuk mengatur logika barang.

## 🏗️ Struktur Projek

```
latihan-api/
├── bin/
│   └── server.dart                 # Entry point server
├── lib/
│   ├── models/
│   │   └── item.dart               # Model class (OOP)
│   ├── services/
│   │   └── item_service.dart       # Business logic & data
│   └── controllers/
│       └── item_controller.dart    # HTTP request handler
├── pubspec.yaml                    # Dependencies
└── README.md
```

## 🚀 Cara Menjalankan

### 1. Install dependencies

```bash
dart pub get
```

### 2. Jalankan server

```bash
dart run bin/server.dart
```

Server akan berjalan di `http://localhost:8080`

## 📡 Endpoint API

### 1. GET `/items` — Melihat Semua Barang

**Request:**
```bash
curl http://localhost:8080/items
```

**Response:**
```json
{
  "success": true,
  "message": "Berhasil mengambil data barang",
  "total": 5,
  "data": [
    {
      "id": 1,
      "nama": "Laptop ASUS",
      "stok": 10,
      "harga": 8500000.0,
      "createdAt": "2026-06-14T22:00:00.000"
    }
  ]
}
```

---

### 2. POST `/items` — Menambah Barang Baru

**Request:**
```bash
curl -X POST http://localhost:8080/items \
  -H "Content-Type: application/json" \
  -d '{"nama": "Flashdisk 32GB", "stok": 50, "harga": 85000}'
```

**Response (201):**
```json
{
  "success": true,
  "message": "Barang berhasil ditambahkan",
  "data": {
    "id": 6,
    "nama": "Flashdisk 32GB",
    "stok": 50,
    "harga": 85000.0,
    "createdAt": "2026-06-14T22:01:00.000"
  }
}
```

---

### 3. POST `/items/:id/reduce` — Mengurangi Stok

**Request:**
```bash
curl -X POST http://localhost:8080/items/1/reduce \
  -H "Content-Type: application/json" \
  -d '{"jumlah": 3}'
```

**Response:**
```json
{
  "success": true,
  "message": "Stok berhasil dikurangi sebanyak 3",
  "data": {
    "id": 1,
    "nama": "Laptop ASUS",
    "stok": 7,
    "harga": 8500000.0,
    "createdAt": "2026-06-14T22:00:00.000"
  }
}
```

## 🎯 Konsep OOP yang Diterapkan

| Konsep | Penerapan |
|--------|-----------|
| **Class & Object** | `Item`, `ItemService`, `ItemController` |
| **Enkapsulasi** | Private fields (`_items`, `_nextId`) di `ItemService` |
| **Method** | `reduceStock()`, `toJson()`, `fromJson()` |
| **Factory Constructor** | `Item.fromJson()` untuk membuat objek dari JSON |
| **Single Responsibility** | Setiap class punya tanggung jawab masing-masing |
| **Dependency Injection** | `ItemController` menerima `ItemService` via constructor |

## 🧪 Testing dengan Postman / Thunder Client

1. Buka Postman atau Thunder Client di VS Code
2. Import endpoint di atas
3. Coba kirim request sesuai contoh

## 📝 Catatan

- Data disimpan di **memori** (akan hilang jika server di-restart)
- Sudah ada **5 data contoh** yang dimuat saat server pertama kali jalan
- Sudah mendukung **CORS** untuk akses dari browser/frontend
