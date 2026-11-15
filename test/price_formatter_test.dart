import 'package:flutter_test/flutter_test.dart';
import 'package:mini_catalog/utils/price_formatter.dart';

void main() {
  group('Price formatter', () {
    test('Türkçe para birimi formatı doğru olmalı', () {
      expect(formatPrice(1299), '1.299,00 TL');
    });

    test('Sepet toplamı doğru biçimlendirilmeli', () {
      expect(formatPrice(2598), '2.598,00 TL');
    });

    test('Ondalıklı fiyat doğru biçimlendirilmeli', () {
      expect(formatPrice(649.50), '649,50 TL');
    });
  });
}
