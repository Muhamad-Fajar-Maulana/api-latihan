/// Model class untuk merepresentasikan barang dalam inventaris.
/// Menerapkan konsep OOP dengan enkapsulasi dan method.
class Item {
  final int id;
  final String nama;
  int stok;
  final double harga;
  final DateTime createdAt;

  Item({
    required this.id,
    required this.nama,
    required this.stok,
    required this.harga,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Mengurangi stok barang.
  /// Mengembalikan `true` jika berhasil, `false` jika stok tidak cukup.
  bool reduceStock(int jumlah) {
    if (jumlah <= 0) {
      throw ArgumentError('Jumlah pengurangan harus lebih dari 0');
    }
    if (stok < jumlah) {
      return false; // Stok tidak cukup
    }
    stok -= jumlah;
    return true;
  }

  /// Mengkonversi Item ke Map (untuk response JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'stok': stok,
      'harga': harga,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Membuat Item dari Map (dari request JSON).
  factory Item.fromJson(Map<String, dynamic> json, int id) {
    return Item(
      id: id,
      nama: json['nama'] as String,
      stok: json['stok'] as int,
      harga: (json['harga'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Item(id: $id, nama: $nama, stok: $stok, harga: $harga)';
  }
}
