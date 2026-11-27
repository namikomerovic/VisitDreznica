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

  @override
  String get deleting => 'Brisanje';

  @override
  String get deleteThisRecord => 'Obrisati ovaj zapis?';

  @override
  String get imageAdded => 'Slika je dodana.';

  @override
  String get deletingImage => 'Brisanje slike';

  @override
  String get deleteCoverImageQuestion =>
      'Obrisati naslovnu sliku? Sljedeća slika će automatski postati naslovna.';

  @override
  String get deleteImageQuestion => 'Obrisati ovu sliku?';

  @override
  String get imageDeleted => 'Slika je obrisana.';

  @override
  String get cover => 'Naslovna';

  @override
  String get imageOptions => 'Opcije slike';

  @override
  String get coverChanged => 'Naslovna slika je promijenjena.';

  @override
  String get setAsCover => 'Postavi kao naslovnu';

  @override
  String get addImage => 'Dodaj sliku';

  @override
  String get imageMax5Mb => 'Slika može imati najviše 5 MB.';

  @override
  String get clickMapToSetLocation => 'Kliknite na kartu da postavite lokaciju';

  @override
  String get markAllReadShort => 'Označi sve pročitano';

  @override
  String get onlyUnread => 'Samo nepročitane';

  @override
  String get noUnreadNotifications => 'Nema nepročitanih obavijesti.';

  @override
  String get noNotificationsShort => 'Nema obavijesti.';

  @override
  String get loadMore => 'Učitaj još';

  @override
  String get noData => 'Nema podataka za prikaz.';

  @override
  String shownRange(int first, int last, int total) {
    return 'Prikazano $first–$last od $total';
  }

  @override
  String get rowsPerPage => 'Redova po stranici:';

  @override
  String get previousPage => 'Prethodna stranica';

  @override
  String pageOf(int page, int pages) {
    return 'Stranica $page od $pages';
  }

  @override
  String get nextPage => 'Sljedeća stranica';

  @override
  String get imageSaved => 'Slika je sačuvana.';

  @override
  String get removingImage => 'Uklanjanje slike';

  @override
  String get removeImageQuestion => 'Ukloniti sliku?';

  @override
  String get remove => 'Ukloni';

  @override
  String get imageRemoved => 'Slika je uklonjena.';

  @override
  String get changeImage => 'Promijeni sliku';

  @override
  String get chooseImage => 'Odaberi sliku';

  @override
  String get removeImage => 'Ukloni sliku';

  @override
  String get imageFormatHint => 'JPG ili PNG, najviše 5 MB.';

  @override
  String get cityName => 'Naziv grada';

  @override
  String get addCity => 'Dodaj grad';

  @override
  String get city => 'Grad';

  @override
  String get postalCode => 'Poštanski broj';

  @override
  String get country => 'Država';

  @override
  String get newCity => 'Novi grad';

  @override
  String get nameRequired => 'Naziv *';

  @override
  String get nameLength2to100 => 'Naziv mora imati između 2 i 100 znakova.';

  @override
  String get postalCodeExample => 'npr. 88000';

  @override
  String get postalCodeInvalid => 'Poštanski broj ima 4 do 6 cifara.';

  @override
  String get countryRequired => 'Država *';

  @override
  String get selectCountry => 'Odaberite državu.';

  @override
  String deleteCityQuestion(String name) {
    return 'Obrisati grad $name?\n\nAko ga koriste korisnici, brisanje nije moguće.';
  }

  @override
  String get firstOrLastName => 'Ime ili prezime';

  @override
  String get addGuide => 'Dodaj vodiča';

  @override
  String get fullName => 'Ime i prezime';

  @override
  String get newGuide => 'Novi vodič';

  @override
  String get guide => 'Vodič';

  @override
  String get firstNameRequiredShort => 'Ime *';

  @override
  String get lastNameRequiredShort => 'Prezime *';

  @override
  String get phoneExample => 'npr. 061 234 567';

  @override
  String deleteGuideQuestion(String name) {
    return 'Obrisati vodiča $name?\n\nAko vodi termine aktivnosti, brisanje nije moguće.';
  }

  @override
  String get searchByName => 'Pretraga po nazivu';

  @override
  String get name => 'Naziv';

  @override
  String newLookup(String name) {
    return 'Novo: $name';
  }

  @override
  String deleteLookupQuestion(String name, String usage) {
    return 'Obrisati \"$name\"?\n\nAko se koristi ($usage), brisanje nije moguće.';
  }

  @override
  String get tabRoomTypes => 'Tipovi soba';

  @override
  String get tabRoomAmenities => 'Sadržaji soba';

  @override
  String get tabEquipmentTypes => 'Tipovi opreme';

  @override
  String get tabActivityCategories => 'Kategorije aktivnosti';

  @override
  String get tabPlaceTypes => 'Tipovi mjesta';

  @override
  String get tabGuides => 'Vodiči';

  @override
  String get tabCountries => 'Države';

  @override
  String get tabCities => 'Gradovi';

  @override
  String get roomType => 'Tip sobe';

  @override
  String get roomTypeUsage => 'sobe ovog tipa';

  @override
  String get roomAmenity => 'Sadržaj sobe';

  @override
  String get roomAmenityUsage => 'sobe s ovim sadržajem';

  @override
  String get equipmentType => 'Tip opreme';

  @override
  String get equipmentTypeUsage => 'oprema ovog tipa';

  @override
  String get activityCategory => 'Kategorija aktivnosti';

  @override
  String get activityCategoryUsage => 'aktivnosti u ovoj kategoriji';

  @override
  String get placeType => 'Tip mjesta';

  @override
  String get placeTypeUsage => 'mjesta ovog tipa';

  @override
  String get countryUsage => 'gradovi u ovoj državi';

  @override
  String get newsPublished => 'Novost je objavljena. Sada možete dodati sliku.';

  @override
  String newsScheduled(String date) {
    return 'Novost je zakazana za $date. Sada možete dodati sliku.';
  }

  @override
  String get changesSaved => 'Izmjene su sačuvane.';

  @override
  String get deletingNews => 'Brisanje novosti';

  @override
  String deleteNewsQuestion(String title) {
    return 'Obrisati \"$title\"? Ovo se ne može poništiti.';
  }

  @override
  String get newNews => 'Nova novost';

  @override
  String get titleRequired => 'Naslov *';

  @override
  String get titleLength => 'Naslov mora imati između 3 i 150 znakova.';

  @override
  String get textRequired => 'Tekst *';

  @override
  String get textLength => 'Tekst mora imati između 10 i 4000 znakova.';

  @override
  String publishedAtLabel(String date) {
    return 'Objava: $date';
  }

  @override
  String get now => 'Odmah';

  @override
  String get scheduledHint =>
      'Zakazano: gosti će novost vidjeti tek od odabranog trenutka.';

  @override
  String get immediateHint => 'Gosti vide novost odmah nakon čuvanja.';

  @override
  String authorLabel(String name) {
    return 'Autor: $name';
  }

  @override
  String get saveChanges => 'Sačuvaj izmjene';

  @override
  String get schedule => 'Zakaži';

  @override
  String get publish => 'Objavi';

  @override
  String get image => 'Slika';

  @override
  String get imageAfterSaveNews =>
      'Sliku možete dodati nakon što sačuvate novost.';

  @override
  String get title => 'Naslov';

  @override
  String get author => 'Autor';

  @override
  String get publishDate => 'Datum objave';

  @override
  String get status => 'Status';

  @override
  String get published => 'Objavljeno';

  @override
  String get scheduled => 'Zakazano';

  @override
  String get noComment => 'Bez komentara.';

  @override
  String get deleteReview => 'Obriši recenziju';

  @override
  String get deletingReview => 'Brisanje recenzije';

  @override
  String deleteGuestReviewQuestion(String name) {
    return 'Obrisati recenziju gosta $name? Recenzija nestaje i iz prosječne ocjene.';
  }

  @override
  String get type => 'Vrsta';

  @override
  String ratingRange(int from, int to) {
    return 'Ocjena: $from–$to ★';
  }

  @override
  String get onlyBad => 'Samo loše (1–2★)';

  @override
  String get noReviewsForFilters => 'Nema recenzija za odabrane filtere.';

  @override
  String get rating => 'Ocjena';

  @override
  String get item => 'Stavka';

  @override
  String get comment => 'Komentar';

  @override
  String get guest => 'Gost';

  @override
  String get date => 'Datum';

  @override
  String get noNewsShort => 'Nema novosti.';

  @override
  String get reportPeriod => 'Period izvještaja';

  @override
  String get reportPeriodMax =>
      'Period izvještaja može biti najviše godinu dana.';

  @override
  String get saveReport => 'Sačuvaj izvještaj';

  @override
  String reportSaved(String path) {
    return 'Izvještaj je sačuvan: $path';
  }

  @override
  String get open => 'Otvori';

  @override
  String get periodLabel => 'Period:';

  @override
  String get reportPeriodHint =>
      'Najviše godinu dana. Isti period se koristi za sva tri izvještaja.';

  @override
  String get financialReport => 'Finansijski izvještaj';

  @override
  String get financialReportDescription =>
      'Uplate, povrati i neto prihod po vrsti (smještaj, oprema, aktivnosti) i po mjesecima.';

  @override
  String get occupancyReport => 'Zauzetost smještaja';

  @override
  String get occupancyReportDescription =>
      'Po sobi: zauzete od mogućih noći, popunjenost u %, broj rezervacija, prosječan boravak i prihod.';

  @override
  String get activitiesReport => 'Aktivnosti i ocjene';

  @override
  String get activitiesReportDescription =>
      'Termini, popunjenost i prihod po aktivnosti, te ocjene, favoriti i pregledi mjesta.';

  @override
  String get downloadPdf => 'Preuzmi PDF';

  @override
  String get reportsLanguageNote =>
      'PDF izvještaji se generišu na bosanskom jeziku.';

  @override
  String get modelRetrained => 'Model je ponovo istreniran.';

  @override
  String get tooLittleData => 'Premalo podataka za treniranje modela.';

  @override
  String get modelTrained => 'Model je istreniran i koristi se za preporuke';

  @override
  String get modelNotTrained => 'Model nije istreniran';

  @override
  String lastTraining(String date) {
    return 'Zadnje treniranje: $date. Model se automatski ponovo trenira svakih 6 sati.';
  }

  @override
  String get retrain => 'Ponovo treniraj';

  @override
  String get interactions => 'Interakcija';

  @override
  String get positiveChoices => 'Izbora (pozitivnih)';

  @override
  String get guests => 'Gostiju';

  @override
  String get items => 'Stavki';

  @override
  String recommendationQuality(int k) {
    return 'Kvalitet preporuka (HitRate@$k)';
  }

  @override
  String hitRateExplanation(int k, int count) {
    return 'Koliko često je stvarno izabrana (sakrivena) stavka među top $k preporuka. Evaluirano na $count izbora';
  }

  @override
  String get ourModel => 'Naš model (Matrix Factorization)';

  @override
  String get popularityBaseline => 'Popularnost (svima isto)';

  @override
  String get randomBaseline => 'Slučajan izbor';

  @override
  String selectedParameters(String rank, String lambda, String alpha) {
    return 'Izabrani parametri: rank $rank, λ $lambda, α $alpha';
  }

  @override
  String get recommenderExplanation =>
      'Preporuke koriste one-class Matrix Factorization (ML.NET) nad interakcijama gostiju: recenzijama, favoritima, rezervacijama i pregledima. Gosti bez dovoljno interakcija dobijaju popularne stavke. Detalji su u dokumentu recommender-dokumentacija.md.';

  @override
  String get reason => 'Razlog';

  @override
  String get reasonVisibleToGuest =>
      'Gost će vidjeti razlog u obavijesti i emailu.';

  @override
  String get enterReason => 'Unesite razlog (najmanje 3 znaka).';

  @override
  String get confirmReservationTitle => 'Potvrda rezervacije';

  @override
  String confirmReservationQuestion(String guest, String item) {
    return 'Potvrditi rezervaciju gosta $guest ($item)? Gost će dobiti obavijest.';
  }

  @override
  String get reservationConfirmed => 'Rezervacija je potvrđena.';

  @override
  String get rejectReservationTitle => 'Odbijanje rezervacije';

  @override
  String get rejectReasonExample => 'npr. Soba nije dostupna zbog radova.';

  @override
  String get reservationRejected => 'Rezervacija je odbijena.';

  @override
  String get completeReservationTitle => 'Završetak rezervacije';

  @override
  String completeReservationQuestion(String guest) {
    return 'Označiti rezervaciju gosta $guest kao završenu? Gost će dobiti poziv da ostavi recenziju.';
  }

  @override
  String get reservationCompleted => 'Rezervacija je označena kao završena.';

  @override
  String get cancelReservationTitle => 'Otkazivanje rezervacije';

  @override
  String get cancelReasonExample => 'npr. Loši vremenski uslovi.';

  @override
  String get refundAutomatic => 'Uplaćeni iznos se automatski vraća gostu.';

  @override
  String get quantity => 'Količina';

  @override
  String get guestNote => 'Napomena gosta';

  @override
  String get statusHistory => 'Historija statusa';

  @override
  String get reject => 'Odbij';

  @override
  String get guestNotPaid => 'Gost još nije platio rezervaciju.';

  @override
  String get cancelAction => 'Otkaži';

  @override
  String get markCompleted => 'Označi kao završenu';

  @override
  String noActionsForStatus(String status) {
    return 'Za rezervaciju sa statusom \"$status\" nema dostupnih akcija.';
  }

  @override
  String get rejectCancelNotifies =>
      'Odbijanje ili otkazivanje šalje gostu obavijest i email.';

  @override
  String createdWithStatus(String status) {
    return 'Kreirana ($status)';
  }

  @override
  String get selectPeriod => 'Odaberite period';

  @override
  String get noReservationsForFilters =>
      'Nema rezervacija za odabrane filtere.';

  @override
  String get paid => 'Plaćeno';

  @override
  String get guestNameHint => 'Ime ili prezime gosta';

  @override
  String get allTypes => 'Sve vrste';

  @override
  String get periodFilter => 'Period';

  @override
  String get clearFilters => 'Očisti filtere';

  @override
  String get roomAddedAddImages => 'Soba je dodana. Sada možete dodati slike.';

  @override
  String get deletingRoom => 'Brisanje sobe';

  @override
  String deleteRoomQuestion(String name) {
    return 'Obrisati sobu \"$name\"? Ovo se ne može poništiti.\n\nAko soba ima rezervacije, brisanje nije moguće. Tada je umjesto toga označite kao neaktivnu.';
  }

  @override
  String get newRoom => 'Nova soba';

  @override
  String get images => 'Slike';

  @override
  String get imagesHint =>
      'JPG ili PNG, najviše 5 MB. Naslovna slika se prikazuje u listi i na mobilnoj aplikaciji.';

  @override
  String get imagesAfterSaveRoom =>
      'Slike možete dodati nakon što sačuvate sobu.';

  @override
  String get addRoom => 'Dodaj sobu';

  @override
  String get nameLength3to100 => 'Naziv mora imati između 3 i 100 znakova.';

  @override
  String get nameLength3to150 => 'Naziv mora imati između 3 i 150 znakova.';

  @override
  String get roomTypeRequired => 'Tip sobe *';

  @override
  String get selectRoomType => 'Odaberite tip sobe.';

  @override
  String get capacityPeopleRequired => 'Kapacitet (osoba) *';

  @override
  String get between1and10People => 'Između 1 i 10 osoba.';

  @override
  String get areaRequired => 'Površina (m²) *';

  @override
  String get between5and200m2 => 'Između 5 i 200 m².';

  @override
  String get pricePerNightRequired => 'Cijena po noći (KM) *';

  @override
  String get priceExample => 'npr. 90,50';

  @override
  String get priceNightRange => 'Između 1 i 10.000 KM, npr. 90,50.';

  @override
  String get roomAmenities => 'Sadržaji sobe';

  @override
  String get activeFemale => 'Aktivna';

  @override
  String get inactiveRoomsHint =>
      'Neaktivne sobe gosti ne vide i ne mogu ih rezervisati.';

  @override
  String get roomName => 'Naziv sobe';

  @override
  String get allTypesFilter => 'Svi tipovi';

  @override
  String get activePlural => 'Aktivne';

  @override
  String get inactivePlural => 'Neaktivne';

  @override
  String get noRooms => 'Nema soba za prikaz.';

  @override
  String get typeShort => 'Tip';

  @override
  String get capacity => 'Kapacitet';

  @override
  String get area => 'Površina';

  @override
  String get pricePerNightHeader => 'Cijena / noć';

  @override
  String get inactiveFemale => 'Neaktivna';

  @override
  String get equipmentAddedAddImage =>
      'Oprema je dodana. Sada možete dodati sliku.';

  @override
  String get deletingEquipment => 'Brisanje opreme';

  @override
  String deleteEquipmentQuestion(String name) {
    return 'Obrisati \"$name\"? Ovo se ne može poništiti.\n\nAko oprema ima rezervacije, brisanje nije moguće. Tada je umjesto toga označite kao neaktivnu.';
  }

  @override
  String get newEquipment => 'Nova oprema';

  @override
  String get equipmentTypeRequired => 'Tip opreme *';

  @override
  String get selectEquipmentType => 'Odaberite tip opreme.';

  @override
  String get peoplePerPieceRequired => 'Osoba po komadu *';

  @override
  String get peoplePerPieceHint => 'npr. 2 za kajak dvosjed';

  @override
  String get between1and4 => 'Između 1 i 4.';

  @override
  String get totalPiecesRequired => 'Ukupno komada *';

  @override
  String get totalPiecesHint => 'koliko ih imate na raspolaganju';

  @override
  String get between1and100 => 'Između 1 i 100.';

  @override
  String get firstHourKmRequired => 'Prvi sat (KM) *';

  @override
  String get additionalHourKmRequired => 'Svaki sljedeći sat (KM) *';

  @override
  String get fullDayKmRequired => 'Cijeli dan (KM) *';

  @override
  String get inactiveEquipmentHint =>
      'Neaktivnu opremu gosti ne vide i ne mogu je rezervisati.';

  @override
  String get imageAfterSaveEquipment =>
      'Sliku možete dodati nakon što sačuvate opremu.';

  @override
  String get addEquipment => 'Dodaj opremu';

  @override
  String get between1and1000Km => 'Između 1 i 1.000 KM.';

  @override
  String fullDayShort(String price) {
    return 'cijeli dan: $price';
  }

  @override
  String guestPaysPerPiece(String prices) {
    return 'Gost plaća po komadu: $prices';
  }

  @override
  String get equipmentName => 'Naziv opreme';

  @override
  String get noEquipment => 'Nema opreme za prikaz.';

  @override
  String get peoplePerPieceShort => 'Osoba / kom.';

  @override
  String get pieces => 'Komada';

  @override
  String get firstHour => 'Prvi sat';

  @override
  String get additionalHour => 'Sljedeći sat';

  @override
  String get fullDay => 'Cijeli dan';

  @override
  String placeAdded(String km) {
    return 'Mjesto je dodano ($km km od smještaja). Sada možete dodati slike.';
  }

  @override
  String get deletingPlace => 'Brisanje mjesta';

  @override
  String deletePlaceQuestion(String name) {
    return 'Obrisati \"$name\"? Ovo se ne može poništiti.\n\nAko mjesto ima recenzije ili je u favoritima gostiju, brisanje nije moguće. Tada ga označite kao neaktivno.';
  }

  @override
  String get newPlace => 'Novo mjesto';

  @override
  String get placeTypeRequired => 'Tip mjesta *';

  @override
  String get selectPlaceType => 'Odaberite tip mjesta.';

  @override
  String get addressSettlement => 'Adresa / naselje';

  @override
  String get addressExample => 'npr. Donja Drežnica';

  @override
  String get latitudeRequired => 'Geografska širina *';

  @override
  String get longitudeRequired => 'Geografska dužina *';

  @override
  String get selectLocationOnMap => 'Odaberite lokaciju na karti.';

  @override
  String distanceFromAccommodation(String km) {
    return 'Udaljenost od smještaja: $km km';
  }

  @override
  String get activeNeuter => 'Aktivno';

  @override
  String get inactivePlacesHint => 'Neaktivna mjesta gosti ne vide.';

  @override
  String get imagesAfterSavePlace =>
      'Slike možete dodati nakon što sačuvate mjesto.';

  @override
  String get addPlace => 'Dodaj mjesto';

  @override
  String get placeName => 'Naziv mjesta';

  @override
  String get allNeuter => 'Sva';

  @override
  String get noPlaces => 'Nema mjesta za prikaz.';

  @override
  String get address => 'Adresa';

  @override
  String get distance => 'Udaljenost';

  @override
  String get inactiveNeuter => 'Neaktivno';

  @override
  String get activityName => 'Naziv aktivnosti';

  @override
  String get category => 'Kategorija';

  @override
  String get allCategories => 'Sve kategorije';

  @override
  String get addActivity => 'Dodaj aktivnost';

  @override
  String get noActivities => 'Nema aktivnosti za prikaz.';

  @override
  String get duration => 'Trajanje';

  @override
  String get maxPeople => 'Max osoba';

  @override
  String get pricePerPersonHeader => 'Cijena / osobi';

  @override
  String get nextSlotHeader => 'Sljedeći termin';

  @override
  String get noSlots => 'Nema termina';

  @override
  String get activityAdded =>
      'Aktivnost je dodana. Sada možete dodati sliku i termine.';

  @override
  String get deletingActivity => 'Brisanje aktivnosti';

  @override
  String deleteActivityQuestion(String name) {
    return 'Obrisati \"$name\"? Ovo se ne može poništiti.\n\nAko aktivnost ima termine ili rezervacije, brisanje nije moguće. Tada je umjesto toga označite kao neaktivnu.';
  }

  @override
  String get newActivity => 'Nova aktivnost';

  @override
  String get categoryRequired => 'Kategorija *';

  @override
  String get selectCategory => 'Odaberite kategoriju.';

  @override
  String get durationMinutesRequired => 'Trajanje (minuta) *';

  @override
  String get durationHint => 'npr. 180 = 3 sata';

  @override
  String get between30and720Minutes => 'Između 30 i 720 minuta.';

  @override
  String get maxParticipantsRequired => 'Max učesnika *';

  @override
  String get between1and50 => 'Između 1 i 50.';

  @override
  String get pricePerPersonRequired => 'Cijena po osobi (KM) *';

  @override
  String get meetingPoint => 'Mjesto okupljanja';

  @override
  String get meetingPointExample => 'npr. Plaža ispred smještaja';

  @override
  String get inactiveActivityHint =>
      'Neaktivnu aktivnost gosti ne vide i ne mogu je rezervisati.';

  @override
  String get imageAfterSaveActivity =>
      'Sliku možete dodati nakon što sačuvate aktivnost.';

  @override
  String get slotsAfterSaveActivity =>
      'Termine možete dodati nakon što sačuvate aktivnost.';

  @override
  String get slots => 'Termini';

  @override
  String get onlyUpcoming => 'Samo budući';

  @override
  String get addSlot => 'Dodaj termin';

  @override
  String get addGuideFirst =>
      'Prvo dodajte bar jednog vodiča (Šifarnici → Vodiči).';

  @override
  String get noUpcomingSlots => 'Nema budućih termina.';

  @override
  String get noSlotsShort => 'Nema termina.';

  @override
  String get start => 'Početak';

  @override
  String get end => 'Kraj';

  @override
  String get booked => 'Zauzeto';

  @override
  String get available => 'Slobodno';

  @override
  String get selectStartDateTime => 'Odaberite datum i vrijeme početka.';

  @override
  String get slotMustBeFuture => 'Termin mora biti u budućnosti.';

  @override
  String get deletingSlot => 'Brisanje termina';

  @override
  String deleteSlotQuestion(String date) {
    return 'Obrisati termin $date?';
  }

  @override
  String get slot => 'Termin';

  @override
  String get newSlot => 'Novi termin';

  @override
  String get slotStartedCannotChange =>
      'Termin je već počeo ili završio i ne može se mijenjati.';

  @override
  String slotHasBookings(int count) {
    return 'Termin ima $count rezervisanih mjesta. Vrijeme se ne može mijenjati, a kapacitet ne može biti manji od $count.';
  }

  @override
  String get dateRequired => 'Datum *';

  @override
  String get timeRequired => 'Vrijeme *';

  @override
  String endsAt(String time, String duration) {
    return 'Završava u $time (trajanje $duration).';
  }

  @override
  String get capacityRequired => 'Kapacitet *';

  @override
  String capacityMaxHint(int max) {
    return 'Najviše $max (maksimum aktivnosti)';
  }

  @override
  String betweenRange(int min, int max) {
    return 'Između $min i $max.';
  }

  @override
  String get guideRequired => 'Vodič *';

  @override
  String get selectGuide => 'Odaberite vodiča.';

  @override
  String get selectAtLeastOneRole => 'Odaberite barem jednu ulogu.';

  @override
  String get userLoggedOutEverywhere =>
      'Korisnik je odjavljen sa svih uređaja.';

  @override
  String get userAdded => 'Korisnik je dodan.';

  @override
  String get deletingUser => 'Brisanje korisnika';

  @override
  String deleteUserQuestion(String name) {
    return 'Obrisati korisnika $name? Ovo se ne može poništiti.\n\nAko korisnik ima rezervacije, recenzije ili plaćanja, brisanje nije moguće. Tada ga umjesto toga deaktivirajte.';
  }

  @override
  String get roleGuest => 'Gost';

  @override
  String get newUser => 'Novi korisnik';

  @override
  String get personalData => 'Lični podaci';

  @override
  String get access => 'Pristup';

  @override
  String get leaveEmptyPassword => 'Ostavite prazno ako ne mijenjate lozinku.';

  @override
  String get confirmPassword => 'Potvrda lozinke *';

  @override
  String get confirmNewPasswordOptional => 'Potvrda nove lozinke';

  @override
  String get rolesRequired => 'Uloge *';

  @override
  String get activeMasculine => 'Aktivan';

  @override
  String get cannotDeactivateSelf => 'Ne možete deaktivirati vlastiti račun.';

  @override
  String get inactiveUserHint =>
      'Neaktivan korisnik se ne može prijaviti, a postojeće sesije se odmah prekidaju.';

  @override
  String registeredAt(String date) {
    return 'Registrovan: $date';
  }

  @override
  String get addUser => 'Dodaj korisnika';

  @override
  String get userSearchHint => 'Ime, korisničko ime ili e-mail';

  @override
  String get role => 'Uloga';

  @override
  String get allRoles => 'Sve uloge';

  @override
  String get allMasculine => 'Svi';

  @override
  String get activeMasculinePlural => 'Aktivni';

  @override
  String get inactiveMasculinePlural => 'Neaktivni';

  @override
  String get noUsers => 'Nema korisnika za prikaz.';

  @override
  String get roles => 'Uloge';

  @override
  String get inactiveMasculine => 'Neaktivan';
}
