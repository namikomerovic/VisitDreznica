import '../l10n/locale_controller.dart';

enum ReservationStatus {
  pending(1),
  confirmed(2),
  completed(3),
  cancelled(4),
  rejected(5);

  const ReservationStatus(this.value);

  final int value;

  String get label => switch (this) {
        ReservationStatus.pending => tr.statusPending,
        ReservationStatus.confirmed => tr.statusConfirmed,
        ReservationStatus.completed => tr.statusCompleted,
        ReservationStatus.cancelled => tr.statusCancelled,
        ReservationStatus.rejected => tr.statusRejected,
      };

  static ReservationStatus fromValue(int value) => values.firstWhere((x) => x.value == value);
}
