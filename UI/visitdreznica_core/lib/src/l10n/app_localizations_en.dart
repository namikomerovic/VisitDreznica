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

  @override
  String get registration => 'Sign up';

  @override
  String get firstNameRequired => 'First name *';

  @override
  String get lastNameRequired => 'Last name *';

  @override
  String get emailRequiredLabel => 'E-mail *';

  @override
  String get phone => 'Phone';

  @override
  String get cityRequiredLabel => 'City *';

  @override
  String get usernameRequiredLabel => 'Username *';

  @override
  String get passwordRequiredLabel => 'Password *';

  @override
  String get passwordConfirmRequiredLabel => 'Confirm password *';

  @override
  String get enterFirstName => 'Enter your first name (max. 50 characters).';

  @override
  String get enterLastName => 'Enter your last name (max. 50 characters).';

  @override
  String get citiesLoadError =>
      'Cities could not be loaded. Check your connection.';

  @override
  String get selectCity => 'Select a city.';

  @override
  String get passwordHint => 'At least 8 characters, a letter and a digit.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get createAccount => 'Create account';

  @override
  String resetCodeSent(String email) {
    return 'If an account with the address $email exists, we have sent it a six-digit code. Check your inbox and spam folder.';
  }

  @override
  String get forgottenPassword => 'Forgotten password';

  @override
  String get enterCodeAndNewPassword =>
      'Enter the code from the e-mail and a new password.';

  @override
  String get enterAccountEmail =>
      'Enter the e-mail address of your account. We will send you a code to set a new password.';

  @override
  String get email => 'E-mail';

  @override
  String get sendCode => 'Send code';

  @override
  String get codeFromEmail => 'Code from e-mail';

  @override
  String get codeSixDigits => 'The code consists of exactly 6 digits.';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get setNewPassword => 'Set new password';

  @override
  String get resendCode => 'Didn\'t get the code? Send again';

  @override
  String helloName(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeTitle => 'Discover Drežnica.';

  @override
  String get homeLocation => 'Drežnica, Bosnia and Herzegovina';

  @override
  String get news => 'News';

  @override
  String get noNews => 'There is no news at the moment.';

  @override
  String get searchHint => 'Search accommodation, equipment, activities…';

  @override
  String get heroTitle => 'Small place.\nBig experiences.';

  @override
  String get heroSubtitle => 'River, canyon and mountain within reach.';

  @override
  String get exploreOffer => 'Explore the offer';

  @override
  String get recommendedForYou => 'Recommended for you';

  @override
  String get popularAmongGuests => 'Popular among guests';

  @override
  String get recommendationsHint =>
      'Rate or save what you like and we will recommend things to your taste.';

  @override
  String get newsItem => 'News';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites.';

  @override
  String get addedToFavorites => 'Added to favorites.';

  @override
  String get noRatingsYet => 'No ratings yet';

  @override
  String get mapsAppError => 'The maps app could not be opened.';

  @override
  String get reserve => 'Book';

  @override
  String get view => 'View';

  @override
  String upToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'up to $count people',
      one: 'up to $count person',
    );
    return '$_temp0';
  }

  @override
  String upToPeopleCapital(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Up to $count people',
      one: 'Up to $count person',
    );
    return '$_temp0';
  }

  @override
  String peoplePerPiece(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people per piece',
      one: '$count person per piece',
    );
    return '$_temp0';
  }

  @override
  String pricePerNight(String price) {
    return '$price / night';
  }

  @override
  String pricePerHourFrom(String price) {
    return 'from $price / hour';
  }

  @override
  String pricePerPerson(String price) {
    return '$price / person';
  }

  @override
  String get noSlotsNow => 'No slots at the moment';

  @override
  String nextSlot(String date) {
    return 'Next slot: $date';
  }

  @override
  String kmFromAccommodation(String km) {
    return '$km km from the accommodation';
  }

  @override
  String searchType(String type) {
    return 'Search: $type';
  }

  @override
  String get showOnMap => 'Show on map';

  @override
  String totalPieces(int count) {
    return 'Total pieces: $count';
  }

  @override
  String firstHourPrice(String price) {
    return 'First hour: $price';
  }

  @override
  String additionalHourPrice(String price) {
    return 'Each additional hour: $price';
  }

  @override
  String fullDayPrice(String price) {
    return 'Full day: $price';
  }

  @override
  String maxParticipants(int count) {
    return 'Up to $count participants';
  }

  @override
  String meetingPointLabel(String place) {
    return 'Meeting point: $place';
  }

  @override
  String get detailsLoadError => 'The details could not be loaded.';

  @override
  String get description => 'Description';

  @override
  String get amenities => 'Amenities';

  @override
  String get location => 'Location';

  @override
  String get upcomingSlots => 'Upcoming slots';

  @override
  String get noScheduledSlots => 'There are no scheduled slots at the moment.';

  @override
  String guideName(String name) {
    return 'Guide: $name';
  }

  @override
  String get slotFull => 'Full';

  @override
  String spotsFree(int count) {
    return 'Available: $count';
  }

  @override
  String get openMap => 'Open map';

  @override
  String get directions => 'Directions';

  @override
  String get ratingLabels => 'Tap a star|Bad|Poor|Good|Very good|Excellent';

  @override
  String get selectRating => 'Select a rating from 1 to 5.';

  @override
  String get newReview => 'New review';

  @override
  String get editReview => 'Edit review';

  @override
  String get commentOptional => 'Comment (optional)';

  @override
  String get thanksForReview => 'Thank you for your review!';

  @override
  String get reviewUpdated => 'Your review has been updated.';

  @override
  String get deleteReviewQuestion => 'Delete the review?';

  @override
  String get cannotBeUndone => 'This action cannot be undone.';

  @override
  String get reviewDeleted => 'The review has been deleted.';

  @override
  String get reviews => 'Reviews';

  @override
  String get yourReview => 'Your review';

  @override
  String get writeReview => 'Write a review';

  @override
  String get reviewAfterReservation =>
      'You can leave a review after a completed reservation.';

  @override
  String get loading => 'Loading...';

  @override
  String get showMoreReviews => 'Show more reviews';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '$count review',
    );
    return '$_temp0';
  }

  @override
  String get noReviewsYet => 'No reviews yet.';

  @override
  String get placesMap => 'Places map';

  @override
  String get accommodation => 'Accommodation';

  @override
  String get details => 'Details';

  @override
  String get activityBooking => 'Activity booking';

  @override
  String perPersonAndDuration(String price, String duration) {
    return '$price per person · $duration';
  }

  @override
  String get selectSlot => 'Select a slot';

  @override
  String get numberOfPeople => 'Number of people';

  @override
  String meetingPointFull(String place) {
    return 'Meeting point: $place';
  }

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '$count person',
    );
    return '$_temp0';
  }

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '$count night',
    );
    return '$_temp0';
  }

  @override
  String get reservation => 'Reservation';

  @override
  String get paymentSucceeded => 'Payment successful!';

  @override
  String get reservationAwaitsPayment => 'The reservation is awaiting payment';

  @override
  String get paidAwaitingConfirmation =>
      'The reservation is paid and awaiting confirmation. You will get a notification and an e-mail as soon as we confirm it.';

  @override
  String get savedNotPaid =>
      'The reservation is saved but not paid. If you do not pay within 30 minutes, it is cancelled automatically.';

  @override
  String get period => 'Period';

  @override
  String get amount => 'Amount';

  @override
  String get payNow => 'Pay now';

  @override
  String get done => 'Done';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get reserveAndPay => 'Book and pay';

  @override
  String get paymentConfirmation => 'Payment confirmation';

  @override
  String continueToCardPayment(String amount) {
    return 'Continue to card payment of $amount?';
  }

  @override
  String get pay => 'Pay';

  @override
  String get rentalDay => 'Rental day';

  @override
  String get equipmentRental => 'Equipment rental';

  @override
  String equipmentPricing(String first, String additional, String fullDay) {
    return 'First hour $first, each additional $additional, full day at most $fullDay';
  }

  @override
  String get pickupDayAndTime => 'Pick-up day and time';

  @override
  String get from => 'From';

  @override
  String get durationHours => 'Duration (hours)';

  @override
  String get numberOfPieces => 'Number of pieces';

  @override
  String returnAt(String date) {
    return 'Return: $date';
  }

  @override
  String onlyPiecesAvailable(int count) {
    return 'Only $count pcs. are available in that period. Reduce the number of pieces or change the time.';
  }

  @override
  String pricePerPieceHours(int hours) {
    return 'Price per piece ($hours h)';
  }

  @override
  String get selectArrivalDeparture => 'Select arrival and departure';

  @override
  String get roomBooking => 'Room booking';

  @override
  String roomPriceCapacity(String price, String capacity) {
    return '$price / night · $capacity';
  }

  @override
  String get stayPeriod => 'Stay period';

  @override
  String get selectDates => 'Select dates';

  @override
  String get bookedDaysDisabled => 'Booked days are disabled in the calendar.';

  @override
  String get numberOfGuests => 'Number of guests';

  @override
  String get touristTax => 'Tourist tax';

  @override
  String get paymentFailed => 'The payment failed. Please try again.';

  @override
  String get paymentSucceededShort => 'Payment successful.';

  @override
  String get cancelledRefund =>
      'The reservation has been cancelled. The money is being refunded to your card.';

  @override
  String get cancelledNoRefund => 'The reservation has been cancelled.';

  @override
  String get reservationDetails => 'Reservation details';

  @override
  String get payment => 'Payment';

  @override
  String get paidByCard => 'Paid by card';

  @override
  String get notPaid => 'Not paid';

  @override
  String get created => 'Created';

  @override
  String get note => 'Note';

  @override
  String payUntil(String time) {
    return 'Pay for the reservation by $time, otherwise it is cancelled automatically.';
  }

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String yourRatingEdit(int rating) {
    return 'Your rating: $rating★ · edit';
  }

  @override
  String get rate => 'Rate';

  @override
  String viewItem(String name) {
    return 'View: $name';
  }

  @override
  String get cancelReservation => 'Cancel reservation';

  @override
  String get cancelPolicy =>
      'A confirmed reservation can be cancelled no later than 24 hours before it starts. The paid amount is refunded to your card.';

  @override
  String get history => 'History';

  @override
  String get cancelReservationQuestion => 'Cancel the reservation?';

  @override
  String get refundToCard => 'The paid amount will be refunded to your card.';

  @override
  String get noRefundNotPaid =>
      'The reservation has not been paid yet, so there is no refund.';

  @override
  String get reasonOptional => 'Reason (optional)';

  @override
  String get filterActive => 'Active';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get filterCancelled => 'Cancelled';

  @override
  String get noActiveReservations => 'You have no active bookings.';

  @override
  String get noCompletedReservations => 'You have no completed bookings yet.';

  @override
  String get noCancelledReservations => 'You have no cancelled bookings.';

  @override
  String get awaitingPayment => 'Awaiting payment';

  @override
  String get noFavoritesYet => 'You have no favorites yet.';

  @override
  String get favoritesHint =>
      'Tap ♥ on a room, equipment, activity or place to save it here.';

  @override
  String savedOn(String type, String date) {
    return '$type · saved $date';
  }

  @override
  String get changePassword => 'Change password';

  @override
  String get currentPasswordRequired => 'Current password *';

  @override
  String get enterCurrentPassword => 'Enter your current password.';

  @override
  String get newPasswordRequired => 'New password *';

  @override
  String get newPasswordMustDiffer =>
      'The new password must be different from the current one.';

  @override
  String get confirmNewPasswordRequired => 'Confirm new password *';

  @override
  String get logoutOtherDevices =>
      'After the change you will be logged out on all other devices.';

  @override
  String get editProfile => 'Edit profile';

  @override
  String usernameCannotChange(String username) {
    return 'The username (@$username) cannot be changed.';
  }

  @override
  String get profileSaved => 'Profile saved.';

  @override
  String get passwordChanged => 'Your password has been changed.';

  @override
  String get pickFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String errorTryAgain(String error) {
    return '$error Try again.';
  }

  @override
  String get phoneNotEntered => 'No phone number';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get noNotifications => 'You have no notifications.';

  @override
  String get showOlder => 'Show older';

  @override
  String get deleting => 'Delete';

  @override
  String get deleteThisRecord => 'Delete this record?';

  @override
  String get imageAdded => 'The image has been added.';

  @override
  String get deletingImage => 'Delete image';

  @override
  String get deleteCoverImageQuestion =>
      'Delete the cover image? The next image will automatically become the cover.';

  @override
  String get deleteImageQuestion => 'Delete this image?';

  @override
  String get imageDeleted => 'The image has been deleted.';

  @override
  String get cover => 'Cover';

  @override
  String get imageOptions => 'Image options';

  @override
  String get coverChanged => 'The cover image has been changed.';

  @override
  String get setAsCover => 'Set as cover';

  @override
  String get addImage => 'Add image';

  @override
  String get imageMax5Mb => 'The image can be at most 5 MB.';

  @override
  String get clickMapToSetLocation => 'Click on the map to set the location';

  @override
  String get markAllReadShort => 'Mark all read';

  @override
  String get onlyUnread => 'Unread only';

  @override
  String get noUnreadNotifications => 'No unread notifications.';

  @override
  String get noNotificationsShort => 'No notifications.';

  @override
  String get loadMore => 'Load more';

  @override
  String get noData => 'No data to display.';

  @override
  String shownRange(int first, int last, int total) {
    return 'Showing $first–$last of $total';
  }

  @override
  String get rowsPerPage => 'Rows per page:';

  @override
  String get previousPage => 'Previous page';

  @override
  String pageOf(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get nextPage => 'Next page';

  @override
  String get imageSaved => 'The image has been saved.';

  @override
  String get removingImage => 'Remove image';

  @override
  String get removeImageQuestion => 'Remove the image?';

  @override
  String get remove => 'Remove';

  @override
  String get imageRemoved => 'The image has been removed.';

  @override
  String get changeImage => 'Change image';

  @override
  String get chooseImage => 'Choose image';

  @override
  String get removeImage => 'Remove image';

  @override
  String get imageFormatHint => 'JPG or PNG, at most 5 MB.';

  @override
  String get cityName => 'City name';

  @override
  String get addCity => 'Add city';

  @override
  String get city => 'City';

  @override
  String get postalCode => 'Postal code';

  @override
  String get country => 'Country';

  @override
  String get newCity => 'New city';

  @override
  String get nameRequired => 'Name *';

  @override
  String get nameLength2to100 => 'Name must have between 2 and 100 characters.';

  @override
  String get postalCodeExample => 'e.g. 88000';

  @override
  String get postalCodeInvalid => 'A postal code has 4 to 6 digits.';

  @override
  String get countryRequired => 'Country *';

  @override
  String get selectCountry => 'Select a country.';

  @override
  String deleteCityQuestion(String name) {
    return 'Delete the city $name?\n\nIf users are assigned to it, it cannot be deleted.';
  }

  @override
  String get firstOrLastName => 'First or last name';

  @override
  String get addGuide => 'Add guide';

  @override
  String get fullName => 'Full name';

  @override
  String get newGuide => 'New guide';

  @override
  String get guide => 'Guide';

  @override
  String get firstNameRequiredShort => 'First name *';

  @override
  String get lastNameRequiredShort => 'Last name *';

  @override
  String get phoneExample => 'e.g. 061 234 567';

  @override
  String deleteGuideQuestion(String name) {
    return 'Delete the guide $name?\n\nIf they lead activity slots, they cannot be deleted.';
  }

  @override
  String get searchByName => 'Search by name';

  @override
  String get name => 'Name';

  @override
  String newLookup(String name) {
    return 'New: $name';
  }

  @override
  String deleteLookupQuestion(String name, String usage) {
    return 'Delete \"$name\"?\n\nIf it is in use ($usage), it cannot be deleted.';
  }

  @override
  String get tabRoomTypes => 'Room types';

  @override
  String get tabRoomAmenities => 'Room amenities';

  @override
  String get tabEquipmentTypes => 'Equipment types';

  @override
  String get tabActivityCategories => 'Activity categories';

  @override
  String get tabPlaceTypes => 'Place types';

  @override
  String get tabGuides => 'Guides';

  @override
  String get tabCountries => 'Countries';

  @override
  String get tabCities => 'Cities';

  @override
  String get roomType => 'Room type';

  @override
  String get roomTypeUsage => 'rooms of this type';

  @override
  String get roomAmenity => 'Room amenity';

  @override
  String get roomAmenityUsage => 'rooms with this amenity';

  @override
  String get equipmentType => 'Equipment type';

  @override
  String get equipmentTypeUsage => 'equipment of this type';

  @override
  String get activityCategory => 'Activity category';

  @override
  String get activityCategoryUsage => 'activities in this category';

  @override
  String get placeType => 'Place type';

  @override
  String get placeTypeUsage => 'places of this type';

  @override
  String get countryUsage => 'cities in this country';

  @override
  String get newsPublished =>
      'The news item is published. You can now add an image.';

  @override
  String newsScheduled(String date) {
    return 'The news item is scheduled for $date. You can now add an image.';
  }

  @override
  String get changesSaved => 'Changes saved.';

  @override
  String get deletingNews => 'Delete news item';

  @override
  String deleteNewsQuestion(String title) {
    return 'Delete \"$title\"? This cannot be undone.';
  }

  @override
  String get newNews => 'New news item';

  @override
  String get titleRequired => 'Title *';

  @override
  String get titleLength => 'Title must have between 3 and 150 characters.';

  @override
  String get textRequired => 'Text *';

  @override
  String get textLength => 'Text must have between 10 and 4000 characters.';

  @override
  String publishedAtLabel(String date) {
    return 'Publish: $date';
  }

  @override
  String get now => 'Now';

  @override
  String get scheduledHint =>
      'Scheduled: guests will see the news only from the selected moment.';

  @override
  String get immediateHint => 'Guests see the news right after saving.';

  @override
  String authorLabel(String name) {
    return 'Author: $name';
  }

  @override
  String get saveChanges => 'Save changes';

  @override
  String get schedule => 'Schedule';

  @override
  String get publish => 'Publish';

  @override
  String get image => 'Image';

  @override
  String get imageAfterSaveNews =>
      'You can add an image after you save the news item.';

  @override
  String get title => 'Title';

  @override
  String get author => 'Author';

  @override
  String get publishDate => 'Publish date';

  @override
  String get status => 'Status';

  @override
  String get published => 'Published';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get noComment => 'No comment.';

  @override
  String get deleteReview => 'Delete review';

  @override
  String get deletingReview => 'Delete review';

  @override
  String deleteGuestReviewQuestion(String name) {
    return 'Delete the review by $name? It will also be removed from the average rating.';
  }

  @override
  String get type => 'Type';

  @override
  String ratingRange(int from, int to) {
    return 'Rating: $from–$to ★';
  }

  @override
  String get onlyBad => 'Only bad (1–2★)';

  @override
  String get noReviewsForFilters => 'No reviews for the selected filters.';

  @override
  String get rating => 'Rating';

  @override
  String get item => 'Item';

  @override
  String get comment => 'Comment';

  @override
  String get guest => 'Guest';

  @override
  String get date => 'Date';

  @override
  String get noNewsShort => 'No news.';

  @override
  String get reportPeriod => 'Report period';

  @override
  String get reportPeriodMax => 'The report period can be at most one year.';

  @override
  String get saveReport => 'Save report';

  @override
  String reportSaved(String path) {
    return 'The report has been saved: $path';
  }

  @override
  String get open => 'Open';

  @override
  String get periodLabel => 'Period:';

  @override
  String get reportPeriodHint =>
      'At most one year. The same period is used for all three reports.';

  @override
  String get financialReport => 'Financial report';

  @override
  String get financialReportDescription =>
      'Payments, refunds and net revenue by type (accommodation, equipment, activities) and by month.';

  @override
  String get occupancyReport => 'Accommodation occupancy';

  @override
  String get occupancyReportDescription =>
      'Per room: booked of possible nights, occupancy in %, number of reservations, average stay and revenue.';

  @override
  String get activitiesReport => 'Activities and ratings';

  @override
  String get activitiesReportDescription =>
      'Slots, occupancy and revenue per activity, plus ratings, favorites and place views.';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get reportsLanguageNote => 'PDF reports are generated in Bosnian.';

  @override
  String get modelRetrained => 'The model has been retrained.';

  @override
  String get tooLittleData => 'Not enough data to train the model.';

  @override
  String get modelTrained =>
      'The model is trained and used for recommendations';

  @override
  String get modelNotTrained => 'The model is not trained';

  @override
  String lastTraining(String date) {
    return 'Last training: $date. The model is retrained automatically every 6 hours.';
  }

  @override
  String get retrain => 'Retrain';

  @override
  String get interactions => 'Interactions';

  @override
  String get positiveChoices => 'Choices (positive)';

  @override
  String get guests => 'Guests';

  @override
  String get items => 'Items';

  @override
  String recommendationQuality(int k) {
    return 'Recommendation quality (HitRate@$k)';
  }

  @override
  String hitRateExplanation(int k, int count) {
    return 'How often the actually chosen (hidden) item is among the top $k recommendations. Evaluated on $count choices';
  }

  @override
  String get ourModel => 'Our model (Matrix Factorization)';

  @override
  String get popularityBaseline => 'Popularity (same for everyone)';

  @override
  String get randomBaseline => 'Random choice';

  @override
  String selectedParameters(String rank, String lambda, String alpha) {
    return 'Selected parameters: rank $rank, λ $lambda, α $alpha';
  }

  @override
  String get recommenderExplanation =>
      'Recommendations use one-class Matrix Factorization (ML.NET) over guest interactions: reviews, favorites, reservations and views. Guests without enough interactions get popular items. Details are in recommender-dokumentacija.md.';

  @override
  String get reason => 'Reason';

  @override
  String get reasonVisibleToGuest =>
      'The guest will see the reason in the notification and e-mail.';

  @override
  String get enterReason => 'Enter a reason (at least 3 characters).';

  @override
  String get confirmReservationTitle => 'Confirm reservation';

  @override
  String confirmReservationQuestion(String guest, String item) {
    return 'Confirm the reservation of $guest ($item)? The guest will be notified.';
  }

  @override
  String get reservationConfirmed => 'The reservation has been confirmed.';

  @override
  String get rejectReservationTitle => 'Reject reservation';

  @override
  String get rejectReasonExample =>
      'e.g. The room is unavailable due to renovation.';

  @override
  String get reservationRejected => 'The reservation has been rejected.';

  @override
  String get completeReservationTitle => 'Complete reservation';

  @override
  String completeReservationQuestion(String guest) {
    return 'Mark the reservation of $guest as completed? The guest will be invited to leave a review.';
  }

  @override
  String get reservationCompleted =>
      'The reservation has been marked as completed.';

  @override
  String get cancelReservationTitle => 'Cancel reservation';

  @override
  String get cancelReasonExample => 'e.g. Bad weather conditions.';

  @override
  String get refundAutomatic =>
      'The paid amount is automatically refunded to the guest.';

  @override
  String get quantity => 'Quantity';

  @override
  String get guestNote => 'Guest note';

  @override
  String get statusHistory => 'Status history';

  @override
  String get reject => 'Reject';

  @override
  String get guestNotPaid => 'The guest has not paid the reservation yet.';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get markCompleted => 'Mark as completed';

  @override
  String noActionsForStatus(String status) {
    return 'No actions are available for a reservation with status \"$status\".';
  }

  @override
  String get rejectCancelNotifies =>
      'Rejecting or cancelling sends the guest a notification and an e-mail.';

  @override
  String createdWithStatus(String status) {
    return 'Created ($status)';
  }

  @override
  String get selectPeriod => 'Select a period';

  @override
  String get noReservationsForFilters =>
      'No reservations for the selected filters.';

  @override
  String get paid => 'Paid';

  @override
  String get guestNameHint => 'Guest first or last name';

  @override
  String get allTypes => 'All types';

  @override
  String get periodFilter => 'Period';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get roomAddedAddImages =>
      'The room has been added. You can now add images.';

  @override
  String get deletingRoom => 'Delete room';

  @override
  String deleteRoomQuestion(String name) {
    return 'Delete the room \"$name\"? This cannot be undone.\n\nIf the room has reservations, it cannot be deleted. Mark it as inactive instead.';
  }

  @override
  String get newRoom => 'New room';

  @override
  String get images => 'Images';

  @override
  String get imagesHint =>
      'JPG or PNG, at most 5 MB. The cover image is shown in the list and in the mobile app.';

  @override
  String get imagesAfterSaveRoom =>
      'You can add images after you save the room.';

  @override
  String get addRoom => 'Add room';

  @override
  String get nameLength3to100 => 'Name must have between 3 and 100 characters.';

  @override
  String get nameLength3to150 => 'Name must have between 3 and 150 characters.';

  @override
  String get roomTypeRequired => 'Room type *';

  @override
  String get selectRoomType => 'Select a room type.';

  @override
  String get capacityPeopleRequired => 'Capacity (people) *';

  @override
  String get between1and10People => 'Between 1 and 10 people.';

  @override
  String get areaRequired => 'Area (m²) *';

  @override
  String get between5and200m2 => 'Between 5 and 200 m².';

  @override
  String get pricePerNightRequired => 'Price per night (KM) *';

  @override
  String get priceExample => 'e.g. 90.50';

  @override
  String get priceNightRange => 'Between 1 and 10,000 KM, e.g. 90.50.';

  @override
  String get roomAmenities => 'Room amenities';

  @override
  String get activeFemale => 'Active';

  @override
  String get inactiveRoomsHint => 'Guests cannot see or book inactive rooms.';

  @override
  String get roomName => 'Room name';

  @override
  String get allTypesFilter => 'All types';

  @override
  String get activePlural => 'Active';

  @override
  String get inactivePlural => 'Inactive';

  @override
  String get noRooms => 'No rooms to display.';

  @override
  String get typeShort => 'Type';

  @override
  String get capacity => 'Capacity';

  @override
  String get area => 'Area';

  @override
  String get pricePerNightHeader => 'Price / night';

  @override
  String get inactiveFemale => 'Inactive';

  @override
  String get equipmentAddedAddImage =>
      'The equipment has been added. You can now add an image.';

  @override
  String get deletingEquipment => 'Delete equipment';

  @override
  String deleteEquipmentQuestion(String name) {
    return 'Delete \"$name\"? This cannot be undone.\n\nIf the equipment has reservations, it cannot be deleted. Mark it as inactive instead.';
  }

  @override
  String get newEquipment => 'New equipment';

  @override
  String get equipmentTypeRequired => 'Equipment type *';

  @override
  String get selectEquipmentType => 'Select an equipment type.';

  @override
  String get peoplePerPieceRequired => 'People per piece *';

  @override
  String get peoplePerPieceHint => 'e.g. 2 for a tandem kayak';

  @override
  String get between1and4 => 'Between 1 and 4.';

  @override
  String get totalPiecesRequired => 'Total pieces *';

  @override
  String get totalPiecesHint => 'how many you have available';

  @override
  String get between1and100 => 'Between 1 and 100.';

  @override
  String get firstHourKmRequired => 'First hour (KM) *';

  @override
  String get additionalHourKmRequired => 'Each additional hour (KM) *';

  @override
  String get fullDayKmRequired => 'Full day (KM) *';

  @override
  String get inactiveEquipmentHint =>
      'Guests cannot see or book inactive equipment.';

  @override
  String get imageAfterSaveEquipment =>
      'You can add an image after you save the equipment.';

  @override
  String get addEquipment => 'Add equipment';

  @override
  String get between1and1000Km => 'Between 1 and 1,000 KM.';

  @override
  String fullDayShort(String price) {
    return 'full day: $price';
  }

  @override
  String guestPaysPerPiece(String prices) {
    return 'The guest pays per piece: $prices';
  }

  @override
  String get equipmentName => 'Equipment name';

  @override
  String get noEquipment => 'No equipment to display.';

  @override
  String get peoplePerPieceShort => 'People / pc.';

  @override
  String get pieces => 'Pieces';

  @override
  String get firstHour => 'First hour';

  @override
  String get additionalHour => 'Additional hour';

  @override
  String get fullDay => 'Full day';

  @override
  String placeAdded(String km) {
    return 'The place has been added ($km km from the accommodation). You can now add images.';
  }

  @override
  String get deletingPlace => 'Delete place';

  @override
  String deletePlaceQuestion(String name) {
    return 'Delete \"$name\"? This cannot be undone.\n\nIf the place has reviews or is in guests\' favorites, it cannot be deleted. Mark it as inactive instead.';
  }

  @override
  String get newPlace => 'New place';

  @override
  String get placeTypeRequired => 'Place type *';

  @override
  String get selectPlaceType => 'Select a place type.';

  @override
  String get addressSettlement => 'Address / settlement';

  @override
  String get addressExample => 'e.g. Donja Drežnica';

  @override
  String get latitudeRequired => 'Latitude *';

  @override
  String get longitudeRequired => 'Longitude *';

  @override
  String get selectLocationOnMap => 'Select a location on the map.';

  @override
  String distanceFromAccommodation(String km) {
    return 'Distance from the accommodation: $km km';
  }

  @override
  String get activeNeuter => 'Active';

  @override
  String get inactivePlacesHint => 'Guests cannot see inactive places.';

  @override
  String get imagesAfterSavePlace =>
      'You can add images after you save the place.';

  @override
  String get addPlace => 'Add place';

  @override
  String get placeName => 'Place name';

  @override
  String get allNeuter => 'All';

  @override
  String get noPlaces => 'No places to display.';

  @override
  String get address => 'Address';

  @override
  String get distance => 'Distance';

  @override
  String get inactiveNeuter => 'Inactive';

  @override
  String get activityName => 'Activity name';

  @override
  String get category => 'Category';

  @override
  String get allCategories => 'All categories';

  @override
  String get addActivity => 'Add activity';

  @override
  String get noActivities => 'No activities to display.';

  @override
  String get duration => 'Duration';

  @override
  String get maxPeople => 'Max people';

  @override
  String get pricePerPersonHeader => 'Price / person';

  @override
  String get nextSlotHeader => 'Next slot';

  @override
  String get noSlots => 'No slots';

  @override
  String get activityAdded =>
      'The activity has been added. You can now add an image and slots.';

  @override
  String get deletingActivity => 'Delete activity';

  @override
  String deleteActivityQuestion(String name) {
    return 'Delete \"$name\"? This cannot be undone.\n\nIf the activity has slots or reservations, it cannot be deleted. Mark it as inactive instead.';
  }

  @override
  String get newActivity => 'New activity';

  @override
  String get categoryRequired => 'Category *';

  @override
  String get selectCategory => 'Select a category.';

  @override
  String get durationMinutesRequired => 'Duration (minutes) *';

  @override
  String get durationHint => 'e.g. 180 = 3 hours';

  @override
  String get between30and720Minutes => 'Between 30 and 720 minutes.';

  @override
  String get maxParticipantsRequired => 'Max participants *';

  @override
  String get between1and50 => 'Between 1 and 50.';

  @override
  String get pricePerPersonRequired => 'Price per person (KM) *';

  @override
  String get meetingPoint => 'Meeting point';

  @override
  String get meetingPointExample =>
      'e.g. The beach in front of the accommodation';

  @override
  String get inactiveActivityHint =>
      'Guests cannot see or book an inactive activity.';

  @override
  String get imageAfterSaveActivity =>
      'You can add an image after you save the activity.';

  @override
  String get slotsAfterSaveActivity =>
      'You can add slots after you save the activity.';

  @override
  String get slots => 'Slots';

  @override
  String get onlyUpcoming => 'Upcoming only';

  @override
  String get addSlot => 'Add slot';

  @override
  String get addGuideFirst =>
      'First add at least one guide (Code lists → Guides).';

  @override
  String get noUpcomingSlots => 'No upcoming slots.';

  @override
  String get noSlotsShort => 'No slots.';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get booked => 'Booked';

  @override
  String get available => 'Available';

  @override
  String get selectStartDateTime => 'Select the start date and time.';

  @override
  String get slotMustBeFuture => 'The slot must be in the future.';

  @override
  String get deletingSlot => 'Delete slot';

  @override
  String deleteSlotQuestion(String date) {
    return 'Delete the slot $date?';
  }

  @override
  String get slot => 'Slot';

  @override
  String get newSlot => 'New slot';

  @override
  String get slotStartedCannotChange =>
      'The slot has already started or ended and cannot be changed.';

  @override
  String slotHasBookings(int count) {
    return 'The slot has $count booked spots. The time cannot be changed and the capacity cannot be lower than $count.';
  }

  @override
  String get dateRequired => 'Date *';

  @override
  String get timeRequired => 'Time *';

  @override
  String endsAt(String time, String duration) {
    return 'Ends at $time (duration $duration).';
  }

  @override
  String get capacityRequired => 'Capacity *';

  @override
  String capacityMaxHint(int max) {
    return 'At most $max (activity maximum)';
  }

  @override
  String betweenRange(int min, int max) {
    return 'Between $min and $max.';
  }

  @override
  String get guideRequired => 'Guide *';

  @override
  String get selectGuide => 'Select a guide.';

  @override
  String get selectAtLeastOneRole => 'Select at least one role.';

  @override
  String get userLoggedOutEverywhere =>
      'The user has been logged out on all devices.';

  @override
  String get userAdded => 'The user has been added.';

  @override
  String get deletingUser => 'Delete user';

  @override
  String deleteUserQuestion(String name) {
    return 'Delete the user $name? This cannot be undone.\n\nIf the user has reservations, reviews or payments, they cannot be deleted. Deactivate them instead.';
  }

  @override
  String get roleGuest => 'Guest';

  @override
  String get newUser => 'New user';

  @override
  String get personalData => 'Personal data';

  @override
  String get access => 'Access';

  @override
  String get leaveEmptyPassword =>
      'Leave empty if you are not changing the password.';

  @override
  String get confirmPassword => 'Confirm password *';

  @override
  String get confirmNewPasswordOptional => 'Confirm new password';

  @override
  String get rolesRequired => 'Roles *';

  @override
  String get activeMasculine => 'Active';

  @override
  String get cannotDeactivateSelf => 'You cannot deactivate your own account.';

  @override
  String get inactiveUserHint =>
      'An inactive user cannot log in and existing sessions are ended immediately.';

  @override
  String registeredAt(String date) {
    return 'Registered: $date';
  }

  @override
  String get addUser => 'Add user';

  @override
  String get userSearchHint => 'Name, username or e-mail';

  @override
  String get role => 'Role';

  @override
  String get allRoles => 'All roles';

  @override
  String get allMasculine => 'All';

  @override
  String get activeMasculinePlural => 'Active';

  @override
  String get inactiveMasculinePlural => 'Inactive';

  @override
  String get noUsers => 'No users to display.';

  @override
  String get roles => 'Roles';

  @override
  String get inactiveMasculine => 'Inactive';
}
