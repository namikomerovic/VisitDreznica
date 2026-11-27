import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

/// Sekcije administracije (stavke u sidebaru).
enum AdminSection {
  dashboard(Icons.dashboard_outlined, Icons.dashboard),
  reservations(Icons.event_note_outlined, Icons.event_note),
  rooms(Icons.bed_outlined, Icons.bed),
  equipment(Icons.kayaking_outlined, Icons.kayaking),
  activities(Icons.hiking_outlined, Icons.hiking),
  places(Icons.place_outlined, Icons.place),
  news(Icons.newspaper_outlined, Icons.newspaper),
  reviews(Icons.reviews_outlined, Icons.reviews),
  users(Icons.people_outline, Icons.people),
  lookups(Icons.list_alt_outlined, Icons.list_alt),
  reports(Icons.picture_as_pdf_outlined, Icons.picture_as_pdf),
  recommendations(Icons.auto_awesome_outlined, Icons.auto_awesome);

  const AdminSection(this.icon, this.selectedIcon);

  final IconData icon;
  final IconData selectedIcon;

  String get label => switch (this) {
        AdminSection.dashboard => tr.navDashboard,
        AdminSection.reservations => tr.navReservations,
        AdminSection.rooms => tr.navRooms,
        AdminSection.equipment => tr.navEquipment,
        AdminSection.activities => tr.navActivities,
        AdminSection.places => tr.navPlaces,
        AdminSection.news => tr.navNews,
        AdminSection.reviews => tr.navReviews,
        AdminSection.users => tr.navUsers,
        AdminSection.lookups => tr.navLookups,
        AdminSection.reports => tr.navReports,
        AdminSection.recommendations => tr.navRecommendations,
      };
}
