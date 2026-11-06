import 'reservation_status.dart';

double _toDouble(dynamic value) => (value as num).toDouble();

class DashboardResponse {
  DashboardResponse({
    required this.revenueThisMonth,
    required this.revenueLastMonth,
    required this.reservationsThisMonth,
    required this.awaitingConfirmation,
    required this.upcomingArrivals,
    required this.averageRating,
    required this.reviewCount,
    required this.guestCount,
    required this.revenueByMonth,
    required this.reservationsByStatus,
    required this.topItems,
  });

  final double revenueThisMonth;
  final double revenueLastMonth;
  final int reservationsThisMonth;
  final int awaitingConfirmation;
  final int upcomingArrivals;
  final double? averageRating;
  final int reviewCount;
  final int guestCount;
  final List<MonthlyRevenue> revenueByMonth;
  final List<StatusCount> reservationsByStatus;
  final List<TopItem> topItems;

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => DashboardResponse(
        revenueThisMonth: _toDouble(json['revenueThisMonth']),
        revenueLastMonth: _toDouble(json['revenueLastMonth']),
        reservationsThisMonth: json['reservationsThisMonth'] as int,
        awaitingConfirmation: json['awaitingConfirmation'] as int,
        upcomingArrivals: json['upcomingArrivals'] as int,
        averageRating: json['averageRating'] == null ? null : _toDouble(json['averageRating']),
        reviewCount: json['reviewCount'] as int,
        guestCount: json['guestCount'] as int,
        revenueByMonth: (json['revenueByMonth'] as List<dynamic>)
            .map((x) => MonthlyRevenue.fromJson(x as Map<String, dynamic>))
            .toList(),
        reservationsByStatus: (json['reservationsByStatus'] as List<dynamic>)
            .map((x) => StatusCount.fromJson(x as Map<String, dynamic>))
            .toList(),
        topItems: (json['topItems'] as List<dynamic>)
            .map((x) => TopItem.fromJson(x as Map<String, dynamic>))
            .toList(),
      );
}

class MonthlyRevenue {
  MonthlyRevenue({
    required this.year,
    required this.month,
    required this.rooms,
    required this.equipment,
    required this.activities,
    required this.total,
  });

  final int year;
  final int month;
  final double rooms;
  final double equipment;
  final double activities;
  final double total;

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) => MonthlyRevenue(
        year: json['year'] as int,
        month: json['month'] as int,
        rooms: _toDouble(json['rooms']),
        equipment: _toDouble(json['equipment']),
        activities: _toDouble(json['activities']),
        total: _toDouble(json['total']),
      );
}

class StatusCount {
  StatusCount({required this.status, required this.count});

  final ReservationStatus status;
  final int count;

  factory StatusCount.fromJson(Map<String, dynamic> json) => StatusCount(
        status: ReservationStatus.fromValue(json['status'] as int),
        count: json['count'] as int,
      );
}

class TopItem {
  TopItem({required this.name, required this.type, required this.reservationCount, required this.revenue});

  final String name;
  final String type;
  final int reservationCount;
  final double revenue;

  factory TopItem.fromJson(Map<String, dynamic> json) => TopItem(
        name: json['name'] as String,
        type: json['type'] as String,
        reservationCount: json['reservationCount'] as int,
        revenue: _toDouble(json['revenue']),
      );
}