// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bosnian (`bs`).
class L10nBs extends L10n {
  L10nBs([String locale = 'bs']) : super(locale);

  @override
  String get appName => 'Visit Drežnica';

  @override
  String get save => 'Sačuvaj';

  @override
  String get cancel => 'Odustani';

  @override
  String get delete => 'Obriši';

  @override
  String get edit => 'Uredi';

  @override
  String get add => 'Dodaj';

  @override
  String get close => 'Zatvori';

  @override
  String get confirm => 'Potvrdi';

  @override
  String get back => 'Nazad';

  @override
  String get retry => 'Pokušaj ponovo';

  @override
  String get refresh => 'Osvježi';

  @override
  String get search => 'Pretraga';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Ne';

  @override
  String get all => 'Sve';

  @override
  String get loadError => 'Podatke nije moguće učitati.';

  @override
  String get noResults => 'Nema rezultata.';

  @override
  String get appearance => 'Izgled';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Svijetla';

  @override
  String get themeDark => 'Tamna';

  @override
  String get themeFollowSystem => 'Prati sistem';

  @override
  String get themeLightLong => 'Svijetla tema';

  @override
  String get themeDarkLong => 'Tamna tema';

  @override
  String get language => 'Jezik';

  @override
  String get languageBosnian => 'Bosanski';

  @override
  String get languageEnglish => 'English';

  @override
  String get logout => 'Odjava';

  @override
  String get logoutQuestion => 'Da li se želite odjaviti?';

  @override
  String get logoutAction => 'Odjavi se';

  @override
  String get notifications => 'Obavijesti';

  @override
  String get menu => 'Meni';

  @override
  String get errorTimeout => 'Server ne odgovara. Pokušajte ponovo.';

  @override
  String get errorNoConnection =>
      'Nije moguće povezati se sa serverom. Provjerite da li je API pokrenut.';

  @override
  String get errorSessionExpired => 'Sesija je istekla. Prijavite se ponovo.';

  @override
  String get errorBadRequest => 'Podaci nisu ispravni.';

  @override
  String get errorForbidden => 'Nemate pravo na ovu akciju.';

  @override
  String get errorNotFound => 'Traženi podatak ne postoji.';

  @override
  String get errorConflict =>
      'Podatak je u međuvremenu izmijenjen. Osvježite prikaz.';

  @override
  String get errorFileTooLarge => 'Fajl je prevelik.';

  @override
  String get errorServer => 'Došlo je do greške na serveru. Pokušajte ponovo.';

  @override
  String get errorAdminOnly =>
      'Ova aplikacija je namijenjena administratorima.';

  @override
  String get errorGuestOnly =>
      'Ova aplikacija je namijenjena gostima. Administratori koriste desktop aplikaciju.';

  @override
  String get justNow => 'upravo';

  @override
  String minutesAgo(int count) {
    return 'prije $count min';
  }

  @override
  String hoursAgo(int count) {
    return 'prije $count h';
  }

  @override
  String daysAgo(int count) {
    return 'prije $count d';
  }

  @override
  String get itemRoom => 'Soba';

  @override
  String get itemEquipment => 'Oprema';

  @override
  String get itemActivity => 'Aktivnost';

  @override
  String get itemPlace => 'Mjesto';

  @override
  String get itemRooms => 'Sobe';

  @override
  String get itemEquipmentPlural => 'Oprema';

  @override
  String get itemActivities => 'Aktivnosti';

  @override
  String get itemPlaces => 'Mjesta';

  @override
  String get statusPending => 'Na čekanju';

  @override
  String get statusConfirmed => 'Potvrđena';

  @override
  String get statusCompleted => 'Završena';

  @override
  String get statusCancelled => 'Otkazana';

  @override
  String get statusRejected => 'Odbijena';

  @override
  String get reservationRoom => 'Smještaj';

  @override
  String get reservationEquipment => 'Najam opreme';

  @override
  String get reservationActivity => 'Aktivnost';

  @override
  String guestsCount(int count) {
    return 'Gostiju: $count';
  }

  @override
  String piecesCount(int count) {
    return 'Komada: $count';
  }

  @override
  String participantsCount(int count) {
    return 'Učesnika: $count';
  }

  @override
  String get validationUsername =>
      'Korisničko ime mora imati 3–50 znakova: slova, brojevi, tačka ili donja crta.';

  @override
  String get validationPassword =>
      'Najmanje 8 znakova, uključujući barem jedno slovo i jedan broj.';

  @override
  String get validationEmailRequired => 'E-mail je obavezan.';

  @override
  String get validationEmailLength => 'E-mail može imati najviše 100 znakova.';

  @override
  String get validationEmail =>
      'Unesite ispravnu e-mail adresu, npr. ime@domena.ba.';

  @override
  String get validationPhone =>
      'Unesite ispravan broj, npr. 061 234 567 ili +387 61 234 567.';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navReservations => 'Rezervacije';

  @override
  String get navRooms => 'Sobe';

  @override
  String get navEquipment => 'Oprema';

  @override
  String get navActivities => 'Aktivnosti';

  @override
  String get navPlaces => 'Mjesta';

  @override
  String get navNews => 'Novosti';

  @override
  String get navReviews => 'Recenzije';

  @override
  String get navUsers => 'Korisnici';

  @override
  String get navLookups => 'Šifarnici';

  @override
  String get navReports => 'Izvještaji';

  @override
  String get navRecommendations => 'Preporuke (ML)';

  @override
  String get adminTitle => 'Visit Drežnica – Administracija';

  @override
  String get administration => 'Administracija';

  @override
  String get roleAdministrator => 'Administrator';

  @override
  String goodMorning(String name) {
    return 'Dobro jutro, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'Dobar dan, $name';
  }

  @override
  String goodEvening(String name) {
    return 'Dobro veče, $name';
  }

  @override
  String dashboardOverviewFor(String period) {
    return 'Pregled poslovanja za $period.';
  }

  @override
  String get exportReport => 'Izvezi izvještaj';

  @override
  String get kpiRevenueThisMonth => 'Prihod ovog mjeseca';

  @override
  String get kpiReservationsThisMonth => 'Rezervacije ovog mjeseca';

  @override
  String get kpiAwaitingConfirmation => 'Čeka potvrdu';

  @override
  String get kpiAwaitingConfirmationHint => 'Plaćene, čekaju vašu potvrdu';

  @override
  String get kpiArrivals7Days => 'Dolasci (7 dana)';

  @override
  String get kpiAverageRating => 'Prosječna ocjena';

  @override
  String kpiFromReviews(int count) {
    return 'Iz $count recenzija';
  }

  @override
  String get kpiGuests => 'Gosti';

  @override
  String get comparedToLastMonth => 'u odnosu na prošli mjesec';

  @override
  String get netRevenueByMonth => 'Neto prihod po mjesecima';

  @override
  String get reservationsByStatus => 'Rezervacije po statusu';

  @override
  String get latestReservations => 'Posljednje rezervacije';

  @override
  String get showAll => 'Prikaži sve →';

  @override
  String get mostBookedYear => 'Najtraženije (godina)';

  @override
  String get noReservationsYet => 'Još nema rezervacija.';

  @override
  String reservationsShort(int count) {
    return '$count rez.';
  }

  @override
  String get revenueRooms => 'Smještaj';

  @override
  String get revenueEquipment => 'Oprema';

  @override
  String get revenueActivities => 'Aktivnosti';

  @override
  String get total => 'Ukupno';

  @override
  String get tabHome => 'Početna';

  @override
  String get tabExplore => 'Istraži';

  @override
  String get tabReservations => 'Rezervacije';

  @override
  String get tabFavorites => 'Favoriti';

  @override
  String get tabProfile => 'Profil';

  @override
  String get titleMyReservations => 'Moje rezervacije';

  @override
  String get passwordChangedLogin =>
      'Lozinka je promijenjena. Prijavite se novom lozinkom.';

  @override
  String get welcomeTitle => 'Dobrodošli u Drežnicu';

  @override
  String get welcomeSubtitle => 'Smještaj, kajaci, avanture i ljepote Neretve';

  @override
  String get username => 'Korisničko ime';

  @override
  String get password => 'Lozinka';

  @override
  String get enterUsername => 'Unesite korisničko ime.';

  @override
  String get enterPassword => 'Unesite lozinku.';

  @override
  String get forgotPassword => 'Zaboravili ste lozinku?';

  @override
  String get login => 'Prijava';

  @override
  String get noAccountRegister => 'Nemate račun? Registrujte se';

  @override
  String get showPassword => 'Prikaži lozinku';

  @override
  String get hidePassword => 'Sakrij lozinku';
}
