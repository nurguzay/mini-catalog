import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/cart_store.dart';
import '../utils/price_formatter.dart';
import '../widgets/product_image.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final CartStore cart;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Detayı')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ProductImage(
                        imageUrl: product.imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      product.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (product.tagline.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        product.tagline,
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    Text(
                      formatPrice(product.price, currency: product.currency),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Ürün Açıklaması',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(product.description),

                    if (product.specs.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      const Text(
                        'Teknik Özellikler',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...product.specs.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(child: Text('${entry.value}')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    cart.add(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} sepete eklendi!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Sepete Ekle'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
