import 'package:intl/intl.dart';

String formatPrice(num price, {String currency = 'TRY'}) {
  switch (currency.toUpperCase()) {
    case 'USD':
      return NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
        decimalDigits: 0,
      ).format(price);

    case 'TRY':
      return NumberFormat.currency(
        locale: 'tr_TR',
        symbol: 'TL',
        decimalDigits: 2,
        customPattern: '#,##0.00 ¤',
      ).format(price);

    default:
      return '${NumberFormat.decimalPattern('en_US').format(price)} $currency';
  }
}
