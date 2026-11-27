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

  /// No description provided for @registration.
  ///
  /// In bs, this message translates to:
  /// **'Registracija'**
  String get registration;

  /// No description provided for @firstNameRequired.
  ///
  /// In bs, this message translates to:
  /// **'Ime *'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In bs, this message translates to:
  /// **'Prezime *'**
  String get lastNameRequired;

  /// No description provided for @emailRequiredLabel.
  ///
  /// In bs, this message translates to:
  /// **'E-mail *'**
  String get emailRequiredLabel;

  /// No description provided for @phone.
  ///
  /// In bs, this message translates to:
  /// **'Telefon'**
  String get phone;

  /// No description provided for @cityRequiredLabel.
  ///
  /// In bs, this message translates to:
  /// **'Grad *'**
  String get cityRequiredLabel;

  /// No description provided for @usernameRequiredLabel.
  ///
  /// In bs, this message translates to:
  /// **'Korisničko ime *'**
  String get usernameRequiredLabel;

  /// No description provided for @passwordRequiredLabel.
  ///
  /// In bs, this message translates to:
  /// **'Lozinka *'**
  String get passwordRequiredLabel;

  /// No description provided for @passwordConfirmRequiredLabel.
  ///
  /// In bs, this message translates to:
  /// **'Potvrda lozinke *'**
  String get passwordConfirmRequiredLabel;

  /// No description provided for @enterFirstName.
  ///
  /// In bs, this message translates to:
  /// **'Unesite ime (najviše 50 znakova).'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In bs, this message translates to:
  /// **'Unesite prezime (najviše 50 znakova).'**
  String get enterLastName;

  /// No description provided for @citiesLoadError.
  ///
  /// In bs, this message translates to:
  /// **'Gradove nije moguće učitati. Provjerite vezu.'**
  String get citiesLoadError;

  /// No description provided for @selectCity.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite grad.'**
  String get selectCity;

  /// No description provided for @passwordHint.
  ///
  /// In bs, this message translates to:
  /// **'Najmanje 8 znakova, slovo i broj.'**
  String get passwordHint;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In bs, this message translates to:
  /// **'Lozinke se ne podudaraju.'**
  String get passwordsDoNotMatch;

  /// No description provided for @createAccount.
  ///
  /// In bs, this message translates to:
  /// **'Kreiraj račun'**
  String get createAccount;

  /// No description provided for @resetCodeSent.
  ///
  /// In bs, this message translates to:
  /// **'Ako postoji račun s adresom {email}, poslali smo mu šestocifreni kod. Provjerite inbox i spam folder.'**
  String resetCodeSent(String email);

  /// No description provided for @forgottenPassword.
  ///
  /// In bs, this message translates to:
  /// **'Zaboravljena lozinka'**
  String get forgottenPassword;

  /// No description provided for @enterCodeAndNewPassword.
  ///
  /// In bs, this message translates to:
  /// **'Unesite kod iz e-maila i novu lozinku.'**
  String get enterCodeAndNewPassword;

  /// No description provided for @enterAccountEmail.
  ///
  /// In bs, this message translates to:
  /// **'Unesite e-mail adresu svog računa. Poslat ćemo vam kod za postavljanje nove lozinke.'**
  String get enterAccountEmail;

  /// No description provided for @email.
  ///
  /// In bs, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @sendCode.
  ///
  /// In bs, this message translates to:
  /// **'Pošalji kod'**
  String get sendCode;

  /// No description provided for @codeFromEmail.
  ///
  /// In bs, this message translates to:
  /// **'Kod iz e-maila'**
  String get codeFromEmail;

  /// No description provided for @codeSixDigits.
  ///
  /// In bs, this message translates to:
  /// **'Kod se sastoji od tačno 6 cifara.'**
  String get codeSixDigits;

  /// No description provided for @newPassword.
  ///
  /// In bs, this message translates to:
  /// **'Nova lozinka'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In bs, this message translates to:
  /// **'Potvrda nove lozinke'**
  String get confirmNewPassword;

  /// No description provided for @setNewPassword.
  ///
  /// In bs, this message translates to:
  /// **'Postavi novu lozinku'**
  String get setNewPassword;

  /// No description provided for @resendCode.
  ///
  /// In bs, this message translates to:
  /// **'Nije stigao kod? Pošalji ponovo'**
  String get resendCode;

  /// No description provided for @helloName.
  ///
  /// In bs, this message translates to:
  /// **'Zdravo, {name}'**
  String helloName(String name);

  /// No description provided for @homeTitle.
  ///
  /// In bs, this message translates to:
  /// **'Udahni Drežnicu.'**
  String get homeTitle;

  /// No description provided for @homeLocation.
  ///
  /// In bs, this message translates to:
  /// **'Drežnica, Bosna i Hercegovina'**
  String get homeLocation;

  /// No description provided for @news.
  ///
  /// In bs, this message translates to:
  /// **'Novosti'**
  String get news;

  /// No description provided for @noNews.
  ///
  /// In bs, this message translates to:
  /// **'Trenutno nema novosti.'**
  String get noNews;

  /// No description provided for @searchHint.
  ///
  /// In bs, this message translates to:
  /// **'Pretraži smještaj, opremu, aktivnosti…'**
  String get searchHint;

  /// No description provided for @heroTitle.
  ///
  /// In bs, this message translates to:
  /// **'Malo mjesto.\nVeliki doživljaji.'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In bs, this message translates to:
  /// **'Rijeka, kanjon i planina na dohvat ruke.'**
  String get heroSubtitle;

  /// No description provided for @exploreOffer.
  ///
  /// In bs, this message translates to:
  /// **'Istraži ponudu'**
  String get exploreOffer;

  /// No description provided for @recommendedForYou.
  ///
  /// In bs, this message translates to:
  /// **'Preporučeno za vas'**
  String get recommendedForYou;

  /// No description provided for @popularAmongGuests.
  ///
  /// In bs, this message translates to:
  /// **'Popularno među gostima'**
  String get popularAmongGuests;

  /// No description provided for @recommendationsHint.
  ///
  /// In bs, this message translates to:
  /// **'Ocijenite ili sačuvajte ono što vam se sviđa, pa ćemo vam preporučivati po vašem ukusu.'**
  String get recommendationsHint;

  /// No description provided for @newsItem.
  ///
  /// In bs, this message translates to:
  /// **'Novost'**
  String get newsItem;

  /// No description provided for @removeFromFavorites.
  ///
  /// In bs, this message translates to:
  /// **'Ukloni iz favorita'**
  String get removeFromFavorites;

  /// No description provided for @addToFavorites.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj u favorite'**
  String get addToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In bs, this message translates to:
  /// **'Uklonjeno iz favorita.'**
  String get removedFromFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In bs, this message translates to:
  /// **'Dodano u favorite.'**
  String get addedToFavorites;

  /// No description provided for @noRatingsYet.
  ///
  /// In bs, this message translates to:
  /// **'Još nema ocjena'**
  String get noRatingsYet;

  /// No description provided for @mapsAppError.
  ///
  /// In bs, this message translates to:
  /// **'Aplikaciju za mape nije moguće otvoriti.'**
  String get mapsAppError;

  /// No description provided for @reserve.
  ///
  /// In bs, this message translates to:
  /// **'Rezerviši'**
  String get reserve;

  /// No description provided for @view.
  ///
  /// In bs, this message translates to:
  /// **'Pogledaj'**
  String get view;

  /// No description provided for @upToPeople.
  ///
  /// In bs, this message translates to:
  /// **'{count, plural, one{do {count} osobe} few{do {count} osobe} other{do {count} osoba}}'**
  String upToPeople(int count);

  /// No description provided for @upToPeopleCapital.
  ///
  /// In bs, this message translates to:
  /// **'{count, plural, one{Do {count} osobe} few{Do {count} osobe} other{Do {count} osoba}}'**
  String upToPeopleCapital(int count);

  /// No description provided for @peoplePerPiece.
  ///
  /// In bs, this message translates to:
  /// **'{count, plural, one{{count} osoba po komadu} few{{count} osobe po komadu} other{{count} osoba po komadu}}'**
  String peoplePerPiece(int count);

  /// No description provided for @pricePerNight.
  ///
  /// In bs, this message translates to:
  /// **'{price} / noć'**
  String pricePerNight(String price);

  /// No description provided for @pricePerHourFrom.
  ///
  /// In bs, this message translates to:
  /// **'od {price} / sat'**
  String pricePerHourFrom(String price);

  /// No description provided for @pricePerPerson.
  ///
  /// In bs, this message translates to:
  /// **'{price} / osobi'**
  String pricePerPerson(String price);

  /// No description provided for @noSlotsNow.
  ///
  /// In bs, this message translates to:
  /// **'Trenutno nema termina'**
  String get noSlotsNow;

  /// No description provided for @nextSlot.
  ///
  /// In bs, this message translates to:
  /// **'Sljedeći termin: {date}'**
  String nextSlot(String date);

  /// No description provided for @kmFromAccommodation.
  ///
  /// In bs, this message translates to:
  /// **'{km} km od smještaja'**
  String kmFromAccommodation(String km);

  /// No description provided for @searchType.
  ///
  /// In bs, this message translates to:
  /// **'Pretraži: {type}'**
  String searchType(String type);

  /// No description provided for @showOnMap.
  ///
  /// In bs, this message translates to:
  /// **'Prikaži na mapi'**
  String get showOnMap;

  /// No description provided for @totalPieces.
  ///
  /// In bs, this message translates to:
  /// **'Ukupno komada: {count}'**
  String totalPieces(int count);

  /// No description provided for @firstHourPrice.
  ///
  /// In bs, this message translates to:
  /// **'Prvi sat: {price}'**
  String firstHourPrice(String price);

  /// No description provided for @additionalHourPrice.
  ///
  /// In bs, this message translates to:
  /// **'Svaki sljedeći sat: {price}'**
  String additionalHourPrice(String price);

  /// No description provided for @fullDayPrice.
  ///
  /// In bs, this message translates to:
  /// **'Cijeli dan: {price}'**
  String fullDayPrice(String price);

  /// No description provided for @maxParticipants.
  ///
  /// In bs, this message translates to:
  /// **'Najviše {count} učesnika'**
  String maxParticipants(int count);

  /// No description provided for @meetingPointLabel.
  ///
  /// In bs, this message translates to:
  /// **'Okupljanje: {place}'**
  String meetingPointLabel(String place);

  /// No description provided for @detailsLoadError.
  ///
  /// In bs, this message translates to:
  /// **'Detalje nije moguće učitati.'**
  String get detailsLoadError;

  /// No description provided for @description.
  ///
  /// In bs, this message translates to:
  /// **'Opis'**
  String get description;

  /// No description provided for @amenities.
  ///
  /// In bs, this message translates to:
  /// **'Sadržaji'**
  String get amenities;

  /// No description provided for @location.
  ///
  /// In bs, this message translates to:
  /// **'Lokacija'**
  String get location;

  /// No description provided for @upcomingSlots.
  ///
  /// In bs, this message translates to:
  /// **'Nadolazeći termini'**
  String get upcomingSlots;

  /// No description provided for @noScheduledSlots.
  ///
  /// In bs, this message translates to:
  /// **'Trenutno nema zakazanih termina.'**
  String get noScheduledSlots;

  /// No description provided for @guideName.
  ///
  /// In bs, this message translates to:
  /// **'Vodič: {name}'**
  String guideName(String name);

  /// No description provided for @slotFull.
  ///
  /// In bs, this message translates to:
  /// **'Popunjeno'**
  String get slotFull;

  /// No description provided for @spotsFree.
  ///
  /// In bs, this message translates to:
  /// **'Slobodno: {count}'**
  String spotsFree(int count);

  /// No description provided for @openMap.
  ///
  /// In bs, this message translates to:
  /// **'Otvori mapu'**
  String get openMap;

  /// No description provided for @directions.
  ///
  /// In bs, this message translates to:
  /// **'Upute'**
  String get directions;

  /// No description provided for @ratingLabels.
  ///
  /// In bs, this message translates to:
  /// **'Dodirnite zvjezdicu|Loše|Slabo|Dobro|Vrlo dobro|Odlično'**
  String get ratingLabels;

  /// No description provided for @selectRating.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite ocjenu od 1 do 5.'**
  String get selectRating;

  /// No description provided for @newReview.
  ///
  /// In bs, this message translates to:
  /// **'Nova recenzija'**
  String get newReview;

  /// No description provided for @editReview.
  ///
  /// In bs, this message translates to:
  /// **'Uredi recenziju'**
  String get editReview;

  /// No description provided for @commentOptional.
  ///
  /// In bs, this message translates to:
  /// **'Komentar (nije obavezan)'**
  String get commentOptional;

  /// No description provided for @thanksForReview.
  ///
  /// In bs, this message translates to:
  /// **'Hvala na recenziji!'**
  String get thanksForReview;

  /// No description provided for @reviewUpdated.
  ///
  /// In bs, this message translates to:
  /// **'Recenzija je izmijenjena.'**
  String get reviewUpdated;

  /// No description provided for @deleteReviewQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati recenziju?'**
  String get deleteReviewQuestion;

  /// No description provided for @cannotBeUndone.
  ///
  /// In bs, this message translates to:
  /// **'Ova radnja se ne može poništiti.'**
  String get cannotBeUndone;

  /// No description provided for @reviewDeleted.
  ///
  /// In bs, this message translates to:
  /// **'Recenzija je obrisana.'**
  String get reviewDeleted;

  /// No description provided for @reviews.
  ///
  /// In bs, this message translates to:
  /// **'Recenzije'**
  String get reviews;

  /// No description provided for @yourReview.
  ///
  /// In bs, this message translates to:
  /// **'Vaša recenzija'**
  String get yourReview;

  /// No description provided for @writeReview.
  ///
  /// In bs, this message translates to:
  /// **'Napiši recenziju'**
  String get writeReview;

  /// No description provided for @reviewAfterReservation.
  ///
  /// In bs, this message translates to:
  /// **'Recenziju možete ostaviti nakon završene rezervacije.'**
  String get reviewAfterReservation;

  /// No description provided for @loading.
  ///
  /// In bs, this message translates to:
  /// **'Učitavanje...'**
  String get loading;

  /// No description provided for @showMoreReviews.
  ///
  /// In bs, this message translates to:
  /// **'Prikaži još recenzija'**
  String get showMoreReviews;

  /// No description provided for @reviewsCount.
  ///
  /// In bs, this message translates to:
  /// **'{count, plural, one{{count} recenzija} few{{count} recenzije} other{{count} recenzija}}'**
  String reviewsCount(int count);

  /// No description provided for @noReviewsYet.
  ///
  /// In bs, this message translates to:
  /// **'Još nema recenzija.'**
  String get noReviewsYet;

  /// No description provided for @placesMap.
  ///
  /// In bs, this message translates to:
  /// **'Mapa mjesta'**
  String get placesMap;

  /// No description provided for @accommodation.
  ///
  /// In bs, this message translates to:
  /// **'Smještaj'**
  String get accommodation;

  /// No description provided for @details.
  ///
  /// In bs, this message translates to:
  /// **'Detalji'**
  String get details;

  /// No description provided for @activityBooking.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija aktivnosti'**
  String get activityBooking;

  /// No description provided for @perPersonAndDuration.
  ///
  /// In bs, this message translates to:
  /// **'{price} po osobi · {duration}'**
  String perPersonAndDuration(String price, String duration);

  /// No description provided for @selectSlot.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite termin'**
  String get selectSlot;

  /// No description provided for @numberOfPeople.
  ///
  /// In bs, this message translates to:
  /// **'Broj osoba'**
  String get numberOfPeople;

  /// No description provided for @meetingPointFull.
  ///
  /// In bs, this message translates to:
  /// **'Mjesto okupljanja: {place}'**
  String meetingPointFull(String place);

  /// No description provided for @peopleCount.
  ///
  /// In bs, this message translates to:
  /// **'{count, plural, one{{count} osoba} few{{count} osobe} other{{count} osoba}}'**
  String peopleCount(int count);

  /// No description provided for @nightsCount.
  ///
  /// In bs, this message translates to:
  /// **'{count, plural, one{{count} noć} few{{count} noći} other{{count} noći}}'**
  String nightsCount(int count);

  /// No description provided for @reservation.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija'**
  String get reservation;

  /// No description provided for @paymentSucceeded.
  ///
  /// In bs, this message translates to:
  /// **'Plaćanje je uspjelo!'**
  String get paymentSucceeded;

  /// No description provided for @reservationAwaitsPayment.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija čeka plaćanje'**
  String get reservationAwaitsPayment;

  /// No description provided for @paidAwaitingConfirmation.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija je plaćena i čeka potvrdu. Obavijest i e-mail stižu čim je potvrdimo.'**
  String get paidAwaitingConfirmation;

  /// No description provided for @savedNotPaid.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija je sačuvana, ali nije plaćena. Ako je ne platite u roku od 30 minuta, automatski se otkazuje.'**
  String get savedNotPaid;

  /// No description provided for @period.
  ///
  /// In bs, this message translates to:
  /// **'Termin'**
  String get period;

  /// No description provided for @amount.
  ///
  /// In bs, this message translates to:
  /// **'Iznos'**
  String get amount;

  /// No description provided for @payNow.
  ///
  /// In bs, this message translates to:
  /// **'Plati sada'**
  String get payNow;

  /// No description provided for @done.
  ///
  /// In bs, this message translates to:
  /// **'Gotovo'**
  String get done;

  /// No description provided for @noteOptional.
  ///
  /// In bs, this message translates to:
  /// **'Napomena (nije obavezna)'**
  String get noteOptional;

  /// No description provided for @reserveAndPay.
  ///
  /// In bs, this message translates to:
  /// **'Rezerviši i plati'**
  String get reserveAndPay;

  /// No description provided for @paymentConfirmation.
  ///
  /// In bs, this message translates to:
  /// **'Potvrda plaćanja'**
  String get paymentConfirmation;

  /// No description provided for @continueToCardPayment.
  ///
  /// In bs, this message translates to:
  /// **'Nastaviti na plaćanje karticom u iznosu od {amount}?'**
  String continueToCardPayment(String amount);

  /// No description provided for @pay.
  ///
  /// In bs, this message translates to:
  /// **'Plati'**
  String get pay;

  /// No description provided for @rentalDay.
  ///
  /// In bs, this message translates to:
  /// **'Dan najma'**
  String get rentalDay;

  /// No description provided for @equipmentRental.
  ///
  /// In bs, this message translates to:
  /// **'Najam opreme'**
  String get equipmentRental;

  /// No description provided for @equipmentPricing.
  ///
  /// In bs, this message translates to:
  /// **'Prvi sat {first}, svaki sljedeći {additional}, cijeli dan najviše {fullDay}'**
  String equipmentPricing(String first, String additional, String fullDay);

  /// No description provided for @pickupDayAndTime.
  ///
  /// In bs, this message translates to:
  /// **'Dan i vrijeme preuzimanja'**
  String get pickupDayAndTime;

  /// No description provided for @from.
  ///
  /// In bs, this message translates to:
  /// **'Od'**
  String get from;

  /// No description provided for @durationHours.
  ///
  /// In bs, this message translates to:
  /// **'Trajanje (sati)'**
  String get durationHours;

  /// No description provided for @numberOfPieces.
  ///
  /// In bs, this message translates to:
  /// **'Broj komada'**
  String get numberOfPieces;

  /// No description provided for @returnAt.
  ///
  /// In bs, this message translates to:
  /// **'Vraćanje: {date}'**
  String returnAt(String date);

  /// No description provided for @onlyPiecesAvailable.
  ///
  /// In bs, this message translates to:
  /// **'U tom periodu slobodno je samo {count} kom. Smanjite broj komada ili promijenite termin.'**
  String onlyPiecesAvailable(int count);

  /// No description provided for @pricePerPieceHours.
  ///
  /// In bs, this message translates to:
  /// **'Cijena po komadu ({hours} h)'**
  String pricePerPieceHours(int hours);

  /// No description provided for @selectArrivalDeparture.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite dolazak i odlazak'**
  String get selectArrivalDeparture;

  /// No description provided for @roomBooking.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija sobe'**
  String get roomBooking;

  /// No description provided for @roomPriceCapacity.
  ///
  /// In bs, this message translates to:
  /// **'{price} / noć · {capacity}'**
  String roomPriceCapacity(String price, String capacity);

  /// No description provided for @stayPeriod.
  ///
  /// In bs, this message translates to:
  /// **'Termin boravka'**
  String get stayPeriod;

  /// No description provided for @selectDates.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite datume'**
  String get selectDates;

  /// No description provided for @bookedDaysDisabled.
  ///
  /// In bs, this message translates to:
  /// **'Zauzeti dani su u kalendaru onemogućeni.'**
  String get bookedDaysDisabled;

  /// No description provided for @numberOfGuests.
  ///
  /// In bs, this message translates to:
  /// **'Broj gostiju'**
  String get numberOfGuests;

  /// No description provided for @touristTax.
  ///
  /// In bs, this message translates to:
  /// **'Boravišna taksa'**
  String get touristTax;

  /// No description provided for @paymentFailed.
  ///
  /// In bs, this message translates to:
  /// **'Plaćanje nije uspjelo. Pokušajte ponovo.'**
  String get paymentFailed;

  /// No description provided for @paymentSucceededShort.
  ///
  /// In bs, this message translates to:
  /// **'Plaćanje je uspjelo.'**
  String get paymentSucceededShort;

  /// No description provided for @cancelledRefund.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija je otkazana. Novac se vraća na vašu karticu.'**
  String get cancelledRefund;

  /// No description provided for @cancelledNoRefund.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija je otkazana.'**
  String get cancelledNoRefund;

  /// No description provided for @reservationDetails.
  ///
  /// In bs, this message translates to:
  /// **'Detalji rezervacije'**
  String get reservationDetails;

  /// No description provided for @payment.
  ///
  /// In bs, this message translates to:
  /// **'Plaćanje'**
  String get payment;

  /// No description provided for @paidByCard.
  ///
  /// In bs, this message translates to:
  /// **'Plaćeno karticom'**
  String get paidByCard;

  /// No description provided for @notPaid.
  ///
  /// In bs, this message translates to:
  /// **'Nije plaćeno'**
  String get notPaid;

  /// No description provided for @created.
  ///
  /// In bs, this message translates to:
  /// **'Kreirana'**
  String get created;

  /// No description provided for @note.
  ///
  /// In bs, this message translates to:
  /// **'Napomena'**
  String get note;

  /// No description provided for @payUntil.
  ///
  /// In bs, this message translates to:
  /// **'Rezervaciju platite do {time}, inače se automatski otkazuje.'**
  String payUntil(String time);

  /// No description provided for @payAmount.
  ///
  /// In bs, this message translates to:
  /// **'Plati {amount}'**
  String payAmount(String amount);

  /// No description provided for @yourRatingEdit.
  ///
  /// In bs, this message translates to:
  /// **'Vaša ocjena: {rating}★ · uredi'**
  String yourRatingEdit(int rating);

  /// No description provided for @rate.
  ///
  /// In bs, this message translates to:
  /// **'Ocijeni'**
  String get rate;

  /// No description provided for @viewItem.
  ///
  /// In bs, this message translates to:
  /// **'Pogledaj: {name}'**
  String viewItem(String name);

  /// No description provided for @cancelReservation.
  ///
  /// In bs, this message translates to:
  /// **'Otkaži rezervaciju'**
  String get cancelReservation;

  /// No description provided for @cancelPolicy.
  ///
  /// In bs, this message translates to:
  /// **'Potvrđenu rezervaciju možete otkazati najkasnije 24 sata prije početka. Uplaćeni iznos se vraća na karticu.'**
  String get cancelPolicy;

  /// No description provided for @history.
  ///
  /// In bs, this message translates to:
  /// **'Historija'**
  String get history;

  /// No description provided for @cancelReservationQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Otkazati rezervaciju?'**
  String get cancelReservationQuestion;

  /// No description provided for @refundToCard.
  ///
  /// In bs, this message translates to:
  /// **'Uplaćeni iznos biće vraćen na vašu karticu.'**
  String get refundToCard;

  /// No description provided for @noRefundNotPaid.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija još nije plaćena, pa nema povrata novca.'**
  String get noRefundNotPaid;

  /// No description provided for @reasonOptional.
  ///
  /// In bs, this message translates to:
  /// **'Razlog (nije obavezan)'**
  String get reasonOptional;

  /// No description provided for @filterActive.
  ///
  /// In bs, this message translates to:
  /// **'Aktivne'**
  String get filterActive;

  /// No description provided for @filterCompleted.
  ///
  /// In bs, this message translates to:
  /// **'Završene'**
  String get filterCompleted;

  /// No description provided for @filterCancelled.
  ///
  /// In bs, this message translates to:
  /// **'Otkazane'**
  String get filterCancelled;

  /// No description provided for @noActiveReservations.
  ///
  /// In bs, this message translates to:
  /// **'Nemate aktivnih rezervacija.'**
  String get noActiveReservations;

  /// No description provided for @noCompletedReservations.
  ///
  /// In bs, this message translates to:
  /// **'Još nemate završenih rezervacija.'**
  String get noCompletedReservations;

  /// No description provided for @noCancelledReservations.
  ///
  /// In bs, this message translates to:
  /// **'Nemate otkazanih rezervacija.'**
  String get noCancelledReservations;

  /// No description provided for @awaitingPayment.
  ///
  /// In bs, this message translates to:
  /// **'Čeka plaćanje'**
  String get awaitingPayment;

  /// No description provided for @noFavoritesYet.
  ///
  /// In bs, this message translates to:
  /// **'Još nemate favorita.'**
  String get noFavoritesYet;

  /// No description provided for @favoritesHint.
  ///
  /// In bs, this message translates to:
  /// **'Dodirnite ♥ na sobi, opremi, aktivnosti ili mjestu i sačuvajte ga ovdje.'**
  String get favoritesHint;

  /// No description provided for @savedOn.
  ///
  /// In bs, this message translates to:
  /// **'{type} · sačuvano {date}'**
  String savedOn(String type, String date);

  /// No description provided for @changePassword.
  ///
  /// In bs, this message translates to:
  /// **'Promijeni lozinku'**
  String get changePassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In bs, this message translates to:
  /// **'Trenutna lozinka *'**
  String get currentPasswordRequired;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In bs, this message translates to:
  /// **'Unesite trenutnu lozinku.'**
  String get enterCurrentPassword;

  /// No description provided for @newPasswordRequired.
  ///
  /// In bs, this message translates to:
  /// **'Nova lozinka *'**
  String get newPasswordRequired;

  /// No description provided for @newPasswordMustDiffer.
  ///
  /// In bs, this message translates to:
  /// **'Nova lozinka mora biti različita od trenutne.'**
  String get newPasswordMustDiffer;

  /// No description provided for @confirmNewPasswordRequired.
  ///
  /// In bs, this message translates to:
  /// **'Potvrda nove lozinke *'**
  String get confirmNewPasswordRequired;

  /// No description provided for @logoutOtherDevices.
  ///
  /// In bs, this message translates to:
  /// **'Nakon promjene bićete odjavljeni sa svih drugih uređaja.'**
  String get logoutOtherDevices;

  /// No description provided for @editProfile.
  ///
  /// In bs, this message translates to:
  /// **'Uredi profil'**
  String get editProfile;

  /// No description provided for @usernameCannotChange.
  ///
  /// In bs, this message translates to:
  /// **'Korisničko ime (@{username}) se ne može mijenjati.'**
  String usernameCannotChange(String username);

  /// No description provided for @profileSaved.
  ///
  /// In bs, this message translates to:
  /// **'Profil je sačuvan.'**
  String get profileSaved;

  /// No description provided for @passwordChanged.
  ///
  /// In bs, this message translates to:
  /// **'Lozinka je promijenjena.'**
  String get passwordChanged;

  /// No description provided for @pickFromGallery.
  ///
  /// In bs, this message translates to:
  /// **'Odaberi iz galerije'**
  String get pickFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In bs, this message translates to:
  /// **'Ukloni sliku'**
  String get removePhoto;

  /// No description provided for @errorTryAgain.
  ///
  /// In bs, this message translates to:
  /// **'{error} Pokušaj ponovo.'**
  String errorTryAgain(String error);

  /// No description provided for @phoneNotEntered.
  ///
  /// In bs, this message translates to:
  /// **'Telefon nije unesen'**
  String get phoneNotEntered;

  /// No description provided for @markAllRead.
  ///
  /// In bs, this message translates to:
  /// **'Označi sve kao pročitano'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In bs, this message translates to:
  /// **'Nemate obavijesti.'**
  String get noNotifications;

  /// No description provided for @showOlder.
  ///
  /// In bs, this message translates to:
  /// **'Prikaži starije'**
  String get showOlder;
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
