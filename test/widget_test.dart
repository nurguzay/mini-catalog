import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:mini_catalog/pages/cart_page.dart';
import 'package:mini_catalog/services/cart_store.dart';

void main() {
  setUp(() {
    // Test ortamında gerçek cihaz depolaması yerine bellekte çalışan sahte depolama kullanıldı

    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('Sepet boşken bilgilendirme mesajı görünmeli', (
    WidgetTester tester,
  ) async {
    final cart = CartStore();

    addTearDown(cart.dispose);

    await tester.pumpWidget(MaterialApp(home: CartPage(cart: cart)));

    expect(find.text('Sepetiniz henüz boş.'), findsOneWidget);

    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
  });
}
