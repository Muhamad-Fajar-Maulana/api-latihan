import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/item_service.dart';

/// Controller class untuk menangani HTTP request terkait barang.
/// Menerapkan konsep OOP: memisahkan logika handler dari routing.
class ItemController {
  final ItemService _service;

  ItemController(this._service);

  /// Handler untuk GET /items
  /// Mengembalikan daftar semua barang.
  Response getAllItems(Request request) {
    final items = _service.getAllItems();
    final responseBody = {
      'success': true,
      'message': 'Berhasil mengambil data barang',
      'total': items.length,
      'data': items.map((item) => item.toJson()).toList(),
    };

    return Response.ok(
      jsonEncode(responseBody),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// Handler untuk POST /items
  /// Menambahkan barang baru ke inventaris.
  Future<Response> addItem(Request request) async {
    try {
      final body = await request.readAsString();

      if (body.isEmpty) {
        return _errorResponse(400, 'Body request tidak boleh kosong');
      }

      final json = jsonDecode(body) as Map<String, dynamic>;

      // Validasi field yang diperlukan
      if (!json.containsKey('nama') ||
          !json.containsKey('stok') ||
          !json.containsKey('harga')) {
        return _errorResponse(
          400,
          'Field yang diperlukan: nama (String), stok (int), harga (num)',
        );
      }

      // Validasi tipe data
      if (json['nama'] is! String) {
        return _errorResponse(400, 'Field "nama" harus berupa String');
      }
      if (json['stok'] is! int) {
        return _errorResponse(400, 'Field "stok" harus berupa integer');
      }
      if (json['harga'] is! num) {
        return _errorResponse(400, 'Field "harga" harus berupa angka');
      }

      final item = _service.addItem(
        nama: json['nama'] as String,
        stok: json['stok'] as int,
        harga: (json['harga'] as num).toDouble(),
      );

      final responseBody = {
        'success': true,
        'message': 'Barang berhasil ditambahkan',
        'data': item.toJson(),
      };

      return Response(
        201,
        body: jsonEncode(responseBody),
        headers: {'Content-Type': 'application/json'},
      );
    } on ArgumentError catch (e) {
      return _errorResponse(400, e.message);
    } on FormatException {
      return _errorResponse(400, 'Format JSON tidak valid');
    } catch (e) {
      return _errorResponse(500, 'Terjadi kesalahan server: $e');
    }
  }

  /// Handler untuk POST /items/:id/reduce
  /// Mengurangi stok barang berdasarkan ID.
  Future<Response> reduceStock(Request request, String id) async {
    try {
      final itemId = int.tryParse(id);
      if (itemId == null) {
        return _errorResponse(400, 'ID harus berupa angka');
      }

      final body = await request.readAsString();

      if (body.isEmpty) {
        return _errorResponse(
          400,
          'Body request tidak boleh kosong. Kirim {"jumlah": <angka>}',
        );
      }

      final json = jsonDecode(body) as Map<String, dynamic>;

      if (!json.containsKey('jumlah')) {
        return _errorResponse(
          400,
          'Field "jumlah" diperlukan untuk mengurangi stok',
        );
      }

      if (json['jumlah'] is! int) {
        return _errorResponse(400, 'Field "jumlah" harus berupa integer');
      }

      final jumlah = json['jumlah'] as int;
      final result = _service.reduceStock(itemId, jumlah);

      if (result['success'] == true) {
        return Response.ok(
          jsonEncode(result),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        return _errorResponse(400, result['message']);
      }
    } on FormatException {
      return _errorResponse(400, 'Format JSON tidak valid');
    } catch (e) {
      return _errorResponse(500, 'Terjadi kesalahan server: $e');
    }
  }

  /// Helper method untuk membuat error response.
  Response _errorResponse(int statusCode, String message) {
    return Response(
      statusCode,
      body: jsonEncode({
        'success': false,
        'message': message,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// Membuat Router dengan semua route yang terdaftar.
  Router get router {
    final router = Router();

    router.get('/items', getAllItems);
    router.post('/items', addItem);
    router.post('/items/<id>/reduce', reduceStock);

    return router;
  }
}
