// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Visit Drežnica';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Try again';

  @override
  String get refresh => 'Refresh';

  @override
  String get search => 'Search';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get all => 'All';

  @override
  String get loadError => 'The data could not be loaded.';

  @override
  String get noResults => 'No results.';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeFollowSystem => 'Follow system';

  @override
  String get themeLightLong => 'Light theme';

  @override
  String get themeDarkLong => 'Dark theme';

  @override
  String get language => 'Language';

  @override
  String get languageBosnian => 'Bosanski';

  @override
  String get languageEnglish => 'English';

  @override
  String get logout => 'Log out';

  @override
  String get logoutQuestion => 'Do you want to log out?';

  @override
  String get logoutAction => 'Log out';

  @override
  String get notifications => 'Notifications';

  @override
  String get menu => 'Menu';

  @override
  String get errorTimeout => 'The server is not responding. Please try again.';

  @override
  String get errorNoConnection =>
      'Cannot connect to the server. Check that the API is running.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get errorBadRequest => 'The data is not valid.';

  @override
  String get errorForbidden => 'You are not allowed to do this.';

  @override
  String get errorNotFound => 'The requested data does not exist.';

  @override
  String get errorConflict =>
      'The data was changed in the meantime. Refresh the view.';

  @override
  String get errorFileTooLarge => 'The file is too large.';

  @override
  String get errorServer => 'A server error occurred. Please try again.';

  @override
  String get errorAdminOnly => 'This application is for administrators.';

  @override
  String get errorGuestOnly =>
      'This application is for guests. Administrators use the desktop application.';

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String daysAgo(int count) {
    return '$count d ago';
  }

  @override
  String get itemRoom => 'Room';

  @override
  String get itemEquipment => 'Equipment';

  @override
  String get itemActivity => 'Activity';

  @override
  String get itemPlace => 'Place';

  @override
  String get itemRooms => 'Rooms';

  @override
  String get itemEquipmentPlural => 'Equipment';

  @override
  String get itemActivities => 'Activities';

  @override
  String get itemPlaces => 'Places';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get reservationRoom => 'Accommodation';

  @override
  String get reservationEquipment => 'Equipment rental';

  @override
  String get reservationActivity => 'Activity';

  @override
  String guestsCount(int count) {
    return 'Guests: $count';
  }

  @override
  String piecesCount(int count) {
    return 'Pieces: $count';
  }

  @override
  String participantsCount(int count) {
    return 'Participants: $count';
  }

  @override
  String get validationUsername =>
      'Username must have 3–50 characters: letters, digits, dot or underscore.';

  @override
  String get validationPassword =>
      'At least 8 characters, including at least one letter and one digit.';

  @override
  String get validationEmailRequired => 'E-mail is required.';

  @override
  String get validationEmailLength => 'E-mail can have at most 100 characters.';

  @override
  String get validationEmail =>
      'Enter a valid e-mail address, e.g. name@domain.com.';

  @override
  String get validationPhone =>
      'Enter a valid number, e.g. 061 234 567 or +387 61 234 567.';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navReservations => 'Reservations';

  @override
  String get navRooms => 'Rooms';

  @override
  String get navEquipment => 'Equipment';

  @override
  String get navActivities => 'Activities';

  @override
  String get navPlaces => 'Places';

  @override
  String get navNews => 'News';

  @override
  String get navReviews => 'Reviews';

  @override
  String get navUsers => 'Users';

  @override
  String get navLookups => 'Code lists';

  @override
  String get navReports => 'Reports';

  @override
  String get navRecommendations => 'Recommendations (ML)';

  @override
  String get adminTitle => 'Visit Drežnica – Administration';

  @override
  String get administration => 'Administration';

  @override
  String get roleAdministrator => 'Administrator';

  @override
  String goodMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String goodEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String dashboardOverviewFor(String period) {
    return 'Business overview for $period.';
  }

  @override
  String get exportReport => 'Export report';

  @override
  String get kpiRevenueThisMonth => 'Revenue this month';

  @override
  String get kpiReservationsThisMonth => 'Reservations this month';

  @override
  String get kpiAwaitingConfirmation => 'Awaiting confirmation';

  @override
  String get kpiAwaitingConfirmationHint =>
      'Paid, waiting for your confirmation';

  @override
  String get kpiArrivals7Days => 'Arrivals (7 days)';

  @override
  String get kpiAverageRating => 'Average rating';

  @override
  String kpiFromReviews(int count) {
    return 'From $count reviews';
  }

  @override
  String get kpiGuests => 'Guests';

  @override
  String get comparedToLastMonth => 'compared to last month';

  @override
  String get netRevenueByMonth => 'Net revenue by month';

  @override
  String get reservationsByStatus => 'Reservations by status';

  @override
  String get latestReservations => 'Latest reservations';

  @override
  String get showAll => 'Show all →';

  @override
  String get mostBookedYear => 'Most booked (year)';

  @override
  String get noReservationsYet => 'No reservations yet.';

  @override
  String reservationsShort(int count) {
    return '$count res.';
  }

  @override
  String get revenueRooms => 'Accommodation';

  @override
  String get revenueEquipment => 'Equipment';

  @override
  String get revenueActivities => 'Activities';

  @override
  String get total => 'Total';

  @override
  String get tabHome => 'Home';

  @override
  String get tabExplore => 'Explore';

  @override
  String get tabReservations => 'Bookings';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get tabProfile => 'Profile';

  @override
  String get titleMyReservations => 'My bookings';

  @override
  String get passwordChangedLogin =>
      'Your password has been changed. Log in with the new password.';

  @override
  String get welcomeTitle => 'Welcome to Drežnica';

  @override
  String get welcomeSubtitle =>
      'Accommodation, kayaks, adventures and the beauty of the Neretva';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get enterUsername => 'Enter your username.';

  @override
  String get enterPassword => 'Enter your password.';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get login => 'Log in';

  @override
  String get noAccountRegister => 'No account? Sign up';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';
}
