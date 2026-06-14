import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:latihan_api/controllers/item_controller.dart';
import 'package:latihan_api/services/item_service.dart';

/// Entry point untuk Mini Inventory API.
/// Server berjalan di localhost:8080.
void main() async {
  // Inisialisasi service dan controller (Dependency Injection)
  final itemService = ItemService();
  final itemController = ItemController(itemService);

  // Tambahkan beberapa data contoh agar tidak kosong saat pertama kali
  _seedData(itemService);

  // Middleware: logging setiap request yang masuk
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(itemController.router.call);

  // Jalankan server
  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    8080,
  );

  print('╔══════════════════════════════════════════════════╗');
  print('║    🏪 Mini Inventory API - Server Started!      ║');
  print('║──────────────────────────────────────────────────║');
  print('║  Server berjalan di:                            ║');
  print('║  🌐 http://localhost:${server.port}                    ║');
  print('║──────────────────────────────────────────────────║');
  print('║  Endpoint yang tersedia:                        ║');
  print('║  📋 GET  /items           - Lihat semua barang  ║');
  print('║  ➕ POST /items           - Tambah barang baru  ║');
  print('║  📉 POST /items/:id/reduce - Kurangi stok      ║');
  print('║──────────────────────────────────────────────────║');
  print('║  Tekan Ctrl+C untuk menghentikan server         ║');
  print('╚══════════════════════════════════════════════════╝');
}

/// Menambahkan data contoh ke inventaris.
void _seedData(ItemService service) {
  service.addItem(nama: 'Laptop ASUS', stok: 10, harga: 8500000);
  service.addItem(nama: 'Mouse Logitech', stok: 25, harga: 350000);
  service.addItem(nama: 'Keyboard Mechanical', stok: 15, harga: 750000);
  service.addItem(nama: 'Monitor Samsung 24"', stok: 8, harga: 2500000);
  service.addItem(nama: 'Headset Gaming', stok: 20, harga: 450000);

  print('📦 Data contoh berhasil dimuat (${service.totalItems} barang)');
}

/// Middleware untuk mengizinkan CORS (Cross-Origin Resource Sharing).
Middleware _corsMiddleware() {
  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }
      return null;
    },
    responseHandler: (Response response) {
      return response.change(headers: _corsHeaders);
    },
  );
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};
