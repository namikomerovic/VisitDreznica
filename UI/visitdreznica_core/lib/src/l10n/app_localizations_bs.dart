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

  @override
  String get registration => 'Registracija';

  @override
  String get firstNameRequired => 'Ime *';

  @override
  String get lastNameRequired => 'Prezime *';

  @override
  String get emailRequiredLabel => 'E-mail *';

  @override
  String get phone => 'Telefon';

  @override
  String get cityRequiredLabel => 'Grad *';

  @override
  String get usernameRequiredLabel => 'Korisničko ime *';

  @override
  String get passwordRequiredLabel => 'Lozinka *';

  @override
  String get passwordConfirmRequiredLabel => 'Potvrda lozinke *';

  @override
  String get enterFirstName => 'Unesite ime (najviše 50 znakova).';

  @override
  String get enterLastName => 'Unesite prezime (najviše 50 znakova).';

  @override
  String get citiesLoadError => 'Gradove nije moguće učitati. Provjerite vezu.';

  @override
  String get selectCity => 'Odaberite grad.';

  @override
  String get passwordHint => 'Najmanje 8 znakova, slovo i broj.';

  @override
  String get passwordsDoNotMatch => 'Lozinke se ne podudaraju.';

  @override
  String get createAccount => 'Kreiraj račun';

  @override
  String resetCodeSent(String email) {
    return 'Ako postoji račun s adresom $email, poslali smo mu šestocifreni kod. Provjerite inbox i spam folder.';
  }

  @override
  String get forgottenPassword => 'Zaboravljena lozinka';

  @override
  String get enterCodeAndNewPassword =>
      'Unesite kod iz e-maila i novu lozinku.';

  @override
  String get enterAccountEmail =>
      'Unesite e-mail adresu svog računa. Poslat ćemo vam kod za postavljanje nove lozinke.';

  @override
  String get email => 'E-mail';

  @override
  String get sendCode => 'Pošalji kod';

  @override
  String get codeFromEmail => 'Kod iz e-maila';

  @override
  String get codeSixDigits => 'Kod se sastoji od tačno 6 cifara.';

  @override
  String get newPassword => 'Nova lozinka';

  @override
  String get confirmNewPassword => 'Potvrda nove lozinke';

  @override
  String get setNewPassword => 'Postavi novu lozinku';

  @override
  String get resendCode => 'Nije stigao kod? Pošalji ponovo';

  @override
  String helloName(String name) {
    return 'Zdravo, $name';
  }

  @override
  String get homeTitle => 'Udahni Drežnicu.';

  @override
  String get homeLocation => 'Drežnica, Bosna i Hercegovina';

  @override
  String get news => 'Novosti';

  @override
  String get noNews => 'Trenutno nema novosti.';

  @override
  String get searchHint => 'Pretraži smještaj, opremu, aktivnosti…';

  @override
  String get heroTitle => 'Malo mjesto.\nVeliki doživljaji.';

  @override
  String get heroSubtitle => 'Rijeka, kanjon i planina na dohvat ruke.';

  @override
  String get exploreOffer => 'Istraži ponudu';

  @override
  String get recommendedForYou => 'Preporučeno za vas';

  @override
  String get popularAmongGuests => 'Popularno među gostima';

  @override
  String get recommendationsHint =>
      'Ocijenite ili sačuvajte ono što vam se sviđa, pa ćemo vam preporučivati po vašem ukusu.';

  @override
  String get newsItem => 'Novost';

  @override
  String get removeFromFavorites => 'Ukloni iz favorita';

  @override
  String get addToFavorites => 'Dodaj u favorite';

  @override
  String get removedFromFavorites => 'Uklonjeno iz favorita.';

  @override
  String get addedToFavorites => 'Dodano u favorite.';

  @override
  String get noRatingsYet => 'Još nema ocjena';

  @override
  String get mapsAppError => 'Aplikaciju za mape nije moguće otvoriti.';

  @override
  String get reserve => 'Rezerviši';

  @override
  String get view => 'Pogledaj';

  @override
  String upToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'do $count osoba',
      few: 'do $count osobe',
      one: 'do $count osobe',
    );
    return '$_temp0';
  }

  @override
  String upToPeopleCapital(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Do $count osoba',
      few: 'Do $count osobe',
      one: 'Do $count osobe',
    );
    return '$_temp0';
  }

  @override
  String peoplePerPiece(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osoba po komadu',
      few: '$count osobe po komadu',
      one: '$count osoba po komadu',
    );
    return '$_temp0';
  }

  @override
  String pricePerNight(String price) {
    return '$price / noć';
  }

  @override
  String pricePerHourFrom(String price) {
    return 'od $price / sat';
  }

  @override
  String pricePerPerson(String price) {
    return '$price / osobi';
  }

  @override
  String get noSlotsNow => 'Trenutno nema termina';

  @override
  String nextSlot(String date) {
    return 'Sljedeći termin: $date';
  }

  @override
  String kmFromAccommodation(String km) {
    return '$km km od smještaja';
  }

  @override
  String searchType(String type) {
    return 'Pretraži: $type';
  }

  @override
  String get showOnMap => 'Prikaži na mapi';

  @override
  String totalPieces(int count) {
    return 'Ukupno komada: $count';
  }

  @override
  String firstHourPrice(String price) {
    return 'Prvi sat: $price';
  }

  @override
  String additionalHourPrice(String price) {
    return 'Svaki sljedeći sat: $price';
  }

  @override
  String fullDayPrice(String price) {
    return 'Cijeli dan: $price';
  }

  @override
  String maxParticipants(int count) {
    return 'Najviše $count učesnika';
  }

  @override
  String meetingPointLabel(String place) {
    return 'Okupljanje: $place';
  }

  @override
  String get detailsLoadError => 'Detalje nije moguće učitati.';

  @override
  String get description => 'Opis';

  @override
  String get amenities => 'Sadržaji';

  @override
  String get location => 'Lokacija';

  @override
  String get upcomingSlots => 'Nadolazeći termini';

  @override
  String get noScheduledSlots => 'Trenutno nema zakazanih termina.';

  @override
  String guideName(String name) {
    return 'Vodič: $name';
  }

  @override
  String get slotFull => 'Popunjeno';

  @override
  String spotsFree(int count) {
    return 'Slobodno: $count';
  }

  @override
  String get openMap => 'Otvori mapu';

  @override
  String get directions => 'Upute';

  @override
  String get ratingLabels =>
      'Dodirnite zvjezdicu|Loše|Slabo|Dobro|Vrlo dobro|Odlično';

  @override
  String get selectRating => 'Odaberite ocjenu od 1 do 5.';

  @override
  String get newReview => 'Nova recenzija';

  @override
  String get editReview => 'Uredi recenziju';

  @override
  String get commentOptional => 'Komentar (nije obavezan)';

  @override
  String get thanksForReview => 'Hvala na recenziji!';

  @override
  String get reviewUpdated => 'Recenzija je izmijenjena.';

  @override
  String get deleteReviewQuestion => 'Obrisati recenziju?';

  @override
  String get cannotBeUndone => 'Ova radnja se ne može poništiti.';

  @override
  String get reviewDeleted => 'Recenzija je obrisana.';

  @override
  String get reviews => 'Recenzije';

  @override
  String get yourReview => 'Vaša recenzija';

  @override
  String get writeReview => 'Napiši recenziju';

  @override
  String get reviewAfterReservation =>
      'Recenziju možete ostaviti nakon završene rezervacije.';

  @override
  String get loading => 'Učitavanje...';

  @override
  String get showMoreReviews => 'Prikaži još recenzija';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recenzija',
      few: '$count recenzije',
      one: '$count recenzija',
    );
    return '$_temp0';
  }

  @override
  String get noReviewsYet => 'Još nema recenzija.';

  @override
  String get placesMap => 'Mapa mjesta';

  @override
  String get accommodation => 'Smještaj';

  @override
  String get details => 'Detalji';

  @override
  String get activityBooking => 'Rezervacija aktivnosti';

  @override
  String perPersonAndDuration(String price, String duration) {
    return '$price po osobi · $duration';
  }

  @override
  String get selectSlot => 'Odaberite termin';

  @override
  String get numberOfPeople => 'Broj osoba';

  @override
  String meetingPointFull(String place) {
    return 'Mjesto okupljanja: $place';
  }

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osoba',
      few: '$count osobe',
      one: '$count osoba',
    );
    return '$_temp0';
  }

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count noći',
      few: '$count noći',
      one: '$count noć',
    );
    return '$_temp0';
  }

  @override
  String get reservation => 'Rezervacija';

  @override
  String get paymentSucceeded => 'Plaćanje je uspjelo!';

  @override
  String get reservationAwaitsPayment => 'Rezervacija čeka plaćanje';

  @override
  String get paidAwaitingConfirmation =>
      'Rezervacija je plaćena i čeka potvrdu. Obavijest i e-mail stižu čim je potvrdimo.';

  @override
  String get savedNotPaid =>
      'Rezervacija je sačuvana, ali nije plaćena. Ako je ne platite u roku od 30 minuta, automatski se otkazuje.';

  @override
  String get period => 'Termin';

  @override
  String get amount => 'Iznos';

  @override
  String get payNow => 'Plati sada';

  @override
  String get done => 'Gotovo';

  @override
  String get noteOptional => 'Napomena (nije obavezna)';

  @override
  String get reserveAndPay => 'Rezerviši i plati';

  @override
  String get paymentConfirmation => 'Potvrda plaćanja';

  @override
  String continueToCardPayment(String amount) {
    return 'Nastaviti na plaćanje karticom u iznosu od $amount?';
  }

  @override
  String get pay => 'Plati';

  @override
  String get rentalDay => 'Dan najma';

  @override
  String get equipmentRental => 'Najam opreme';

  @override
  String equipmentPricing(String first, String additional, String fullDay) {
    return 'Prvi sat $first, svaki sljedeći $additional, cijeli dan najviše $fullDay';
  }

  @override
  String get pickupDayAndTime => 'Dan i vrijeme preuzimanja';

  @override
  String get from => 'Od';

  @override
  String get durationHours => 'Trajanje (sati)';

  @override
  String get numberOfPieces => 'Broj komada';

  @override
  String returnAt(String date) {
    return 'Vraćanje: $date';
  }

  @override
  String onlyPiecesAvailable(int count) {
    return 'U tom periodu slobodno je samo $count kom. Smanjite broj komada ili promijenite termin.';
  }

  @override
  String pricePerPieceHours(int hours) {
    return 'Cijena po komadu ($hours h)';
  }

  @override
  String get selectArrivalDeparture => 'Odaberite dolazak i odlazak';

  @override
  String get roomBooking => 'Rezervacija sobe';

  @override
  String roomPriceCapacity(String price, String capacity) {
    return '$price / noć · $capacity';
  }

  @override
  String get stayPeriod => 'Termin boravka';

  @override
  String get selectDates => 'Odaberite datume';

  @override
  String get bookedDaysDisabled => 'Zauzeti dani su u kalendaru onemogućeni.';

  @override
  String get numberOfGuests => 'Broj gostiju';

  @override
  String get touristTax => 'Boravišna taksa';

  @override
  String get paymentFailed => 'Plaćanje nije uspjelo. Pokušajte ponovo.';

  @override
  String get paymentSucceededShort => 'Plaćanje je uspjelo.';

  @override
  String get cancelledRefund =>
      'Rezervacija je otkazana. Novac se vraća na vašu karticu.';

  @override
  String get cancelledNoRefund => 'Rezervacija je otkazana.';

  @override
  String get reservationDetails => 'Detalji rezervacije';

  @override
  String get payment => 'Plaćanje';

  @override
  String get paidByCard => 'Plaćeno karticom';

  @override
  String get notPaid => 'Nije plaćeno';

  @override
  String get created => 'Kreirana';

  @override
  String get note => 'Napomena';

  @override
  String payUntil(String time) {
    return 'Rezervaciju platite do $time, inače se automatski otkazuje.';
  }

  @override
  String payAmount(String amount) {
    return 'Plati $amount';
  }

  @override
  String yourRatingEdit(int rating) {
    return 'Vaša ocjena: $rating★ · uredi';
  }

  @override
  String get rate => 'Ocijeni';

  @override
  String viewItem(String name) {
    return 'Pogledaj: $name';
  }

  @override
  String get cancelReservation => 'Otkaži rezervaciju';

  @override
  String get cancelPolicy =>
      'Potvrđenu rezervaciju možete otkazati najkasnije 24 sata prije početka. Uplaćeni iznos se vraća na karticu.';

  @override
  String get history => 'Historija';

  @override
  String get cancelReservationQuestion => 'Otkazati rezervaciju?';

  @override
  String get refundToCard => 'Uplaćeni iznos biće vraćen na vašu karticu.';

  @override
  String get noRefundNotPaid =>
      'Rezervacija još nije plaćena, pa nema povrata novca.';

  @override
  String get reasonOptional => 'Razlog (nije obavezan)';

  @override
  String get filterActive => 'Aktivne';

  @override
  String get filterCompleted => 'Završene';

  @override
  String get filterCancelled => 'Otkazane';

  @override
  String get noActiveReservations => 'Nemate aktivnih rezervacija.';

  @override
  String get noCompletedReservations => 'Još nemate završenih rezervacija.';

  @override
  String get noCancelledReservations => 'Nemate otkazanih rezervacija.';

  @override
  String get awaitingPayment => 'Čeka plaćanje';

  @override
  String get noFavoritesYet => 'Još nemate favorita.';

  @override
  String get favoritesHint =>
      'Dodirnite ♥ na sobi, opremi, aktivnosti ili mjestu i sačuvajte ga ovdje.';

  @override
  String savedOn(String type, String date) {
    return '$type · sačuvano $date';
  }

  @override
  String get changePassword => 'Promijeni lozinku';

  @override
  String get currentPasswordRequired => 'Trenutna lozinka *';

  @override
  String get enterCurrentPassword => 'Unesite trenutnu lozinku.';

  @override
  String get newPasswordRequired => 'Nova lozinka *';

  @override
  String get newPasswordMustDiffer =>
      'Nova lozinka mora biti različita od trenutne.';

  @override
  String get confirmNewPasswordRequired => 'Potvrda nove lozinke *';

  @override
  String get logoutOtherDevices =>
      'Nakon promjene bićete odjavljeni sa svih drugih uređaja.';

  @override
  String get editProfile => 'Uredi profil';

  @override
  String usernameCannotChange(String username) {
    return 'Korisničko ime (@$username) se ne može mijenjati.';
  }

  @override
  String get profileSaved => 'Profil je sačuvan.';

  @override
  String get passwordChanged => 'Lozinka je promijenjena.';

  @override
  String get pickFromGallery => 'Odaberi iz galerije';

  @override
  String get removePhoto => 'Ukloni sliku';

  @override
  String errorTryAgain(String error) {
    return '$error Pokušaj ponovo.';
  }

  @override
  String get phoneNotEntered => 'Telefon nije unesen';

  @override
  String get markAllRead => 'Označi sve kao pročitano';

  @override
  String get noNotifications => 'Nemate obavijesti.';

  @override
  String get showOlder => 'Prikaži starije';
}
