enum ReservationStatus {
  pending(1, 'Na čekanju'),
  confirmed(2, 'Potvrđena'),
  completed(3, 'Završena'),
  cancelled(4, 'Otkazana'),
  rejected(5, 'Odbijena');

  const ReservationStatus(this.value, this.label);

  final int value;
  final String label;

  static ReservationStatus fromValue(int value) => values.firstWhere((x) => x.value == value);
}