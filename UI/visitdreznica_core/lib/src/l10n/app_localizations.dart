import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bs'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In bs, this message translates to:
  /// **'Visit Drežnica'**
  String get appName;

  /// No description provided for @save.
  ///
  /// In bs, this message translates to:
  /// **'Sačuvaj'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In bs, this message translates to:
  /// **'Odustani'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In bs, this message translates to:
  /// **'Obriši'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In bs, this message translates to:
  /// **'Uredi'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj'**
  String get add;

  /// No description provided for @close.
  ///
  /// In bs, this message translates to:
  /// **'Zatvori'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In bs, this message translates to:
  /// **'Potvrdi'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In bs, this message translates to:
  /// **'Nazad'**
  String get back;

  /// No description provided for @retry.
  ///
  /// In bs, this message translates to:
  /// **'Pokušaj ponovo'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In bs, this message translates to:
  /// **'Osvježi'**
  String get refresh;

  /// No description provided for @search.
  ///
  /// In bs, this message translates to:
  /// **'Pretraga'**
  String get search;

  /// No description provided for @yes.
  ///
  /// In bs, this message translates to:
  /// **'Da'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In bs, this message translates to:
  /// **'Ne'**
  String get no;

  /// No description provided for @all.
  ///
  /// In bs, this message translates to:
  /// **'Sve'**
  String get all;

  /// No description provided for @loadError.
  ///
  /// In bs, this message translates to:
  /// **'Podatke nije moguće učitati.'**
  String get loadError;

  /// No description provided for @noResults.
  ///
  /// In bs, this message translates to:
  /// **'Nema rezultata.'**
  String get noResults;

  /// No description provided for @appearance.
  ///
  /// In bs, this message translates to:
  /// **'Izgled'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In bs, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In bs, this message translates to:
  /// **'Svijetla'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In bs, this message translates to:
  /// **'Tamna'**
  String get themeDark;

  /// No description provided for @themeFollowSystem.
  ///
  /// In bs, this message translates to:
  /// **'Prati sistem'**
  String get themeFollowSystem;

  /// No description provided for @themeLightLong.
  ///
  /// In bs, this message translates to:
  /// **'Svijetla tema'**
  String get themeLightLong;

  /// No description provided for @themeDarkLong.
  ///
  /// In bs, this message translates to:
  /// **'Tamna tema'**
  String get themeDarkLong;

  /// No description provided for @language.
  ///
  /// In bs, this message translates to:
  /// **'Jezik'**
  String get language;

  /// No description provided for @languageBosnian.
  ///
  /// In bs, this message translates to:
  /// **'Bosanski'**
  String get languageBosnian;

  /// No description provided for @languageEnglish.
  ///
  /// In bs, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @logout.
  ///
  /// In bs, this message translates to:
  /// **'Odjava'**
  String get logout;

  /// No description provided for @logoutQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Da li se želite odjaviti?'**
  String get logoutQuestion;

  /// No description provided for @logoutAction.
  ///
  /// In bs, this message translates to:
  /// **'Odjavi se'**
  String get logoutAction;

  /// No description provided for @notifications.
  ///
  /// In bs, this message translates to:
  /// **'Obavijesti'**
  String get notifications;

  /// No description provided for @menu.
  ///
  /// In bs, this message translates to:
  /// **'Meni'**
  String get menu;

  /// No description provided for @errorTimeout.
  ///
  /// In bs, this message translates to:
  /// **'Server ne odgovara. Pokušajte ponovo.'**
  String get errorTimeout;

  /// No description provided for @errorNoConnection.
  ///
  /// In bs, this message translates to:
  /// **'Nije moguće povezati se sa serverom. Provjerite da li je API pokrenut.'**
  String get errorNoConnection;

  /// No description provided for @errorSessionExpired.
  ///
  /// In bs, this message translates to:
  /// **'Sesija je istekla. Prijavite se ponovo.'**
  String get errorSessionExpired;

  /// No description provided for @errorBadRequest.
  ///
  /// In bs, this message translates to:
  /// **'Podaci nisu ispravni.'**
  String get errorBadRequest;

  /// No description provided for @errorForbidden.
  ///
  /// In bs, this message translates to:
  /// **'Nemate pravo na ovu akciju.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In bs, this message translates to:
  /// **'Traženi podatak ne postoji.'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In bs, this message translates to:
  /// **'Podatak je u međuvremenu izmijenjen. Osvježite prikaz.'**
  String get errorConflict;

  /// No description provided for @errorFileTooLarge.
  ///
  /// In bs, this message translates to:
  /// **'Fajl je prevelik.'**
  String get errorFileTooLarge;

  /// No description provided for @errorServer.
  ///
  /// In bs, this message translates to:
  /// **'Došlo je do greške na serveru. Pokušajte ponovo.'**
  String get errorServer;

  /// No description provided for @errorAdminOnly.
  ///
  /// In bs, this message translates to:
  /// **'Ova aplikacija je namijenjena administratorima.'**
  String get errorAdminOnly;

  /// No description provided for @errorGuestOnly.
  ///
  /// In bs, this message translates to:
  /// **'Ova aplikacija je namijenjena gostima. Administratori koriste desktop aplikaciju.'**
  String get errorGuestOnly;

  /// No description provided for @justNow.
  ///
  /// In bs, this message translates to:
  /// **'upravo'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In bs, this message translates to:
  /// **'prije {count} min'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In bs, this message translates to:
  /// **'prije {count} h'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In bs, this message translates to:
  /// **'prije {count} d'**
  String daysAgo(int count);

  /// No description provided for @itemRoom.
  ///
  /// In bs, this message translates to:
  /// **'Soba'**
  String get itemRoom;

  /// No description provided for @itemEquipment.
  ///
  /// In bs, this message translates to:
  /// **'Oprema'**
  String get itemEquipment;

  /// No description provided for @itemActivity.
  ///
  /// In bs, this message translates to:
  /// **'Aktivnost'**
  String get itemActivity;

  /// No description provided for @itemPlace.
  ///
  /// In bs, this message translates to:
  /// **'Mjesto'**
  String get itemPlace;

  /// No description provided for @itemRooms.
  ///
  /// In bs, this message translates to:
  /// **'Sobe'**
  String get itemRooms;

  /// No description provided for @itemEquipmentPlural.
  ///
  /// In bs, this message translates to:
  /// **'Oprema'**
  String get itemEquipmentPlural;

  /// No description provided for @itemActivities.
  ///
  /// In bs, this message translates to:
  /// **'Aktivnosti'**
  String get itemActivities;

  /// No description provided for @itemPlaces.
  ///
  /// In bs, this message translates to:
  /// **'Mjesta'**
  String get itemPlaces;

  /// No description provided for @statusPending.
  ///
  /// In bs, this message translates to:
  /// **'Na čekanju'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In bs, this message translates to:
  /// **'Potvrđena'**
  String get statusConfirmed;

  /// No description provided for @statusCompleted.
  ///
  /// In bs, this message translates to:
  /// **'Završena'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In bs, this message translates to:
  /// **'Otkazana'**
  String get statusCancelled;

  /// No description provided for @statusRejected.
  ///
  /// In bs, this message translates to:
  /// **'Odbijena'**
  String get statusRejected;

  /// No description provided for @reservationRoom.
  ///
  /// In bs, this message translates to:
  /// **'Smještaj'**
  String get reservationRoom;

  /// No description provided for @reservationEquipment.
  ///
  /// In bs, this message translates to:
  /// **'Najam opreme'**
  String get reservationEquipment;

  /// No description provided for @reservationActivity.
  ///
  /// In bs, this message translates to:
  /// **'Aktivnost'**
  String get reservationActivity;

  /// No description provided for @guestsCount.
  ///
  /// In bs, this message translates to:
  /// **'Gostiju: {count}'**
  String guestsCount(int count);

  /// No description provided for @piecesCount.
  ///
  /// In bs, this message translates to:
  /// **'Komada: {count}'**
  String piecesCount(int count);

  /// No description provided for @participantsCount.
  ///
  /// In bs, this message translates to:
  /// **'Učesnika: {count}'**
  String participantsCount(int count);

  /// No description provided for @validationUsername.
  ///
  /// In bs, this message translates to:
  /// **'Korisničko ime mora imati 3–50 znakova: slova, brojevi, tačka ili donja crta.'**
  String get validationUsername;

  /// No description provided for @validationPassword.
  ///
  /// In bs, this message translates to:
  /// **'Najmanje 8 znakova, uključujući barem jedno slovo i jedan broj.'**
  String get validationPassword;

  /// No description provided for @validationEmailRequired.
  ///
  /// In bs, this message translates to:
  /// **'E-mail je obavezan.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailLength.
  ///
  /// In bs, this message translates to:
  /// **'E-mail može imati najviše 100 znakova.'**
  String get validationEmailLength;

  /// No description provided for @validationEmail.
  ///
  /// In bs, this message translates to:
  /// **'Unesite ispravnu e-mail adresu, npr. ime@domena.ba.'**
  String get validationEmail;

  /// No description provided for @validationPhone.
  ///
  /// In bs, this message translates to:
  /// **'Unesite ispravan broj, npr. 061 234 567 ili +387 61 234 567.'**
  String get validationPhone;

  /// No description provided for @navDashboard.
  ///
  /// In bs, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navReservations.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacije'**
  String get navReservations;

  /// No description provided for @navRooms.
  ///
  /// In bs, this message translates to:
  /// **'Sobe'**
  String get navRooms;

  /// No description provided for @navEquipment.
  ///
  /// In bs, this message translates to:
  /// **'Oprema'**
  String get navEquipment;

  /// No description provided for @navActivities.
  ///
  /// In bs, this message translates to:
  /// **'Aktivnosti'**
  String get navActivities;

  /// No description provided for @navPlaces.
  ///
  /// In bs, this message translates to:
  /// **'Mjesta'**
  String get navPlaces;

  /// No description provided for @navNews.
  ///
  /// In bs, this message translates to:
  /// **'Novosti'**
  String get navNews;

  /// No description provided for @navReviews.
  ///
  /// In bs, this message translates to:
  /// **'Recenzije'**
  String get navReviews;

  /// No description provided for @navUsers.
  ///
  /// In bs, this message translates to:
  /// **'Korisnici'**
  String get navUsers;

  /// No description provided for @navLookups.
  ///
  /// In bs, this message translates to:
  /// **'Šifarnici'**
  String get navLookups;

  /// No description provided for @navReports.
  ///
  /// In bs, this message translates to:
  /// **'Izvještaji'**
  String get navReports;

  /// No description provided for @navRecommendations.
  ///
  /// In bs, this message translates to:
  /// **'Preporuke (ML)'**
  String get navRecommendations;

  /// No description provided for @adminTitle.
  ///
  /// In bs, this message translates to:
  /// **'Visit Drežnica – Administracija'**
  String get adminTitle;

  /// No description provided for @administration.
  ///
  /// In bs, this message translates to:
  /// **'Administracija'**
  String get administration;

  /// No description provided for @roleAdministrator.
  ///
  /// In bs, this message translates to:
  /// **'Administrator'**
  String get roleAdministrator;

  /// No description provided for @goodMorning.
  ///
  /// In bs, this message translates to:
  /// **'Dobro jutro, {name}'**
  String goodMorning(String name);

  /// No description provided for @goodAfternoon.
  ///
  /// In bs, this message translates to:
  /// **'Dobar dan, {name}'**
  String goodAfternoon(String name);

  /// No description provided for @goodEvening.
  ///
  /// In bs, this message translates to:
  /// **'Dobro veče, {name}'**
  String goodEvening(String name);

  /// No description provided for @dashboardOverviewFor.
  ///
  /// In bs, this message translates to:
  /// **'Pregled poslovanja za {period}.'**
  String dashboardOverviewFor(String period);

  /// No description provided for @exportReport.
  ///
  /// In bs, this message translates to:
  /// **'Izvezi izvještaj'**
  String get exportReport;

  /// No description provided for @kpiRevenueThisMonth.
  ///
  /// In bs, this message translates to:
  /// **'Prihod ovog mjeseca'**
  String get kpiRevenueThisMonth;

  /// No description provided for @kpiReservationsThisMonth.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacije ovog mjeseca'**
  String get kpiReservationsThisMonth;

  /// No description provided for @kpiAwaitingConfirmation.
  ///
  /// In bs, this message translates to:
  /// **'Čeka potvrdu'**
  String get kpiAwaitingConfirmation;

  /// No description provided for @kpiAwaitingConfirmationHint.
  ///
  /// In bs, this message translates to:
  /// **'Plaćene, čekaju vašu potvrdu'**
  String get kpiAwaitingConfirmationHint;

  /// No description provided for @kpiArrivals7Days.
  ///
  /// In bs, this message translates to:
  /// **'Dolasci (7 dana)'**
  String get kpiArrivals7Days;

  /// No description provided for @kpiAverageRating.
  ///
  /// In bs, this message translates to:
  /// **'Prosječna ocjena'**
  String get kpiAverageRating;

  /// No description provided for @kpiFromReviews.
  ///
  /// In bs, this message translates to:
  /// **'Iz {count} recenzija'**
  String kpiFromReviews(int count);

  /// No description provided for @kpiGuests.
  ///
  /// In bs, this message translates to:
  /// **'Gosti'**
  String get kpiGuests;

  /// No description provided for @comparedToLastMonth.
  ///
  /// In bs, this message translates to:
  /// **'u odnosu na prošli mjesec'**
  String get comparedToLastMonth;

  /// No description provided for @netRevenueByMonth.
  ///
  /// In bs, this message translates to:
  /// **'Neto prihod po mjesecima'**
  String get netRevenueByMonth;

  /// No description provided for @reservationsByStatus.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacije po statusu'**
  String get reservationsByStatus;

  /// No description provided for @latestReservations.
  ///
  /// In bs, this message translates to:
  /// **'Posljednje rezervacije'**
  String get latestReservations;

  /// No description provided for @showAll.
  ///
  /// In bs, this message translates to:
  /// **'Prikaži sve →'**
  String get showAll;

  /// No description provided for @mostBookedYear.
  ///
  /// In bs, this message translates to:
  /// **'Najtraženije (godina)'**
  String get mostBookedYear;

  /// No description provided for @noReservationsYet.
  ///
  /// In bs, this message translates to:
  /// **'Još nema rezervacija.'**
  String get noReservationsYet;

  /// No description provided for @reservationsShort.
  ///
  /// In bs, this message translates to:
  /// **'{count} rez.'**
  String reservationsShort(int count);

  /// No description provided for @revenueRooms.
  ///
  /// In bs, this message translates to:
  /// **'Smještaj'**
  String get revenueRooms;

  /// No description provided for @revenueEquipment.
  ///
  /// In bs, this message translates to:
  /// **'Oprema'**
  String get revenueEquipment;

  /// No description provided for @revenueActivities.
  ///
  /// In bs, this message translates to:
  /// **'Aktivnosti'**
  String get revenueActivities;

  /// No description provided for @total.
  ///
  /// In bs, this message translates to:
  /// **'Ukupno'**
  String get total;

  /// No description provided for @tabHome.
  ///
  /// In bs, this message translates to:
  /// **'Početna'**
  String get tabHome;

  /// No description provided for @tabExplore.
  ///
  /// In bs, this message translates to:
  /// **'Istraži'**
  String get tabExplore;

  /// No description provided for @tabReservations.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacije'**
  String get tabReservations;

  /// No description provided for @tabFavorites.
  ///
  /// In bs, this message translates to:
  /// **'Favoriti'**
  String get tabFavorites;

  /// No description provided for @tabProfile.
  ///
  /// In bs, this message translates to:
  /// **'Profil'**
  String get tabProfile;

  /// No description provided for @titleMyReservations.
  ///
  /// In bs, this message translates to:
  /// **'Moje rezervacije'**
  String get titleMyReservations;

  /// No description provided for @passwordChangedLogin.
  ///
  /// In bs, this message translates to:
  /// **'Lozinka je promijenjena. Prijavite se novom lozinkom.'**
  String get passwordChangedLogin;

  /// No description provided for @welcomeTitle.
  ///
  /// In bs, this message translates to:
  /// **'Dobrodošli u Drežnicu'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In bs, this message translates to:
  /// **'Smještaj, kajaci, avanture i ljepote Neretve'**
  String get welcomeSubtitle;

  /// No description provided for @username.
  ///
  /// In bs, this message translates to:
  /// **'Korisničko ime'**
  String get username;

  /// No description provided for @password.
  ///
  /// In bs, this message translates to:
  /// **'Lozinka'**
  String get password;

  /// No description provided for @enterUsername.
  ///
  /// In bs, this message translates to:
  /// **'Unesite korisničko ime.'**
  String get enterUsername;

  /// No description provided for @enterPassword.
  ///
  /// In bs, this message translates to:
  /// **'Unesite lozinku.'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In bs, this message translates to:
  /// **'Zaboravili ste lozinku?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In bs, this message translates to:
  /// **'Prijava'**
  String get login;

  /// No description provided for @noAccountRegister.
  ///
  /// In bs, this message translates to:
  /// **'Nemate račun? Registrujte se'**
  String get noAccountRegister;

  /// No description provided for @showPassword.
  ///
  /// In bs, this message translates to:
  /// **'Prikaži lozinku'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In bs, this message translates to:
  /// **'Sakrij lozinku'**
  String get hidePassword;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bs':
      return L10nBs();
    case 'en':
      return L10nEn();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
