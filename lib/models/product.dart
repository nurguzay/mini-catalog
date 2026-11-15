class Product {
  final int id;
  final String name;
  final String description;
  final String tagline;
  final double price;
  final String currency;
  final String category;
  final String imageUrl;
  final Map<String, dynamic> specs;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.tagline = '',
    this.currency = 'TRY',
    this.specs = const {},
  });

  static String determineCategory(String productName) {
    final name = productName.toLowerCase();

    if (name.contains('iphone') ||
        name.contains('phone') ||
        name.contains('smartphone')) {
      return 'Telefon';
    }

    if (name.contains('ipad') || name.contains('tablet')) {
      return 'Tablet';
    }

    if (name.contains('macbook') ||
        name.contains('laptop') ||
        name.contains('mac mini') ||
        name.contains('imac')) {
      return 'Bilgisayar';
    }

    if (name.contains('airpods') ||
        name.contains('headphone') ||
        name.contains('earbuds')) {
      return 'Kulaklık';
    }

    if (name.contains('watch')) {
      return 'Akıllı Saat';
    }

    if (name.contains('keyboard') || name.contains('mouse')) {
      return 'Aksesuar';
    }

    return 'Diğer';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    final String rawCurrency = (json['currency'] as String? ?? '')
        .toUpperCase();

    late final double parsedPrice;

    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice is String) {
      final cleaned = rawPrice
          .replaceAll(RegExp(r'[^0-9.,]'), '')
          .replaceAll(',', '');

      parsedPrice = double.parse(cleaned);
    } else {
      throw const FormatException('Geçersiz ürün fiyatı');
    }

    // API currency göndermiyorsa dolar sembolünü kontrol et.
    final currency = rawCurrency.isNotEmpty
        ? rawCurrency
        : rawPrice is String && rawPrice.contains('\$')
        ? 'USD'
        : 'TRY';

    return Product(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      price: parsedPrice,
      currency: currency,
      category:
          (json['category'] is String &&
              (json['category'] as String).trim().isNotEmpty)
          ? json['category'] as String
          : determineCategory(json['name'] as String),
      imageUrl: (json['image'] ?? json['imageUrl']) as String? ?? '',
      specs: Map<String, dynamic>.from(json['specs'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tagline': tagline,
      'price': price,
      'currency': currency,
      'category': category,
      'imageUrl': imageUrl,
      'specs': specs,
    };
  }
}
