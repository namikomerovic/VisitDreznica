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
  /// **'Otkrijte Drežnicu.'**
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

  /// No description provided for @deleting.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje'**
  String get deleting;

  /// No description provided for @deleteThisRecord.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati ovaj zapis?'**
  String get deleteThisRecord;

  /// No description provided for @imageAdded.
  ///
  /// In bs, this message translates to:
  /// **'Slika je dodana.'**
  String get imageAdded;

  /// No description provided for @deletingImage.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje slike'**
  String get deletingImage;

  /// No description provided for @deleteCoverImageQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati naslovnu sliku? Sljedeća slika će automatski postati naslovna.'**
  String get deleteCoverImageQuestion;

  /// No description provided for @deleteImageQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati ovu sliku?'**
  String get deleteImageQuestion;

  /// No description provided for @imageDeleted.
  ///
  /// In bs, this message translates to:
  /// **'Slika je obrisana.'**
  String get imageDeleted;

  /// No description provided for @cover.
  ///
  /// In bs, this message translates to:
  /// **'Naslovna'**
  String get cover;

  /// No description provided for @imageOptions.
  ///
  /// In bs, this message translates to:
  /// **'Opcije slike'**
  String get imageOptions;

  /// No description provided for @coverChanged.
  ///
  /// In bs, this message translates to:
  /// **'Naslovna slika je promijenjena.'**
  String get coverChanged;

  /// No description provided for @setAsCover.
  ///
  /// In bs, this message translates to:
  /// **'Postavi kao naslovnu'**
  String get setAsCover;

  /// No description provided for @addImage.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj sliku'**
  String get addImage;

  /// No description provided for @imageMax5Mb.
  ///
  /// In bs, this message translates to:
  /// **'Slika može imati najviše 5 MB.'**
  String get imageMax5Mb;

  /// No description provided for @clickMapToSetLocation.
  ///
  /// In bs, this message translates to:
  /// **'Kliknite na kartu da postavite lokaciju'**
  String get clickMapToSetLocation;

  /// No description provided for @markAllReadShort.
  ///
  /// In bs, this message translates to:
  /// **'Označi sve pročitano'**
  String get markAllReadShort;

  /// No description provided for @onlyUnread.
  ///
  /// In bs, this message translates to:
  /// **'Samo nepročitane'**
  String get onlyUnread;

  /// No description provided for @noUnreadNotifications.
  ///
  /// In bs, this message translates to:
  /// **'Nema nepročitanih obavijesti.'**
  String get noUnreadNotifications;

  /// No description provided for @noNotificationsShort.
  ///
  /// In bs, this message translates to:
  /// **'Nema obavijesti.'**
  String get noNotificationsShort;

  /// No description provided for @loadMore.
  ///
  /// In bs, this message translates to:
  /// **'Učitaj još'**
  String get loadMore;

  /// No description provided for @noData.
  ///
  /// In bs, this message translates to:
  /// **'Nema podataka za prikaz.'**
  String get noData;

  /// No description provided for @shownRange.
  ///
  /// In bs, this message translates to:
  /// **'Prikazano {first}–{last} od {total}'**
  String shownRange(int first, int last, int total);

  /// No description provided for @rowsPerPage.
  ///
  /// In bs, this message translates to:
  /// **'Redova po stranici:'**
  String get rowsPerPage;

  /// No description provided for @previousPage.
  ///
  /// In bs, this message translates to:
  /// **'Prethodna stranica'**
  String get previousPage;

  /// No description provided for @pageOf.
  ///
  /// In bs, this message translates to:
  /// **'Stranica {page} od {pages}'**
  String pageOf(int page, int pages);

  /// No description provided for @nextPage.
  ///
  /// In bs, this message translates to:
  /// **'Sljedeća stranica'**
  String get nextPage;

  /// No description provided for @imageSaved.
  ///
  /// In bs, this message translates to:
  /// **'Slika je sačuvana.'**
  String get imageSaved;

  /// No description provided for @removingImage.
  ///
  /// In bs, this message translates to:
  /// **'Uklanjanje slike'**
  String get removingImage;

  /// No description provided for @removeImageQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Ukloniti sliku?'**
  String get removeImageQuestion;

  /// No description provided for @remove.
  ///
  /// In bs, this message translates to:
  /// **'Ukloni'**
  String get remove;

  /// No description provided for @imageRemoved.
  ///
  /// In bs, this message translates to:
  /// **'Slika je uklonjena.'**
  String get imageRemoved;

  /// No description provided for @changeImage.
  ///
  /// In bs, this message translates to:
  /// **'Promijeni sliku'**
  String get changeImage;

  /// No description provided for @chooseImage.
  ///
  /// In bs, this message translates to:
  /// **'Odaberi sliku'**
  String get chooseImage;

  /// No description provided for @removeImage.
  ///
  /// In bs, this message translates to:
  /// **'Ukloni sliku'**
  String get removeImage;

  /// No description provided for @imageFormatHint.
  ///
  /// In bs, this message translates to:
  /// **'JPG ili PNG, najviše 5 MB.'**
  String get imageFormatHint;

  /// No description provided for @cityName.
  ///
  /// In bs, this message translates to:
  /// **'Naziv grada'**
  String get cityName;

  /// No description provided for @addCity.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj grad'**
  String get addCity;

  /// No description provided for @city.
  ///
  /// In bs, this message translates to:
  /// **'Grad'**
  String get city;

  /// No description provided for @postalCode.
  ///
  /// In bs, this message translates to:
  /// **'Poštanski broj'**
  String get postalCode;

  /// No description provided for @country.
  ///
  /// In bs, this message translates to:
  /// **'Država'**
  String get country;

  /// No description provided for @newCity.
  ///
  /// In bs, this message translates to:
  /// **'Novi grad'**
  String get newCity;

  /// No description provided for @nameRequired.
  ///
  /// In bs, this message translates to:
  /// **'Naziv *'**
  String get nameRequired;

  /// No description provided for @nameLength2to100.
  ///
  /// In bs, this message translates to:
  /// **'Naziv mora imati između 2 i 100 znakova.'**
  String get nameLength2to100;

  /// No description provided for @postalCodeExample.
  ///
  /// In bs, this message translates to:
  /// **'npr. 88000'**
  String get postalCodeExample;

  /// No description provided for @postalCodeInvalid.
  ///
  /// In bs, this message translates to:
  /// **'Poštanski broj ima 4 do 6 cifara.'**
  String get postalCodeInvalid;

  /// No description provided for @countryRequired.
  ///
  /// In bs, this message translates to:
  /// **'Država *'**
  String get countryRequired;

  /// No description provided for @selectCountry.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite državu.'**
  String get selectCountry;

  /// No description provided for @deleteCityQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati grad {name}?\n\nAko ga koriste korisnici, brisanje nije moguće.'**
  String deleteCityQuestion(String name);

  /// No description provided for @firstOrLastName.
  ///
  /// In bs, this message translates to:
  /// **'Ime ili prezime'**
  String get firstOrLastName;

  /// No description provided for @addGuide.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj vodiča'**
  String get addGuide;

  /// No description provided for @fullName.
  ///
  /// In bs, this message translates to:
  /// **'Ime i prezime'**
  String get fullName;

  /// No description provided for @newGuide.
  ///
  /// In bs, this message translates to:
  /// **'Novi vodič'**
  String get newGuide;

  /// No description provided for @guide.
  ///
  /// In bs, this message translates to:
  /// **'Vodič'**
  String get guide;

  /// No description provided for @firstNameRequiredShort.
  ///
  /// In bs, this message translates to:
  /// **'Ime *'**
  String get firstNameRequiredShort;

  /// No description provided for @lastNameRequiredShort.
  ///
  /// In bs, this message translates to:
  /// **'Prezime *'**
  String get lastNameRequiredShort;

  /// No description provided for @phoneExample.
  ///
  /// In bs, this message translates to:
  /// **'npr. 061 234 567'**
  String get phoneExample;

  /// No description provided for @deleteGuideQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati vodiča {name}?\n\nAko vodi termine aktivnosti, brisanje nije moguće.'**
  String deleteGuideQuestion(String name);

  /// No description provided for @searchByName.
  ///
  /// In bs, this message translates to:
  /// **'Pretraga po nazivu'**
  String get searchByName;

  /// No description provided for @name.
  ///
  /// In bs, this message translates to:
  /// **'Naziv'**
  String get name;

  /// No description provided for @newLookup.
  ///
  /// In bs, this message translates to:
  /// **'Novo: {name}'**
  String newLookup(String name);

  /// No description provided for @deleteLookupQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati \"{name}\"?\n\nAko se koristi ({usage}), brisanje nije moguće.'**
  String deleteLookupQuestion(String name, String usage);

  /// No description provided for @tabRoomTypes.
  ///
  /// In bs, this message translates to:
  /// **'Tipovi soba'**
  String get tabRoomTypes;

  /// No description provided for @tabRoomAmenities.
  ///
  /// In bs, this message translates to:
  /// **'Sadržaji soba'**
  String get tabRoomAmenities;

  /// No description provided for @tabEquipmentTypes.
  ///
  /// In bs, this message translates to:
  /// **'Tipovi opreme'**
  String get tabEquipmentTypes;

  /// No description provided for @tabActivityCategories.
  ///
  /// In bs, this message translates to:
  /// **'Kategorije aktivnosti'**
  String get tabActivityCategories;

  /// No description provided for @tabPlaceTypes.
  ///
  /// In bs, this message translates to:
  /// **'Tipovi mjesta'**
  String get tabPlaceTypes;

  /// No description provided for @tabGuides.
  ///
  /// In bs, this message translates to:
  /// **'Vodiči'**
  String get tabGuides;

  /// No description provided for @tabCountries.
  ///
  /// In bs, this message translates to:
  /// **'Države'**
  String get tabCountries;

  /// No description provided for @tabCities.
  ///
  /// In bs, this message translates to:
  /// **'Gradovi'**
  String get tabCities;

  /// No description provided for @roomType.
  ///
  /// In bs, this message translates to:
  /// **'Tip sobe'**
  String get roomType;

  /// No description provided for @roomTypeUsage.
  ///
  /// In bs, this message translates to:
  /// **'sobe ovog tipa'**
  String get roomTypeUsage;

  /// No description provided for @roomAmenity.
  ///
  /// In bs, this message translates to:
  /// **'Sadržaj sobe'**
  String get roomAmenity;

  /// No description provided for @roomAmenityUsage.
  ///
  /// In bs, this message translates to:
  /// **'sobe s ovim sadržajem'**
  String get roomAmenityUsage;

  /// No description provided for @equipmentType.
  ///
  /// In bs, this message translates to:
  /// **'Tip opreme'**
  String get equipmentType;

  /// No description provided for @equipmentTypeUsage.
  ///
  /// In bs, this message translates to:
  /// **'oprema ovog tipa'**
  String get equipmentTypeUsage;

  /// No description provided for @activityCategory.
  ///
  /// In bs, this message translates to:
  /// **'Kategorija aktivnosti'**
  String get activityCategory;

  /// No description provided for @activityCategoryUsage.
  ///
  /// In bs, this message translates to:
  /// **'aktivnosti u ovoj kategoriji'**
  String get activityCategoryUsage;

  /// No description provided for @placeType.
  ///
  /// In bs, this message translates to:
  /// **'Tip mjesta'**
  String get placeType;

  /// No description provided for @placeTypeUsage.
  ///
  /// In bs, this message translates to:
  /// **'mjesta ovog tipa'**
  String get placeTypeUsage;

  /// No description provided for @countryUsage.
  ///
  /// In bs, this message translates to:
  /// **'gradovi u ovoj državi'**
  String get countryUsage;

  /// No description provided for @newsPublished.
  ///
  /// In bs, this message translates to:
  /// **'Novost je objavljena. Sada možete dodati sliku.'**
  String get newsPublished;

  /// No description provided for @newsScheduled.
  ///
  /// In bs, this message translates to:
  /// **'Novost je zakazana za {date}. Sada možete dodati sliku.'**
  String newsScheduled(String date);

  /// No description provided for @changesSaved.
  ///
  /// In bs, this message translates to:
  /// **'Izmjene su sačuvane.'**
  String get changesSaved;

  /// No description provided for @deletingNews.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje novosti'**
  String get deletingNews;

  /// No description provided for @deleteNewsQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati \"{title}\"? Ovo se ne može poništiti.'**
  String deleteNewsQuestion(String title);

  /// No description provided for @newNews.
  ///
  /// In bs, this message translates to:
  /// **'Nova novost'**
  String get newNews;

  /// No description provided for @titleRequired.
  ///
  /// In bs, this message translates to:
  /// **'Naslov *'**
  String get titleRequired;

  /// No description provided for @titleLength.
  ///
  /// In bs, this message translates to:
  /// **'Naslov mora imati između 3 i 150 znakova.'**
  String get titleLength;

  /// No description provided for @textRequired.
  ///
  /// In bs, this message translates to:
  /// **'Tekst *'**
  String get textRequired;

  /// No description provided for @textLength.
  ///
  /// In bs, this message translates to:
  /// **'Tekst mora imati između 10 i 4000 znakova.'**
  String get textLength;

  /// No description provided for @publishedAtLabel.
  ///
  /// In bs, this message translates to:
  /// **'Objava: {date}'**
  String publishedAtLabel(String date);

  /// No description provided for @now.
  ///
  /// In bs, this message translates to:
  /// **'Odmah'**
  String get now;

  /// No description provided for @scheduledHint.
  ///
  /// In bs, this message translates to:
  /// **'Zakazano: gosti će novost vidjeti tek od odabranog trenutka.'**
  String get scheduledHint;

  /// No description provided for @immediateHint.
  ///
  /// In bs, this message translates to:
  /// **'Gosti vide novost odmah nakon čuvanja.'**
  String get immediateHint;

  /// No description provided for @authorLabel.
  ///
  /// In bs, this message translates to:
  /// **'Autor: {name}'**
  String authorLabel(String name);

  /// No description provided for @saveChanges.
  ///
  /// In bs, this message translates to:
  /// **'Sačuvaj izmjene'**
  String get saveChanges;

  /// No description provided for @schedule.
  ///
  /// In bs, this message translates to:
  /// **'Zakaži'**
  String get schedule;

  /// No description provided for @publish.
  ///
  /// In bs, this message translates to:
  /// **'Objavi'**
  String get publish;

  /// No description provided for @image.
  ///
  /// In bs, this message translates to:
  /// **'Slika'**
  String get image;

  /// No description provided for @imageAfterSaveNews.
  ///
  /// In bs, this message translates to:
  /// **'Sliku možete dodati nakon što sačuvate novost.'**
  String get imageAfterSaveNews;

  /// No description provided for @title.
  ///
  /// In bs, this message translates to:
  /// **'Naslov'**
  String get title;

  /// No description provided for @author.
  ///
  /// In bs, this message translates to:
  /// **'Autor'**
  String get author;

  /// No description provided for @publishDate.
  ///
  /// In bs, this message translates to:
  /// **'Datum objave'**
  String get publishDate;

  /// No description provided for @status.
  ///
  /// In bs, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @published.
  ///
  /// In bs, this message translates to:
  /// **'Objavljeno'**
  String get published;

  /// No description provided for @scheduled.
  ///
  /// In bs, this message translates to:
  /// **'Zakazano'**
  String get scheduled;

  /// No description provided for @noComment.
  ///
  /// In bs, this message translates to:
  /// **'Bez komentara.'**
  String get noComment;

  /// No description provided for @deleteReview.
  ///
  /// In bs, this message translates to:
  /// **'Obriši recenziju'**
  String get deleteReview;

  /// No description provided for @deletingReview.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje recenzije'**
  String get deletingReview;

  /// No description provided for @deleteGuestReviewQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati recenziju gosta {name}? Recenzija nestaje i iz prosječne ocjene.'**
  String deleteGuestReviewQuestion(String name);

  /// No description provided for @type.
  ///
  /// In bs, this message translates to:
  /// **'Vrsta'**
  String get type;

  /// No description provided for @ratingRange.
  ///
  /// In bs, this message translates to:
  /// **'Ocjena: {from}–{to} ★'**
  String ratingRange(int from, int to);

  /// No description provided for @onlyBad.
  ///
  /// In bs, this message translates to:
  /// **'Samo loše (1–2★)'**
  String get onlyBad;

  /// No description provided for @noReviewsForFilters.
  ///
  /// In bs, this message translates to:
  /// **'Nema recenzija za odabrane filtere.'**
  String get noReviewsForFilters;

  /// No description provided for @rating.
  ///
  /// In bs, this message translates to:
  /// **'Ocjena'**
  String get rating;

  /// No description provided for @item.
  ///
  /// In bs, this message translates to:
  /// **'Stavka'**
  String get item;

  /// No description provided for @comment.
  ///
  /// In bs, this message translates to:
  /// **'Komentar'**
  String get comment;

  /// No description provided for @guest.
  ///
  /// In bs, this message translates to:
  /// **'Gost'**
  String get guest;

  /// No description provided for @date.
  ///
  /// In bs, this message translates to:
  /// **'Datum'**
  String get date;

  /// No description provided for @noNewsShort.
  ///
  /// In bs, this message translates to:
  /// **'Nema novosti.'**
  String get noNewsShort;

  /// No description provided for @reportPeriod.
  ///
  /// In bs, this message translates to:
  /// **'Period izvještaja'**
  String get reportPeriod;

  /// No description provided for @reportPeriodMax.
  ///
  /// In bs, this message translates to:
  /// **'Period izvještaja može biti najviše godinu dana.'**
  String get reportPeriodMax;

  /// No description provided for @saveReport.
  ///
  /// In bs, this message translates to:
  /// **'Sačuvaj izvještaj'**
  String get saveReport;

  /// No description provided for @reportSaved.
  ///
  /// In bs, this message translates to:
  /// **'Izvještaj je sačuvan: {path}'**
  String reportSaved(String path);

  /// No description provided for @open.
  ///
  /// In bs, this message translates to:
  /// **'Otvori'**
  String get open;

  /// No description provided for @periodLabel.
  ///
  /// In bs, this message translates to:
  /// **'Period:'**
  String get periodLabel;

  /// No description provided for @reportPeriodHint.
  ///
  /// In bs, this message translates to:
  /// **'Najviše godinu dana. Isti period se koristi za sva tri izvještaja.'**
  String get reportPeriodHint;

  /// No description provided for @financialReport.
  ///
  /// In bs, this message translates to:
  /// **'Finansijski izvještaj'**
  String get financialReport;

  /// No description provided for @financialReportDescription.
  ///
  /// In bs, this message translates to:
  /// **'Uplate, povrati i neto prihod po vrsti (smještaj, oprema, aktivnosti) i po mjesecima.'**
  String get financialReportDescription;

  /// No description provided for @occupancyReport.
  ///
  /// In bs, this message translates to:
  /// **'Zauzetost smještaja'**
  String get occupancyReport;

  /// No description provided for @occupancyReportDescription.
  ///
  /// In bs, this message translates to:
  /// **'Po sobi: zauzete od mogućih noći, popunjenost u %, broj rezervacija, prosječan boravak i prihod.'**
  String get occupancyReportDescription;

  /// No description provided for @activitiesReport.
  ///
  /// In bs, this message translates to:
  /// **'Aktivnosti i ocjene'**
  String get activitiesReport;

  /// No description provided for @activitiesReportDescription.
  ///
  /// In bs, this message translates to:
  /// **'Termini, popunjenost i prihod po aktivnosti, te ocjene, favoriti i pregledi mjesta.'**
  String get activitiesReportDescription;

  /// No description provided for @downloadPdf.
  ///
  /// In bs, this message translates to:
  /// **'Preuzmi PDF'**
  String get downloadPdf;

  /// No description provided for @reportsLanguageNote.
  ///
  /// In bs, this message translates to:
  /// **'PDF izvještaji se generišu na bosanskom jeziku.'**
  String get reportsLanguageNote;

  /// No description provided for @modelRetrained.
  ///
  /// In bs, this message translates to:
  /// **'Model je ponovo istreniran.'**
  String get modelRetrained;

  /// No description provided for @tooLittleData.
  ///
  /// In bs, this message translates to:
  /// **'Premalo podataka za treniranje modela.'**
  String get tooLittleData;

  /// No description provided for @modelTrained.
  ///
  /// In bs, this message translates to:
  /// **'Model je istreniran i koristi se za preporuke'**
  String get modelTrained;

  /// No description provided for @modelNotTrained.
  ///
  /// In bs, this message translates to:
  /// **'Model nije istreniran'**
  String get modelNotTrained;

  /// No description provided for @lastTraining.
  ///
  /// In bs, this message translates to:
  /// **'Zadnje treniranje: {date}. Model se automatski ponovo trenira svakih 6 sati.'**
  String lastTraining(String date);

  /// No description provided for @retrain.
  ///
  /// In bs, this message translates to:
  /// **'Ponovo treniraj'**
  String get retrain;

  /// No description provided for @interactions.
  ///
  /// In bs, this message translates to:
  /// **'Interakcija'**
  String get interactions;

  /// No description provided for @positiveChoices.
  ///
  /// In bs, this message translates to:
  /// **'Izbora (pozitivnih)'**
  String get positiveChoices;

  /// No description provided for @guests.
  ///
  /// In bs, this message translates to:
  /// **'Gostiju'**
  String get guests;

  /// No description provided for @items.
  ///
  /// In bs, this message translates to:
  /// **'Stavki'**
  String get items;

  /// No description provided for @recommendationQuality.
  ///
  /// In bs, this message translates to:
  /// **'Kvalitet preporuka (HitRate@{k})'**
  String recommendationQuality(int k);

  /// No description provided for @hitRateExplanation.
  ///
  /// In bs, this message translates to:
  /// **'Koliko često je stvarno izabrana (sakrivena) stavka među top {k} preporuka. Evaluirano na {count} izbora'**
  String hitRateExplanation(int k, int count);

  /// No description provided for @ourModel.
  ///
  /// In bs, this message translates to:
  /// **'Naš model (Matrix Factorization)'**
  String get ourModel;

  /// No description provided for @popularityBaseline.
  ///
  /// In bs, this message translates to:
  /// **'Popularnost (svima isto)'**
  String get popularityBaseline;

  /// No description provided for @randomBaseline.
  ///
  /// In bs, this message translates to:
  /// **'Slučajan izbor'**
  String get randomBaseline;

  /// No description provided for @selectedParameters.
  ///
  /// In bs, this message translates to:
  /// **'Izabrani parametri: rank {rank}, λ {lambda}, α {alpha}'**
  String selectedParameters(String rank, String lambda, String alpha);

  /// No description provided for @recommenderExplanation.
  ///
  /// In bs, this message translates to:
  /// **'Preporuke koriste one-class Matrix Factorization (ML.NET) nad interakcijama gostiju: recenzijama, favoritima, rezervacijama i pregledima. Gosti bez dovoljno interakcija dobijaju popularne stavke. Detalji su u dokumentu recommender-dokumentacija.md.'**
  String get recommenderExplanation;

  /// No description provided for @reason.
  ///
  /// In bs, this message translates to:
  /// **'Razlog'**
  String get reason;

  /// No description provided for @reasonVisibleToGuest.
  ///
  /// In bs, this message translates to:
  /// **'Gost će vidjeti razlog u obavijesti i emailu.'**
  String get reasonVisibleToGuest;

  /// No description provided for @enterReason.
  ///
  /// In bs, this message translates to:
  /// **'Unesite razlog (najmanje 3 znaka).'**
  String get enterReason;

  /// No description provided for @confirmReservationTitle.
  ///
  /// In bs, this message translates to:
  /// **'Potvrda rezervacije'**
  String get confirmReservationTitle;

  /// No description provided for @confirmReservationQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Potvrditi rezervaciju gosta {guest} ({item})? Gost će dobiti obavijest.'**
  String confirmReservationQuestion(String guest, String item);

  /// No description provided for @reservationConfirmed.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija je potvrđena.'**
  String get reservationConfirmed;

  /// No description provided for @rejectReservationTitle.
  ///
  /// In bs, this message translates to:
  /// **'Odbijanje rezervacije'**
  String get rejectReservationTitle;

  /// No description provided for @rejectReasonExample.
  ///
  /// In bs, this message translates to:
  /// **'npr. Soba nije dostupna zbog radova.'**
  String get rejectReasonExample;

  /// No description provided for @reservationRejected.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija je odbijena.'**
  String get reservationRejected;

  /// No description provided for @completeReservationTitle.
  ///
  /// In bs, this message translates to:
  /// **'Završetak rezervacije'**
  String get completeReservationTitle;

  /// No description provided for @completeReservationQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Označiti rezervaciju gosta {guest} kao završenu? Gost će dobiti poziv da ostavi recenziju.'**
  String completeReservationQuestion(String guest);

  /// No description provided for @reservationCompleted.
  ///
  /// In bs, this message translates to:
  /// **'Rezervacija je označena kao završena.'**
  String get reservationCompleted;

  /// No description provided for @cancelReservationTitle.
  ///
  /// In bs, this message translates to:
  /// **'Otkazivanje rezervacije'**
  String get cancelReservationTitle;

  /// No description provided for @cancelReasonExample.
  ///
  /// In bs, this message translates to:
  /// **'npr. Loši vremenski uslovi.'**
  String get cancelReasonExample;

  /// No description provided for @refundAutomatic.
  ///
  /// In bs, this message translates to:
  /// **'Uplaćeni iznos se automatski vraća gostu.'**
  String get refundAutomatic;

  /// No description provided for @quantity.
  ///
  /// In bs, this message translates to:
  /// **'Količina'**
  String get quantity;

  /// No description provided for @guestNote.
  ///
  /// In bs, this message translates to:
  /// **'Napomena gosta'**
  String get guestNote;

  /// No description provided for @statusHistory.
  ///
  /// In bs, this message translates to:
  /// **'Historija statusa'**
  String get statusHistory;

  /// No description provided for @reject.
  ///
  /// In bs, this message translates to:
  /// **'Odbij'**
  String get reject;

  /// No description provided for @guestNotPaid.
  ///
  /// In bs, this message translates to:
  /// **'Gost još nije platio rezervaciju.'**
  String get guestNotPaid;

  /// No description provided for @cancelAction.
  ///
  /// In bs, this message translates to:
  /// **'Otkaži'**
  String get cancelAction;

  /// No description provided for @markCompleted.
  ///
  /// In bs, this message translates to:
  /// **'Označi kao završenu'**
  String get markCompleted;

  /// No description provided for @noActionsForStatus.
  ///
  /// In bs, this message translates to:
  /// **'Za rezervaciju sa statusom \"{status}\" nema dostupnih akcija.'**
  String noActionsForStatus(String status);

  /// No description provided for @rejectCancelNotifies.
  ///
  /// In bs, this message translates to:
  /// **'Odbijanje ili otkazivanje šalje gostu obavijest i email.'**
  String get rejectCancelNotifies;

  /// No description provided for @createdWithStatus.
  ///
  /// In bs, this message translates to:
  /// **'Kreirana ({status})'**
  String createdWithStatus(String status);

  /// No description provided for @selectPeriod.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite period'**
  String get selectPeriod;

  /// No description provided for @noReservationsForFilters.
  ///
  /// In bs, this message translates to:
  /// **'Nema rezervacija za odabrane filtere.'**
  String get noReservationsForFilters;

  /// No description provided for @paid.
  ///
  /// In bs, this message translates to:
  /// **'Plaćeno'**
  String get paid;

  /// No description provided for @guestNameHint.
  ///
  /// In bs, this message translates to:
  /// **'Ime ili prezime gosta'**
  String get guestNameHint;

  /// No description provided for @allTypes.
  ///
  /// In bs, this message translates to:
  /// **'Sve vrste'**
  String get allTypes;

  /// No description provided for @periodFilter.
  ///
  /// In bs, this message translates to:
  /// **'Period'**
  String get periodFilter;

  /// No description provided for @clearFilters.
  ///
  /// In bs, this message translates to:
  /// **'Očisti filtere'**
  String get clearFilters;

  /// No description provided for @roomAddedAddImages.
  ///
  /// In bs, this message translates to:
  /// **'Soba je dodana. Sada možete dodati slike.'**
  String get roomAddedAddImages;

  /// No description provided for @deletingRoom.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje sobe'**
  String get deletingRoom;

  /// No description provided for @deleteRoomQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati sobu \"{name}\"? Ovo se ne može poništiti.\n\nAko soba ima rezervacije, brisanje nije moguće. Tada je umjesto toga označite kao neaktivnu.'**
  String deleteRoomQuestion(String name);

  /// No description provided for @newRoom.
  ///
  /// In bs, this message translates to:
  /// **'Nova soba'**
  String get newRoom;

  /// No description provided for @images.
  ///
  /// In bs, this message translates to:
  /// **'Slike'**
  String get images;

  /// No description provided for @imagesHint.
  ///
  /// In bs, this message translates to:
  /// **'JPG ili PNG, najviše 5 MB. Naslovna slika se prikazuje u listi i na mobilnoj aplikaciji.'**
  String get imagesHint;

  /// No description provided for @imagesAfterSaveRoom.
  ///
  /// In bs, this message translates to:
  /// **'Slike možete dodati nakon što sačuvate sobu.'**
  String get imagesAfterSaveRoom;

  /// No description provided for @addRoom.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj sobu'**
  String get addRoom;

  /// No description provided for @nameLength3to100.
  ///
  /// In bs, this message translates to:
  /// **'Naziv mora imati između 3 i 100 znakova.'**
  String get nameLength3to100;

  /// No description provided for @nameLength3to150.
  ///
  /// In bs, this message translates to:
  /// **'Naziv mora imati između 3 i 150 znakova.'**
  String get nameLength3to150;

  /// No description provided for @roomTypeRequired.
  ///
  /// In bs, this message translates to:
  /// **'Tip sobe *'**
  String get roomTypeRequired;

  /// No description provided for @selectRoomType.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite tip sobe.'**
  String get selectRoomType;

  /// No description provided for @capacityPeopleRequired.
  ///
  /// In bs, this message translates to:
  /// **'Kapacitet (osoba) *'**
  String get capacityPeopleRequired;

  /// No description provided for @between1and10People.
  ///
  /// In bs, this message translates to:
  /// **'Između 1 i 10 osoba.'**
  String get between1and10People;

  /// No description provided for @areaRequired.
  ///
  /// In bs, this message translates to:
  /// **'Površina (m²) *'**
  String get areaRequired;

  /// No description provided for @between5and200m2.
  ///
  /// In bs, this message translates to:
  /// **'Između 5 i 200 m².'**
  String get between5and200m2;

  /// No description provided for @pricePerNightRequired.
  ///
  /// In bs, this message translates to:
  /// **'Cijena po noći (KM) *'**
  String get pricePerNightRequired;

  /// No description provided for @priceExample.
  ///
  /// In bs, this message translates to:
  /// **'npr. 90,50'**
  String get priceExample;

  /// No description provided for @priceNightRange.
  ///
  /// In bs, this message translates to:
  /// **'Između 1 i 10.000 KM, npr. 90,50.'**
  String get priceNightRange;

  /// No description provided for @roomAmenities.
  ///
  /// In bs, this message translates to:
  /// **'Sadržaji sobe'**
  String get roomAmenities;

  /// No description provided for @activeFemale.
  ///
  /// In bs, this message translates to:
  /// **'Aktivna'**
  String get activeFemale;

  /// No description provided for @inactiveRoomsHint.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivne sobe gosti ne vide i ne mogu ih rezervisati.'**
  String get inactiveRoomsHint;

  /// No description provided for @roomName.
  ///
  /// In bs, this message translates to:
  /// **'Naziv sobe'**
  String get roomName;

  /// No description provided for @allTypesFilter.
  ///
  /// In bs, this message translates to:
  /// **'Svi tipovi'**
  String get allTypesFilter;

  /// No description provided for @activePlural.
  ///
  /// In bs, this message translates to:
  /// **'Aktivne'**
  String get activePlural;

  /// No description provided for @inactivePlural.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivne'**
  String get inactivePlural;

  /// No description provided for @noRooms.
  ///
  /// In bs, this message translates to:
  /// **'Nema soba za prikaz.'**
  String get noRooms;

  /// No description provided for @typeShort.
  ///
  /// In bs, this message translates to:
  /// **'Tip'**
  String get typeShort;

  /// No description provided for @capacity.
  ///
  /// In bs, this message translates to:
  /// **'Kapacitet'**
  String get capacity;

  /// No description provided for @area.
  ///
  /// In bs, this message translates to:
  /// **'Površina'**
  String get area;

  /// No description provided for @pricePerNightHeader.
  ///
  /// In bs, this message translates to:
  /// **'Cijena / noć'**
  String get pricePerNightHeader;

  /// No description provided for @inactiveFemale.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivna'**
  String get inactiveFemale;

  /// No description provided for @equipmentAddedAddImage.
  ///
  /// In bs, this message translates to:
  /// **'Oprema je dodana. Sada možete dodati sliku.'**
  String get equipmentAddedAddImage;

  /// No description provided for @deletingEquipment.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje opreme'**
  String get deletingEquipment;

  /// No description provided for @deleteEquipmentQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati \"{name}\"? Ovo se ne može poništiti.\n\nAko oprema ima rezervacije, brisanje nije moguće. Tada je umjesto toga označite kao neaktivnu.'**
  String deleteEquipmentQuestion(String name);

  /// No description provided for @newEquipment.
  ///
  /// In bs, this message translates to:
  /// **'Nova oprema'**
  String get newEquipment;

  /// No description provided for @equipmentTypeRequired.
  ///
  /// In bs, this message translates to:
  /// **'Tip opreme *'**
  String get equipmentTypeRequired;

  /// No description provided for @selectEquipmentType.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite tip opreme.'**
  String get selectEquipmentType;

  /// No description provided for @peoplePerPieceRequired.
  ///
  /// In bs, this message translates to:
  /// **'Osoba po komadu *'**
  String get peoplePerPieceRequired;

  /// No description provided for @peoplePerPieceHint.
  ///
  /// In bs, this message translates to:
  /// **'npr. 2 za kajak dvosjed'**
  String get peoplePerPieceHint;

  /// No description provided for @between1and4.
  ///
  /// In bs, this message translates to:
  /// **'Između 1 i 4.'**
  String get between1and4;

  /// No description provided for @totalPiecesRequired.
  ///
  /// In bs, this message translates to:
  /// **'Ukupno komada *'**
  String get totalPiecesRequired;

  /// No description provided for @totalPiecesHint.
  ///
  /// In bs, this message translates to:
  /// **'koliko ih imate na raspolaganju'**
  String get totalPiecesHint;

  /// No description provided for @between1and100.
  ///
  /// In bs, this message translates to:
  /// **'Između 1 i 100.'**
  String get between1and100;

  /// No description provided for @firstHourKmRequired.
  ///
  /// In bs, this message translates to:
  /// **'Prvi sat (KM) *'**
  String get firstHourKmRequired;

  /// No description provided for @additionalHourKmRequired.
  ///
  /// In bs, this message translates to:
  /// **'Svaki sljedeći sat (KM) *'**
  String get additionalHourKmRequired;

  /// No description provided for @fullDayKmRequired.
  ///
  /// In bs, this message translates to:
  /// **'Cijeli dan (KM) *'**
  String get fullDayKmRequired;

  /// No description provided for @inactiveEquipmentHint.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivnu opremu gosti ne vide i ne mogu je rezervisati.'**
  String get inactiveEquipmentHint;

  /// No description provided for @imageAfterSaveEquipment.
  ///
  /// In bs, this message translates to:
  /// **'Sliku možete dodati nakon što sačuvate opremu.'**
  String get imageAfterSaveEquipment;

  /// No description provided for @addEquipment.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj opremu'**
  String get addEquipment;

  /// No description provided for @between1and1000Km.
  ///
  /// In bs, this message translates to:
  /// **'Između 1 i 1.000 KM.'**
  String get between1and1000Km;

  /// No description provided for @fullDayShort.
  ///
  /// In bs, this message translates to:
  /// **'cijeli dan: {price}'**
  String fullDayShort(String price);

  /// No description provided for @guestPaysPerPiece.
  ///
  /// In bs, this message translates to:
  /// **'Gost plaća po komadu: {prices}'**
  String guestPaysPerPiece(String prices);

  /// No description provided for @equipmentName.
  ///
  /// In bs, this message translates to:
  /// **'Naziv opreme'**
  String get equipmentName;

  /// No description provided for @noEquipment.
  ///
  /// In bs, this message translates to:
  /// **'Nema opreme za prikaz.'**
  String get noEquipment;

  /// No description provided for @peoplePerPieceShort.
  ///
  /// In bs, this message translates to:
  /// **'Osoba / kom.'**
  String get peoplePerPieceShort;

  /// No description provided for @pieces.
  ///
  /// In bs, this message translates to:
  /// **'Komada'**
  String get pieces;

  /// No description provided for @firstHour.
  ///
  /// In bs, this message translates to:
  /// **'Prvi sat'**
  String get firstHour;

  /// No description provided for @additionalHour.
  ///
  /// In bs, this message translates to:
  /// **'Sljedeći sat'**
  String get additionalHour;

  /// No description provided for @fullDay.
  ///
  /// In bs, this message translates to:
  /// **'Cijeli dan'**
  String get fullDay;

  /// No description provided for @placeAdded.
  ///
  /// In bs, this message translates to:
  /// **'Mjesto je dodano ({km} km od smještaja). Sada možete dodati slike.'**
  String placeAdded(String km);

  /// No description provided for @deletingPlace.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje mjesta'**
  String get deletingPlace;

  /// No description provided for @deletePlaceQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati \"{name}\"? Ovo se ne može poništiti.\n\nAko mjesto ima recenzije ili je u favoritima gostiju, brisanje nije moguće. Tada ga označite kao neaktivno.'**
  String deletePlaceQuestion(String name);

  /// No description provided for @newPlace.
  ///
  /// In bs, this message translates to:
  /// **'Novo mjesto'**
  String get newPlace;

  /// No description provided for @placeTypeRequired.
  ///
  /// In bs, this message translates to:
  /// **'Tip mjesta *'**
  String get placeTypeRequired;

  /// No description provided for @selectPlaceType.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite tip mjesta.'**
  String get selectPlaceType;

  /// No description provided for @addressSettlement.
  ///
  /// In bs, this message translates to:
  /// **'Adresa / naselje'**
  String get addressSettlement;

  /// No description provided for @addressExample.
  ///
  /// In bs, this message translates to:
  /// **'npr. Donja Drežnica'**
  String get addressExample;

  /// No description provided for @latitudeRequired.
  ///
  /// In bs, this message translates to:
  /// **'Geografska širina *'**
  String get latitudeRequired;

  /// No description provided for @longitudeRequired.
  ///
  /// In bs, this message translates to:
  /// **'Geografska dužina *'**
  String get longitudeRequired;

  /// No description provided for @selectLocationOnMap.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite lokaciju na karti.'**
  String get selectLocationOnMap;

  /// No description provided for @distanceFromAccommodation.
  ///
  /// In bs, this message translates to:
  /// **'Udaljenost od smještaja: {km} km'**
  String distanceFromAccommodation(String km);

  /// No description provided for @activeNeuter.
  ///
  /// In bs, this message translates to:
  /// **'Aktivno'**
  String get activeNeuter;

  /// No description provided for @inactivePlacesHint.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivna mjesta gosti ne vide.'**
  String get inactivePlacesHint;

  /// No description provided for @imagesAfterSavePlace.
  ///
  /// In bs, this message translates to:
  /// **'Slike možete dodati nakon što sačuvate mjesto.'**
  String get imagesAfterSavePlace;

  /// No description provided for @addPlace.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj mjesto'**
  String get addPlace;

  /// No description provided for @placeName.
  ///
  /// In bs, this message translates to:
  /// **'Naziv mjesta'**
  String get placeName;

  /// No description provided for @allNeuter.
  ///
  /// In bs, this message translates to:
  /// **'Sva'**
  String get allNeuter;

  /// No description provided for @noPlaces.
  ///
  /// In bs, this message translates to:
  /// **'Nema mjesta za prikaz.'**
  String get noPlaces;

  /// No description provided for @address.
  ///
  /// In bs, this message translates to:
  /// **'Adresa'**
  String get address;

  /// No description provided for @distance.
  ///
  /// In bs, this message translates to:
  /// **'Udaljenost'**
  String get distance;

  /// No description provided for @inactiveNeuter.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivno'**
  String get inactiveNeuter;

  /// No description provided for @activityName.
  ///
  /// In bs, this message translates to:
  /// **'Naziv aktivnosti'**
  String get activityName;

  /// No description provided for @category.
  ///
  /// In bs, this message translates to:
  /// **'Kategorija'**
  String get category;

  /// No description provided for @allCategories.
  ///
  /// In bs, this message translates to:
  /// **'Sve kategorije'**
  String get allCategories;

  /// No description provided for @addActivity.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj aktivnost'**
  String get addActivity;

  /// No description provided for @noActivities.
  ///
  /// In bs, this message translates to:
  /// **'Nema aktivnosti za prikaz.'**
  String get noActivities;

  /// No description provided for @duration.
  ///
  /// In bs, this message translates to:
  /// **'Trajanje'**
  String get duration;

  /// No description provided for @maxPeople.
  ///
  /// In bs, this message translates to:
  /// **'Max osoba'**
  String get maxPeople;

  /// No description provided for @pricePerPersonHeader.
  ///
  /// In bs, this message translates to:
  /// **'Cijena / osobi'**
  String get pricePerPersonHeader;

  /// No description provided for @nextSlotHeader.
  ///
  /// In bs, this message translates to:
  /// **'Sljedeći termin'**
  String get nextSlotHeader;

  /// No description provided for @noSlots.
  ///
  /// In bs, this message translates to:
  /// **'Nema termina'**
  String get noSlots;

  /// No description provided for @activityAdded.
  ///
  /// In bs, this message translates to:
  /// **'Aktivnost je dodana. Sada možete dodati sliku i termine.'**
  String get activityAdded;

  /// No description provided for @deletingActivity.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje aktivnosti'**
  String get deletingActivity;

  /// No description provided for @deleteActivityQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati \"{name}\"? Ovo se ne može poništiti.\n\nAko aktivnost ima termine ili rezervacije, brisanje nije moguće. Tada je umjesto toga označite kao neaktivnu.'**
  String deleteActivityQuestion(String name);

  /// No description provided for @newActivity.
  ///
  /// In bs, this message translates to:
  /// **'Nova aktivnost'**
  String get newActivity;

  /// No description provided for @categoryRequired.
  ///
  /// In bs, this message translates to:
  /// **'Kategorija *'**
  String get categoryRequired;

  /// No description provided for @selectCategory.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite kategoriju.'**
  String get selectCategory;

  /// No description provided for @durationMinutesRequired.
  ///
  /// In bs, this message translates to:
  /// **'Trajanje (minuta) *'**
  String get durationMinutesRequired;

  /// No description provided for @durationHint.
  ///
  /// In bs, this message translates to:
  /// **'npr. 180 = 3 sata'**
  String get durationHint;

  /// No description provided for @between30and720Minutes.
  ///
  /// In bs, this message translates to:
  /// **'Između 30 i 720 minuta.'**
  String get between30and720Minutes;

  /// No description provided for @maxParticipantsRequired.
  ///
  /// In bs, this message translates to:
  /// **'Max učesnika *'**
  String get maxParticipantsRequired;

  /// No description provided for @between1and50.
  ///
  /// In bs, this message translates to:
  /// **'Između 1 i 50.'**
  String get between1and50;

  /// No description provided for @pricePerPersonRequired.
  ///
  /// In bs, this message translates to:
  /// **'Cijena po osobi (KM) *'**
  String get pricePerPersonRequired;

  /// No description provided for @meetingPoint.
  ///
  /// In bs, this message translates to:
  /// **'Mjesto okupljanja'**
  String get meetingPoint;

  /// No description provided for @meetingPointExample.
  ///
  /// In bs, this message translates to:
  /// **'npr. Plaža ispred smještaja'**
  String get meetingPointExample;

  /// No description provided for @inactiveActivityHint.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivnu aktivnost gosti ne vide i ne mogu je rezervisati.'**
  String get inactiveActivityHint;

  /// No description provided for @imageAfterSaveActivity.
  ///
  /// In bs, this message translates to:
  /// **'Sliku možete dodati nakon što sačuvate aktivnost.'**
  String get imageAfterSaveActivity;

  /// No description provided for @slotsAfterSaveActivity.
  ///
  /// In bs, this message translates to:
  /// **'Termine možete dodati nakon što sačuvate aktivnost.'**
  String get slotsAfterSaveActivity;

  /// No description provided for @slots.
  ///
  /// In bs, this message translates to:
  /// **'Termini'**
  String get slots;

  /// No description provided for @onlyUpcoming.
  ///
  /// In bs, this message translates to:
  /// **'Samo budući'**
  String get onlyUpcoming;

  /// No description provided for @addSlot.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj termin'**
  String get addSlot;

  /// No description provided for @addGuideFirst.
  ///
  /// In bs, this message translates to:
  /// **'Prvo dodajte bar jednog vodiča (Šifarnici → Vodiči).'**
  String get addGuideFirst;

  /// No description provided for @noUpcomingSlots.
  ///
  /// In bs, this message translates to:
  /// **'Nema budućih termina.'**
  String get noUpcomingSlots;

  /// No description provided for @noSlotsShort.
  ///
  /// In bs, this message translates to:
  /// **'Nema termina.'**
  String get noSlotsShort;

  /// No description provided for @start.
  ///
  /// In bs, this message translates to:
  /// **'Početak'**
  String get start;

  /// No description provided for @end.
  ///
  /// In bs, this message translates to:
  /// **'Kraj'**
  String get end;

  /// No description provided for @booked.
  ///
  /// In bs, this message translates to:
  /// **'Zauzeto'**
  String get booked;

  /// No description provided for @available.
  ///
  /// In bs, this message translates to:
  /// **'Slobodno'**
  String get available;

  /// No description provided for @selectStartDateTime.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite datum i vrijeme početka.'**
  String get selectStartDateTime;

  /// No description provided for @slotMustBeFuture.
  ///
  /// In bs, this message translates to:
  /// **'Termin mora biti u budućnosti.'**
  String get slotMustBeFuture;

  /// No description provided for @deletingSlot.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje termina'**
  String get deletingSlot;

  /// No description provided for @deleteSlotQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati termin {date}?'**
  String deleteSlotQuestion(String date);

  /// No description provided for @slot.
  ///
  /// In bs, this message translates to:
  /// **'Termin'**
  String get slot;

  /// No description provided for @newSlot.
  ///
  /// In bs, this message translates to:
  /// **'Novi termin'**
  String get newSlot;

  /// No description provided for @slotStartedCannotChange.
  ///
  /// In bs, this message translates to:
  /// **'Termin je već počeo ili završio i ne može se mijenjati.'**
  String get slotStartedCannotChange;

  /// No description provided for @slotHasBookings.
  ///
  /// In bs, this message translates to:
  /// **'Termin ima {count} rezervisanih mjesta. Vrijeme se ne može mijenjati, a kapacitet ne može biti manji od {count}.'**
  String slotHasBookings(int count);

  /// No description provided for @dateRequired.
  ///
  /// In bs, this message translates to:
  /// **'Datum *'**
  String get dateRequired;

  /// No description provided for @timeRequired.
  ///
  /// In bs, this message translates to:
  /// **'Vrijeme *'**
  String get timeRequired;

  /// No description provided for @endsAt.
  ///
  /// In bs, this message translates to:
  /// **'Završava u {time} (trajanje {duration}).'**
  String endsAt(String time, String duration);

  /// No description provided for @capacityRequired.
  ///
  /// In bs, this message translates to:
  /// **'Kapacitet *'**
  String get capacityRequired;

  /// No description provided for @capacityMaxHint.
  ///
  /// In bs, this message translates to:
  /// **'Najviše {max} (maksimum aktivnosti)'**
  String capacityMaxHint(int max);

  /// No description provided for @betweenRange.
  ///
  /// In bs, this message translates to:
  /// **'Između {min} i {max}.'**
  String betweenRange(int min, int max);

  /// No description provided for @guideRequired.
  ///
  /// In bs, this message translates to:
  /// **'Vodič *'**
  String get guideRequired;

  /// No description provided for @selectGuide.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite vodiča.'**
  String get selectGuide;

  /// No description provided for @selectAtLeastOneRole.
  ///
  /// In bs, this message translates to:
  /// **'Odaberite barem jednu ulogu.'**
  String get selectAtLeastOneRole;

  /// No description provided for @userLoggedOutEverywhere.
  ///
  /// In bs, this message translates to:
  /// **'Korisnik je odjavljen sa svih uređaja.'**
  String get userLoggedOutEverywhere;

  /// No description provided for @userAdded.
  ///
  /// In bs, this message translates to:
  /// **'Korisnik je dodan.'**
  String get userAdded;

  /// No description provided for @deletingUser.
  ///
  /// In bs, this message translates to:
  /// **'Brisanje korisnika'**
  String get deletingUser;

  /// No description provided for @deleteUserQuestion.
  ///
  /// In bs, this message translates to:
  /// **'Obrisati korisnika {name}? Ovo se ne može poništiti.\n\nAko korisnik ima rezervacije, recenzije ili plaćanja, brisanje nije moguće. Tada ga umjesto toga deaktivirajte.'**
  String deleteUserQuestion(String name);

  /// No description provided for @roleGuest.
  ///
  /// In bs, this message translates to:
  /// **'Gost'**
  String get roleGuest;

  /// No description provided for @newUser.
  ///
  /// In bs, this message translates to:
  /// **'Novi korisnik'**
  String get newUser;

  /// No description provided for @personalData.
  ///
  /// In bs, this message translates to:
  /// **'Lični podaci'**
  String get personalData;

  /// No description provided for @access.
  ///
  /// In bs, this message translates to:
  /// **'Pristup'**
  String get access;

  /// No description provided for @leaveEmptyPassword.
  ///
  /// In bs, this message translates to:
  /// **'Ostavite prazno ako ne mijenjate lozinku.'**
  String get leaveEmptyPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In bs, this message translates to:
  /// **'Potvrda lozinke *'**
  String get confirmPassword;

  /// No description provided for @confirmNewPasswordOptional.
  ///
  /// In bs, this message translates to:
  /// **'Potvrda nove lozinke'**
  String get confirmNewPasswordOptional;

  /// No description provided for @rolesRequired.
  ///
  /// In bs, this message translates to:
  /// **'Uloge *'**
  String get rolesRequired;

  /// No description provided for @activeMasculine.
  ///
  /// In bs, this message translates to:
  /// **'Aktivan'**
  String get activeMasculine;

  /// No description provided for @cannotDeactivateSelf.
  ///
  /// In bs, this message translates to:
  /// **'Ne možete deaktivirati vlastiti račun.'**
  String get cannotDeactivateSelf;

  /// No description provided for @inactiveUserHint.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivan korisnik se ne može prijaviti, a postojeće sesije se odmah prekidaju.'**
  String get inactiveUserHint;

  /// No description provided for @registeredAt.
  ///
  /// In bs, this message translates to:
  /// **'Registrovan: {date}'**
  String registeredAt(String date);

  /// No description provided for @addUser.
  ///
  /// In bs, this message translates to:
  /// **'Dodaj korisnika'**
  String get addUser;

  /// No description provided for @userSearchHint.
  ///
  /// In bs, this message translates to:
  /// **'Ime, korisničko ime ili e-mail'**
  String get userSearchHint;

  /// No description provided for @role.
  ///
  /// In bs, this message translates to:
  /// **'Uloga'**
  String get role;

  /// No description provided for @allRoles.
  ///
  /// In bs, this message translates to:
  /// **'Sve uloge'**
  String get allRoles;

  /// No description provided for @allMasculine.
  ///
  /// In bs, this message translates to:
  /// **'Svi'**
  String get allMasculine;

  /// No description provided for @activeMasculinePlural.
  ///
  /// In bs, this message translates to:
  /// **'Aktivni'**
  String get activeMasculinePlural;

  /// No description provided for @inactiveMasculinePlural.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivni'**
  String get inactiveMasculinePlural;

  /// No description provided for @noUsers.
  ///
  /// In bs, this message translates to:
  /// **'Nema korisnika za prikaz.'**
  String get noUsers;

  /// No description provided for @roles.
  ///
  /// In bs, this message translates to:
  /// **'Uloge'**
  String get roles;

  /// No description provided for @inactiveMasculine.
  ///
  /// In bs, this message translates to:
  /// **'Neaktivan'**
  String get inactiveMasculine;
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
