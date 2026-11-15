import 'package:flutter_test/flutter_test.dart';
import 'package:mini_catalog/models/product.dart';
import 'package:mini_catalog/models/cart_item.dart';

void main() {
  group('Product model tests', () {
    final json = <String, dynamic>{
      'id': 1,
      'name': 'Kulaklık',
      'description': 'Kablosuz kulaklık',
      'price': 1299,
      'category': 'Elektronik',
      'imageUrl': 'https://example.com/image.png',
    };

    test('fromJson doğru Product nesnesi üretmeli', () {
      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.name, 'Kulaklık');
      expect(product.price, 1299.0);
      expect(product.category, 'Elektronik');
    });

    test('toJson verileri korumalı', () {
      final product = Product.fromJson(json);
      final output = product.toJson();

      expect(output['id'], 1);
      expect(output['name'], 'Kulaklık');
      expect(output['price'], 1299.0);
    });

    test('Sepet ara toplamı doğru hesaplanmalı', () {
      final product = Product.fromJson(json);

      final cartItem = CartItem(product: product, quantity: 3);

      expect(cartItem.subtotal, 3897.0);
    });
  });
}
