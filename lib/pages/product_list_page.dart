import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/cart_store.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  final CartStore cart;
  final List<Product> products;

  const ProductListPage({
    super.key,
    required this.cart,
    required this.products,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String searchQuery = '';
  String selectedCategory = 'Tümü';

  List<String> get categories {
    final values =
        widget.products.map((product) => product.category).toSet().toList()
          ..sort();

    return ['Tümü', ...values];
  }

  List<Product> get filteredProducts {
    final query = searchQuery.trim().toLowerCase();

    return widget.products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'Tümü' || product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartPage(cart: widget.cart)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Catalog'),
        actions: [
          AnimatedBuilder(
            animation: widget.cart,
            builder: (context, _) {
              final count = widget.cart.totalQuantity;

              return IconButton(
                tooltip: 'Sepet ($count)',
                onPressed: openCart,
                icon: Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // Banner
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://wantapi.com/assets/banner.png',
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: Text('Banner yüklenemedi')),
                  );
                },
              ),
            ),
          ),

          // Arama
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          // Kategoriler
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];

                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${visibleProducts.length} ürün bulundu',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),

          // Ürünler
          Expanded(
            child: visibleProducts.isEmpty
                ? const Center(child: Text('Aramanıza uygun ürün bulunamadı.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: visibleProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      final product = visibleProducts[index];

                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                product: product,
                                cart: widget.cart,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
