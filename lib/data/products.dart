import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

const String productsApiUrl = 'https://wantapi.com/products.php';

Future<List<Product>> loadProducts() async {
  final response = await http
      .get(Uri.parse(productsApiUrl))
      .timeout(const Duration(seconds: 15));

  if (response.statusCode != 200) {
    throw Exception('Ürünler yüklenemedi. HTTP: ${response.statusCode}');
  }

  final decoded = jsonDecode(utf8.decode(response.bodyBytes));

  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Geçersiz API yanıtı.');
  }

  if (decoded['status'] != 'success') {
    throw const FormatException('API başarısız yanıt döndürdü.');
  }

  final data = decoded['data'];

  if (data is! List) {
    throw const FormatException('Ürün listesi bulunamadı.');
  }

  return data.map((item) {
    return Product.fromJson(Map<String, dynamic>.from(item as Map));
  }).toList();
}
