class RoomQuote {
  RoomQuote({
    required this.nights,
    required this.pricePerNight,
    required this.accommodationPrice,
    required this.touristTax,
    required this.totalPrice,
  });

  final int nights;
  final double pricePerNight;
  final double accommodationPrice;
  final double touristTax;
  final double totalPrice;

  factory RoomQuote.fromJson(Map<String, dynamic> json) => RoomQuote(
        nights: json['nights'] as int,
        pricePerNight: (json['pricePerNight'] as num).toDouble(),
        accommodationPrice: (json['accommodationPrice'] as num).toDouble(),
        touristTax: (json['touristTax'] as num).toDouble(),
        totalPrice: (json['totalPrice'] as num).toDouble(),
      );
}

class EquipmentQuote {
  EquipmentQuote({
    required this.hours,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    required this.availableQuantity,
    required this.isAvailable,
  });

  final int hours;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final int availableQuantity;
  final bool isAvailable;

  factory EquipmentQuote.fromJson(Map<String, dynamic> json) => EquipmentQuote(
        hours: json['hours'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        quantity: json['quantity'] as int,
        totalPrice: (json['totalPrice'] as num).toDouble(),
        availableQuantity: json['availableQuantity'] as int,
        isAvailable: json['isAvailable'] as bool,
      );
}

class OccupiedPeriod {
  OccupiedPeriod({required this.from, required this.to});

  final DateTime from;
  final DateTime to;

  factory OccupiedPeriod.fromJson(Map<String, dynamic> json) => OccupiedPeriod(
        from: DateTime.parse(json['from'] as String),
        to: DateTime.parse(json['to'] as String),
      );
}

class PaymentIntentInfo {
  PaymentIntentInfo({
    required this.paymentId,
    required this.paymentIntentId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.publishableKey,
  });

  final int paymentId;
  final String paymentIntentId;
  final String clientSecret;
  final double amount;
  final String currency;
  final String publishableKey;

  factory PaymentIntentInfo.fromJson(Map<String, dynamic> json) => PaymentIntentInfo(
        paymentId: json['paymentId'] as int,
        paymentIntentId: json['paymentIntentId'] as String,
        clientSecret: json['clientSecret'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        publishableKey: json['publishableKey'] as String,
      );
}