import '../models/item.dart';

/// Service class untuk mengelola data inventaris barang.
/// Bertindak sebagai "repository" yang menyimpan data di memori.
/// Menerapkan konsep OOP: enkapsulasi data dan Single Responsibility.
class ItemService {
  // Data disimpan secara private (enkapsulasi)
  final List<Item> _items = [];
  int _nextId = 1;

  /// Mengambil semua barang dalam inventaris.
  List<Item> getAllItems() {
    return List.unmodifiable(_items);
  }

  /// Mencari barang berdasarkan ID.
  /// Mengembalikan `null` jika tidak ditemukan.
  Item? getItemById(int id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Menambahkan barang baru ke inventaris.
  /// Mengembalikan barang yang sudah ditambahkan (dengan ID).
  Item addItem({
    required String nama,
    required int stok,
    required double harga,
  }) {
    // Validasi input
    if (nama.trim().isEmpty) {
      throw ArgumentError('Nama barang tidak boleh kosong');
    }
    if (stok < 0) {
      throw ArgumentError('Stok tidak boleh negatif');
    }
    if (harga < 0) {
      throw ArgumentError('Harga tidak boleh negatif');
    }

    final item = Item(
      id: _nextId++,
      nama: nama.trim(),
      stok: stok,
      harga: harga,
    );

    _items.add(item);
    return item;
  }

  /// Mengurangi stok barang berdasarkan ID.
  /// Mengembalikan hasil dalam bentuk Map berisi status dan pesan.
  Map<String, dynamic> reduceStock(int id, int jumlah) {
    final item = getItemById(id);

    if (item == null) {
      return {
        'success': false,
        'message': 'Barang dengan ID $id tidak ditemukan',
      };
    }

    if (jumlah <= 0) {
      return {
        'success': false,
        'message': 'Jumlah pengurangan harus lebih dari 0',
      };
    }

    final berhasil = item.reduceStock(jumlah);

    if (!berhasil) {
      return {
        'success': false,
        'message':
            'Stok tidak cukup. Stok saat ini: ${item.stok}, diminta: $jumlah',
      };
    }

    return {
      'success': true,
      'message': 'Stok berhasil dikurangi sebanyak $jumlah',
      'data': item.toJson(),
    };
  }

  /// Mendapatkan jumlah total barang di inventaris.
  int get totalItems => _items.length;
}
