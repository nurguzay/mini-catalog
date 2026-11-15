import 'package:flutter/material.dart';

import '../services/cart_store.dart';
import '../utils/price_formatter.dart';
import '../widgets/product_image.dart';

class CartPage extends StatelessWidget {
  final CartStore cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
        actions: [
          TextButton(onPressed: cart.clear, child: const Text('Temizle')),
        ],
      ),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          final items = cart.items;

          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 72,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('Sepetiniz henüz boş.'),
                ],
              ),
            );
          }

          // Para birimlerini ayrı ayrı topla.
          final totals = <String, double>{};

          for (final item in items) {
            final currency = item.product.currency;

            totals.update(
              currency,
              (value) => value + item.subtotal,
              ifAbsent: () => item.subtotal,
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Ürün görseli
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 90,
                                height: 90,
                                child: ProductImage(
                                  imageUrl: item.product.imageUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Ürün bilgileri
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    formatPrice(
                                      item.subtotal,
                                      currency: item.product.currency,
                                    ),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Miktar değiştirme ve silme
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        constraints: const BoxConstraints(
                                          minWidth: 36,
                                          minHeight: 36,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: () =>
                                            cart.decrease(item.product.id),
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      IconButton(
                                        constraints: const BoxConstraints(
                                          minWidth: 36,
                                          minHeight: 36,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: () => cart.add(item.product),
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                      ),

                                      const Spacer(),

                                      IconButton(
                                        constraints: const BoxConstraints(
                                          minWidth: 36,
                                          minHeight: 36,
                                        ),
                                        padding: EdgeInsets.zero,
                                        tooltip: 'Ürünü kaldır',
                                        onPressed: () =>
                                            cart.remove(item.product.id),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ...totals.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Toplam (${entry.key})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatPrice(entry.value, currency: entry.key),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Ödeme işlemi bu demoda bulunmuyor.',
                                ),
                              ),
                            );
                          },
                          child: const Text('Alışverişi Tamamla'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
