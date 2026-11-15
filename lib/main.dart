import 'package:flutter/material.dart';

import 'data/products.dart';
import 'models/product.dart';
import 'pages/product_list_page.dart';
import 'services/cart_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MiniCatalogApp());
}

class MiniCatalogApp extends StatefulWidget {
  const MiniCatalogApp({super.key});

  @override
  State<MiniCatalogApp> createState() => _MiniCatalogAppState();
}

class _MiniCatalogAppState extends State<MiniCatalogApp> {
  late Future<AppData> _appData;

  @override
  void initState() {
    super.initState();
    _appData = _initializeApp();
  }

  Future<AppData> _initializeApp() async {
    final products = await loadProducts();

    final cart = CartStore();
    await cart.load(products);

    return AppData(products: products, cart: cart);
  }

  void _retry() {
    setState(() {
      _appData = _initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<AppData>(
        future: _appData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Mini Catalog')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded, size: 64),
                      const SizedBox(height: 16),
                      const Text(
                        'Ürünler yüklenemedi.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'İnternet bağlantınızı kontrol edin.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: _retry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: Text('Uygulama başlatılamadı.')),
            );
          }

          final appData = snapshot.data!;

          return ProductListPage(
            products: appData.products,
            cart: appData.cart,
          );
        },
      ),
    );
  }
}

class AppData {
  final List<Product> products;
  final CartStore cart;

  const AppData({required this.products, required this.cart});
}
