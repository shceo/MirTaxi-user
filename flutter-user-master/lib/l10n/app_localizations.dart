import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('en'),
    Locale('ru'),
    Locale('uz')
  ];

  /// No description provided for @text_enter_social.
  ///
  /// In en, this message translates to:
  /// **'or Enter Social Media'**
  String get text_enter_social;

  /// No description provided for @text_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get text_sign_up;

  /// No description provided for @text_track_location.
  ///
  /// In en, this message translates to:
  /// **'Tracking Taxi Location'**
  String get text_track_location;

  /// No description provided for @text_keep_track.
  ///
  /// In en, this message translates to:
  /// **'Remember to keep track of Ride professional accomplishments'**
  String get text_keep_track;

  /// No description provided for @text_skip.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get text_skip;

  /// No description provided for @text_next.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get text_next;

  /// No description provided for @text_your_ride.
  ///
  /// In en, this message translates to:
  /// **'Your ride, on demand'**
  String get text_your_ride;

  /// No description provided for @text_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get text_login;

  /// No description provided for @text_phone_number.
  ///
  /// In en, this message translates to:
  /// **'phone number'**
  String get text_phone_number;

  /// No description provided for @text_get_started.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started!'**
  String get text_get_started;

  /// No description provided for @text_fill_form.
  ///
  /// In en, this message translates to:
  /// **'Fill the form to continue.'**
  String get text_fill_form;

  /// No description provided for @text_signup_social.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Social of fill the form to continue.'**
  String get text_signup_social;

  /// No description provided for @text_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get text_email;

  /// No description provided for @text_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get text_name;

  /// No description provided for @text_agree.
  ///
  /// In en, this message translates to:
  /// **'By Signing up, you agree to the'**
  String get text_agree;

  /// No description provided for @text_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get text_terms;

  /// No description provided for @text_and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get text_and;

  /// No description provided for @text_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get text_privacy;

  /// No description provided for @text_fastest_way.
  ///
  /// In en, this message translates to:
  /// **'Fastest way to book Taxi without the hassle of waiting & haggling of price'**
  String get text_fastest_way;

  /// No description provided for @text_phone_verify.
  ///
  /// In en, this message translates to:
  /// **'Phone Verification'**
  String get text_phone_verify;

  /// No description provided for @text_enter_otp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit code send to you at'**
  String get text_enter_otp;

  /// No description provided for @text_resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get text_resend_code;

  /// No description provided for @text_verify.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get text_verify;

  /// No description provided for @text_pick_up_location.
  ///
  /// In en, this message translates to:
  /// **'Pick up Location'**
  String get text_pick_up_location;

  /// No description provided for @text_drop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get text_drop;

  /// No description provided for @text_daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get text_daily;

  /// No description provided for @text_rental.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get text_rental;

  /// No description provided for @text_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get text_search;

  /// No description provided for @text_pick_up.
  ///
  /// In en, this message translates to:
  /// **'Pick-up'**
  String get text_pick_up;

  /// No description provided for @text_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get text_confirm;

  /// No description provided for @text_favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get text_favourites;

  /// No description provided for @text_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get text_clear;

  /// No description provided for @text_vehicle_make.
  ///
  /// In en, this message translates to:
  /// **'What make of vehicle is it?'**
  String get text_vehicle_make;

  /// No description provided for @text_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get text_continue;

  /// No description provided for @text_vehicle_model.
  ///
  /// In en, this message translates to:
  /// **'What model of vehicle is it?'**
  String get text_vehicle_model;

  /// No description provided for @text_service_location.
  ///
  /// In en, this message translates to:
  /// **'What service location you want to register?'**
  String get text_service_location;

  /// No description provided for @text_vehicle_type.
  ///
  /// In en, this message translates to:
  /// **'What type of vehicle is it?'**
  String get text_vehicle_type;

  /// No description provided for @text_vehicle_color.
  ///
  /// In en, this message translates to:
  /// **'What color of vehicle is it?'**
  String get text_vehicle_color;

  /// No description provided for @text_license.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Number'**
  String get text_license;

  /// No description provided for @text_enter_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Vehicle Number'**
  String get text_enter_vehicle;

  /// No description provided for @text_vehicle_model_year.
  ///
  /// In en, this message translates to:
  /// **'What is the Vehicle\'s model year'**
  String get text_vehicle_model_year;

  /// No description provided for @text_apply_referral.
  ///
  /// In en, this message translates to:
  /// **'Apply Referral'**
  String get text_apply_referral;

  /// No description provided for @text_enter_referral.
  ///
  /// In en, this message translates to:
  /// **'Enter Referral Code'**
  String get text_enter_referral;

  /// No description provided for @text_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get text_apply;

  /// No description provided for @text_manage_docs.
  ///
  /// In en, this message translates to:
  /// **'Manage Documents'**
  String get text_manage_docs;

  /// No description provided for @text_passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get text_passport;

  /// No description provided for @text_not_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Not Uploaded'**
  String get text_not_uploaded;

  /// No description provided for @text_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get text_uploaded;

  /// No description provided for @text_upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get text_upload;

  /// No description provided for @text_approval_waiting.
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get text_approval_waiting;

  /// No description provided for @text_send_approval.
  ///
  /// In en, this message translates to:
  /// **'Your document is still pending for verification. Once it\'s all verified you start getting rides. Please sit tight'**
  String get text_send_approval;

  /// No description provided for @text_upload_docs.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get text_upload_docs;

  /// No description provided for @text_choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get text_choose_language;

  /// No description provided for @text_enter_vehicle_model_year.
  ///
  /// In en, this message translates to:
  /// **'Enter your Vehicle Model Year'**
  String get text_enter_vehicle_model_year;

  /// No description provided for @text_edit_docs.
  ///
  /// In en, this message translates to:
  /// **'Update Documents'**
  String get text_edit_docs;

  /// No description provided for @text_account_blocked.
  ///
  /// In en, this message translates to:
  /// **'Account Blocked'**
  String get text_account_blocked;

  /// No description provided for @text_document_rejected.
  ///
  /// In en, this message translates to:
  /// **'Your Account is blocked for the following reasons'**
  String get text_document_rejected;

  /// No description provided for @text_contact_admin.
  ///
  /// In en, this message translates to:
  /// **'Contact your Admin'**
  String get text_contact_admin;

  /// No description provided for @text_enable_location.
  ///
  /// In en, this message translates to:
  /// **'Please Enable Your Location'**
  String get text_enable_location;

  /// No description provided for @text_ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get text_ok;

  /// No description provided for @text_loc_permission.
  ///
  /// In en, this message translates to:
  /// **'Allow Location all the time - To book a taxi'**
  String get text_loc_permission;

  /// No description provided for @text_off_duty.
  ///
  /// In en, this message translates to:
  /// **'On Duty'**
  String get text_off_duty;

  /// No description provided for @text_on_duty.
  ///
  /// In en, this message translates to:
  /// **'Off Duty'**
  String get text_on_duty;

  /// No description provided for @text_pickpoint.
  ///
  /// In en, this message translates to:
  /// **'Pickup point'**
  String get text_pickpoint;

  /// No description provided for @text_droppoint.
  ///
  /// In en, this message translates to:
  /// **'Dropout point'**
  String get text_droppoint;

  /// No description provided for @text_decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get text_decline;

  /// No description provided for @text_accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get text_accept;

  /// No description provided for @text_call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get text_call;

  /// No description provided for @text_chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get text_chat;

  /// No description provided for @text_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get text_cancel;

  /// No description provided for @text_arrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get text_arrived;

  /// No description provided for @text_youareonline.
  ///
  /// In en, this message translates to:
  /// **'You are Online now'**
  String get text_youareonline;

  /// No description provided for @text_youareoffline.
  ///
  /// In en, this message translates to:
  /// **'You are Offline now'**
  String get text_youareoffline;

  /// No description provided for @text_arriving.
  ///
  /// In en, this message translates to:
  /// **'Arriving'**
  String get text_arriving;

  /// No description provided for @text_onride.
  ///
  /// In en, this message translates to:
  /// **'Way to Drop'**
  String get text_onride;

  /// No description provided for @text_startride.
  ///
  /// In en, this message translates to:
  /// **'Start Ride'**
  String get text_startride;

  /// No description provided for @text_endtrip.
  ///
  /// In en, this message translates to:
  /// **'End Trip'**
  String get text_endtrip;

  /// No description provided for @text_driver_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get text_driver_otp;

  /// No description provided for @text_enterdriverotp.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP displayed in Customer\'s mobile to start the ride'**
  String get text_enterdriverotp;

  /// No description provided for @text_enable_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get text_enable_history;

  /// No description provided for @text_enable_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get text_enable_wallet;

  /// No description provided for @text_enable_referal.
  ///
  /// In en, this message translates to:
  /// **'Referal'**
  String get text_enable_referal;

  /// No description provided for @text_faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get text_faq;

  /// No description provided for @text_sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get text_sos;

  /// No description provided for @text_change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get text_change_language;

  /// No description provided for @text_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get text_about;

  /// No description provided for @text_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get text_logout;

  /// No description provided for @text_tripsummary.
  ///
  /// In en, this message translates to:
  /// **'Trip Summary'**
  String get text_tripsummary;

  /// No description provided for @text_reference.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get text_reference;

  /// No description provided for @text_rideType.
  ///
  /// In en, this message translates to:
  /// **'Type of Ride'**
  String get text_rideType;

  /// No description provided for @text_distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get text_distance;

  /// No description provided for @text_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get text_duration;

  /// No description provided for @text_tripfare.
  ///
  /// In en, this message translates to:
  /// **'Fare Breakup'**
  String get text_tripfare;

  /// No description provided for @text_baseprice.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get text_baseprice;

  /// No description provided for @text_taxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get text_taxes;

  /// No description provided for @text_distprice.
  ///
  /// In en, this message translates to:
  /// **'Distance Price'**
  String get text_distprice;

  /// No description provided for @text_timeprice.
  ///
  /// In en, this message translates to:
  /// **'Time Price'**
  String get text_timeprice;

  /// No description provided for @text_cancelfee.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Fee'**
  String get text_cancelfee;

  /// No description provided for @text_convfee.
  ///
  /// In en, this message translates to:
  /// **'Convenience Fee'**
  String get text_convfee;

  /// No description provided for @text_totalfare.
  ///
  /// In en, this message translates to:
  /// **'Total Fare'**
  String get text_totalfare;

  /// No description provided for @text_cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get text_cash;

  /// No description provided for @text_trust_contact.
  ///
  /// In en, this message translates to:
  /// **'Trusted Contact'**
  String get text_trust_contact;

  /// No description provided for @text_trust_contact_1.
  ///
  /// In en, this message translates to:
  /// **'Share your trip status'**
  String get text_trust_contact_1;

  /// No description provided for @text_trust_contact_2.
  ///
  /// In en, this message translates to:
  /// **'You’ll be able to share your live location with one or more contacts during any trip'**
  String get text_trust_contact_2;

  /// No description provided for @text_trust_contact_3.
  ///
  /// In en, this message translates to:
  /// **'Set your emergency contacts'**
  String get text_trust_contact_3;

  /// No description provided for @text_trust_contact_4.
  ///
  /// In en, this message translates to:
  /// **'You can make a trusted contact an emergency contact. You can call them in case of emergency.'**
  String get text_trust_contact_4;

  /// No description provided for @text_add_trust_contact.
  ///
  /// In en, this message translates to:
  /// **'Add trusted contact'**
  String get text_add_trust_contact;

  /// No description provided for @text_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get text_submit;

  /// No description provided for @text_feedback.
  ///
  /// In en, this message translates to:
  /// **'Give your Feedback'**
  String get text_feedback;

  /// No description provided for @text_cancel_reason.
  ///
  /// In en, this message translates to:
  /// **'Cancel Reason'**
  String get text_cancel_reason;

  /// No description provided for @text_cancelrequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get text_cancelrequest;

  /// No description provided for @text_entercancelreason.
  ///
  /// In en, this message translates to:
  /// **'Enter Cancel Reason'**
  String get text_entercancelreason;

  /// No description provided for @text_pickdroplocation.
  ///
  /// In en, this message translates to:
  /// **'Choose Drop Location'**
  String get text_pickdroplocation;

  /// No description provided for @text_choosepicklocation.
  ///
  /// In en, this message translates to:
  /// **'Choose Pick Location'**
  String get text_choosepicklocation;

  /// No description provided for @text_fav_address.
  ///
  /// In en, this message translates to:
  /// **'Favourite Address'**
  String get text_fav_address;

  /// No description provided for @text_pick_suggestion.
  ///
  /// In en, this message translates to:
  /// **'Pickup Suggestion'**
  String get text_pick_suggestion;

  /// No description provided for @text_drop_suggestion.
  ///
  /// In en, this message translates to:
  /// **'Drop Suggestion'**
  String get text_drop_suggestion;

  /// No description provided for @text_chooseonmap.
  ///
  /// In en, this message translates to:
  /// **'Locate on Map'**
  String get text_chooseonmap;

  /// No description provided for @text_4lettersforautofill.
  ///
  /// In en, this message translates to:
  /// **'Enter 4 letters to search'**
  String get text_4lettersforautofill;

  /// No description provided for @text_availablerides.
  ///
  /// In en, this message translates to:
  /// **'Available Rides'**
  String get text_availablerides;

  /// No description provided for @text_paymentmethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get text_paymentmethod;

  /// No description provided for @text_choose_paynoworlater.
  ///
  /// In en, this message translates to:
  /// **'Choose your payment now or later'**
  String get text_choose_paynoworlater;

  /// No description provided for @text_paycash.
  ///
  /// In en, this message translates to:
  /// **'Pay when trip ends'**
  String get text_paycash;

  /// No description provided for @text_paycard.
  ///
  /// In en, this message translates to:
  /// **'For seamless and contact less payment'**
  String get text_paycard;

  /// No description provided for @text_payupi.
  ///
  /// In en, this message translates to:
  /// **'For faster payment'**
  String get text_payupi;

  /// No description provided for @text_paywallet.
  ///
  /// In en, this message translates to:
  /// **'For Instant payment'**
  String get text_paywallet;

  /// No description provided for @text_payingvia.
  ///
  /// In en, this message translates to:
  /// **'Paying via'**
  String get text_payingvia;

  /// No description provided for @text_enterpromo.
  ///
  /// In en, this message translates to:
  /// **'Enter Promo Code'**
  String get text_enterpromo;

  /// No description provided for @text_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get text_remove;

  /// No description provided for @text_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get text_edit;

  /// No description provided for @text_promoaccepted.
  ///
  /// In en, this message translates to:
  /// **' Coupon Applied'**
  String get text_promoaccepted;

  /// No description provided for @text_promorejected.
  ///
  /// In en, this message translates to:
  /// **'Invalid Coupon Code'**
  String get text_promorejected;

  /// No description provided for @text_findingdriver.
  ///
  /// In en, this message translates to:
  /// **'Looking for nearby drivers'**
  String get text_findingdriver;

  /// No description provided for @text_finddriverdesc.
  ///
  /// In en, this message translates to:
  /// **'We are looking for nearby drivers to accept your ride. Once accepted you can ride with us! We appreciate your patience!'**
  String get text_finddriverdesc;

  /// No description provided for @text_pickup_instruction.
  ///
  /// In en, this message translates to:
  /// **'Any Instructions for pick up'**
  String get text_pickup_instruction;

  /// No description provided for @text_shareride.
  ///
  /// In en, this message translates to:
  /// **'Share Ride'**
  String get text_shareride;

  /// No description provided for @text_ridecancel.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to cancel ride'**
  String get text_ridecancel;

  /// No description provided for @text_ridecancel_desc.
  ///
  /// In en, this message translates to:
  /// **'Your ride will be cancelled and returned to main menu. This will lead to cancellation fee'**
  String get text_ridecancel_desc;

  /// No description provided for @tex_dontcancel.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Cancel'**
  String get tex_dontcancel;

  /// No description provided for @text_cancelRideReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancelling ride'**
  String get text_cancelRideReason;

  /// No description provided for @text_nodriver.
  ///
  /// In en, this message translates to:
  /// **'No Driver Found'**
  String get text_nodriver;

  /// No description provided for @text_tryagain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get text_tryagain;

  /// No description provided for @text_ridelater.
  ///
  /// In en, this message translates to:
  /// **'Ride Later'**
  String get text_ridelater;

  /// No description provided for @text_ridenow.
  ///
  /// In en, this message translates to:
  /// **'Ride Now'**
  String get text_ridenow;

  /// No description provided for @text_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get text_home;

  /// No description provided for @text_work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get text_work;

  /// No description provided for @text_others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get text_others;

  /// No description provided for @text_enterfavname.
  ///
  /// In en, this message translates to:
  /// **'Enter Favourites Name'**
  String get text_enterfavname;

  /// No description provided for @text_confirmridelater.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to choose ride in this time'**
  String get text_confirmridelater;

  /// No description provided for @text_rideLaterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ride is confirmed successfully'**
  String get text_rideLaterSuccess;

  /// No description provided for @text_saveaddressas.
  ///
  /// In en, this message translates to:
  /// **'Save as Favourite'**
  String get text_saveaddressas;

  /// No description provided for @text_trustedtaxi.
  ///
  /// In en, this message translates to:
  /// **'Most Trusted Taxi Booking App'**
  String get text_trustedtaxi;

  /// No description provided for @text_allowpermission1.
  ///
  /// In en, this message translates to:
  /// **'To enjoy your ride experience'**
  String get text_allowpermission1;

  /// No description provided for @text_allowpermission2.
  ///
  /// In en, this message translates to:
  /// **'Please allow us the following permissions'**
  String get text_allowpermission2;

  /// No description provided for @text_allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get text_allow;

  /// No description provided for @text_drivercancelled.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancelled by Driver'**
  String get text_drivercancelled;

  /// No description provided for @text_cancelsuccess.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancelled Successfully'**
  String get text_cancelsuccess;

  /// No description provided for @text_notifyadmin.
  ///
  /// In en, this message translates to:
  /// **'Notify Admin'**
  String get text_notifyadmin;

  /// No description provided for @text_notifysuccess.
  ///
  /// In en, this message translates to:
  /// **'Notified Successfully'**
  String get text_notifysuccess;

  /// No description provided for @text_chatwithdriver.
  ///
  /// In en, this message translates to:
  /// **'Chat With Driver'**
  String get text_chatwithdriver;

  /// No description provided for @text_entermessage.
  ///
  /// In en, this message translates to:
  /// **'Enter Message'**
  String get text_entermessage;

  /// No description provided for @text_newmessagereceived.
  ///
  /// In en, this message translates to:
  /// **'New Message Received'**
  String get text_newmessagereceived;

  /// No description provided for @text_nointernet.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get text_nointernet;

  /// No description provided for @text_nointernetdesc.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection, try enabling wifi or try again later'**
  String get text_nointernetdesc;

  /// No description provided for @text_copyrights.
  ///
  /// In en, this message translates to:
  /// **'Copyrights'**
  String get text_copyrights;

  /// No description provided for @text_termsandconditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get text_termsandconditions;

  /// No description provided for @text_yourTrustedContacts.
  ///
  /// In en, this message translates to:
  /// **'Your Trusted Contacts'**
  String get text_yourTrustedContacts;

  /// No description provided for @text_removeSos.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to remove this contact from your trusted Contact'**
  String get text_removeSos;

  /// No description provided for @text_noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get text_noDataFound;

  /// No description provided for @text_removeFav.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to remove this address from your favorites'**
  String get text_removeFav;

  /// No description provided for @text_invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get text_invite;

  /// No description provided for @text_invitation_1.
  ///
  /// In en, this message translates to:
  /// **'Join me on Tagxi! using my invite code'**
  String get text_invitation_1;

  /// No description provided for @text_invitation_2.
  ///
  /// In en, this message translates to:
  /// **'To make easy your ride'**
  String get text_invitation_2;

  /// No description provided for @text_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get text_upcoming;

  /// No description provided for @text_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get text_completed;

  /// No description provided for @text_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get text_cancelled;

  /// No description provided for @text_card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get text_card;

  /// No description provided for @text_loadmore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get text_loadmore;

  /// No description provided for @text_location.
  ///
  /// In en, this message translates to:
  /// **'Location details'**
  String get text_location;

  /// No description provided for @text_assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get text_assigned;

  /// No description provided for @text_started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get text_started;

  /// No description provided for @text_availablebalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get text_availablebalance;

  /// No description provided for @text_addmoney.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get text_addmoney;

  /// No description provided for @text_recenttransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get text_recenttransactions;

  /// No description provided for @text_deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get text_deposit;

  /// No description provided for @text_ridepayment.
  ///
  /// In en, this message translates to:
  /// **'Ride Payment'**
  String get text_ridepayment;

  /// No description provided for @text_enteramount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount Here'**
  String get text_enteramount;

  /// No description provided for @text_editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get text_editprofile;

  /// No description provided for @text_editimage.
  ///
  /// In en, this message translates to:
  /// **'Edit Image'**
  String get text_editimage;

  /// No description provided for @text_pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get text_pay;

  /// No description provided for @text_somethingwentwrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong, Try again'**
  String get text_somethingwentwrong;

  /// No description provided for @text_paymentsuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get text_paymentsuccess;

  /// No description provided for @text_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get text_camera;

  /// No description provided for @text_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get text_gallery;

  /// No description provided for @text_updateVehicle.
  ///
  /// In en, this message translates to:
  /// **'Update Vehicle Info'**
  String get text_updateVehicle;

  /// No description provided for @text_make.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Make'**
  String get text_make;

  /// No description provided for @text_model.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get text_model;

  /// No description provided for @text_year.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Year'**
  String get text_year;

  /// No description provided for @text_type.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get text_type;

  /// No description provided for @text_number.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Number'**
  String get text_number;

  /// No description provided for @text_color.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Color'**
  String get text_color;

  /// No description provided for @text_tapfordocs.
  ///
  /// In en, this message translates to:
  /// **'Tap here to upload'**
  String get text_tapfordocs;

  /// No description provided for @text_earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get text_earnings;

  /// No description provided for @text_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get text_today;

  /// No description provided for @text_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get text_weekly;

  /// No description provided for @text_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get text_monthly;

  /// No description provided for @text_trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get text_trips;

  /// No description provided for @text_hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get text_hours;

  /// No description provided for @text_tripkm.
  ///
  /// In en, this message translates to:
  /// **'Trip Kms'**
  String get text_tripkm;

  /// No description provided for @text_walletpayment.
  ///
  /// In en, this message translates to:
  /// **'Wallet Payment'**
  String get text_walletpayment;

  /// No description provided for @text_cashpayment.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get text_cashpayment;

  /// No description provided for @text_totalearnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get text_totalearnings;

  /// No description provided for @text_report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get text_report;

  /// No description provided for @text_fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get text_fromDate;

  /// No description provided for @text_toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get text_toDate;

  /// No description provided for @text_withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get text_withdraw;

  /// No description provided for @text_withdrawHistory.
  ///
  /// In en, this message translates to:
  /// **'Withdraw History'**
  String get text_withdrawHistory;

  /// No description provided for @text_withdrawReqAt.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Request At'**
  String get text_withdrawReqAt;

  /// No description provided for @text_bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get text_bankDetails;

  /// No description provided for @text_accoutHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get text_accoutHolderName;

  /// No description provided for @text_accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get text_accountNumber;

  /// No description provided for @text_bankCode.
  ///
  /// In en, this message translates to:
  /// **'Bank Code'**
  String get text_bankCode;

  /// No description provided for @text_bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get text_bankName;

  /// No description provided for @text_updateBank.
  ///
  /// In en, this message translates to:
  /// **'Update Bank Info'**
  String get text_updateBank;

  /// No description provided for @text_confirmlogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to logout'**
  String get text_confirmlogout;

  /// No description provided for @text_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get text_wallet;

  /// No description provided for @text_startridewithotp.
  ///
  /// In en, this message translates to:
  /// **'Start Ride with OTP'**
  String get text_startridewithotp;

  /// No description provided for @text_loadingLocalization.
  ///
  /// In en, this message translates to:
  /// **'Loading Localization'**
  String get text_loadingLocalization;

  /// No description provided for @text_background_permission.
  ///
  /// In en, this message translates to:
  /// **'Enable Background Location - to give you ride request even if your app is in background'**
  String get text_background_permission;

  /// No description provided for @text_user_cancelled_request.
  ///
  /// In en, this message translates to:
  /// **'User Cancelled the Request'**
  String get text_user_cancelled_request;

  /// No description provided for @text_low_balance.
  ///
  /// In en, this message translates to:
  /// **'Your wallet balance is low, please add some money to continue service'**
  String get text_low_balance;

  /// No description provided for @text_otp_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter correct Otp or resend'**
  String get text_otp_error;

  /// No description provided for @text_code_copied.
  ///
  /// In en, this message translates to:
  /// **'Referral Code Copied'**
  String get text_code_copied;

  /// No description provided for @text_loc_permission_user.
  ///
  /// In en, this message translates to:
  /// **'Allow Location - To book a taxi'**
  String get text_loc_permission_user;

  /// No description provided for @text_low_wallet_for_ride.
  ///
  /// In en, this message translates to:
  /// **'Your Wallet Balance is too low to make this race'**
  String get text_low_wallet_for_ride;

  /// No description provided for @text_internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal Server Error'**
  String get text_internal_server_error;

  /// No description provided for @text_supported_vehicles.
  ///
  /// In en, this message translates to:
  /// **'Supported Vehicles'**
  String get text_supported_vehicles;

  /// No description provided for @text_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get text_description;

  /// No description provided for @text_estimated_amount.
  ///
  /// In en, this message translates to:
  /// **'Estimated Amount'**
  String get text_estimated_amount;

  /// No description provided for @text_open_loc_settings.
  ///
  /// In en, this message translates to:
  /// **'Location access is needed for running the app, please enable it in settings and tap done'**
  String get text_open_loc_settings;

  /// No description provided for @text_open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get text_open_settings;

  /// No description provided for @text_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get text_done;

  /// No description provided for @text_open_contact_setting.
  ///
  /// In en, this message translates to:
  /// **'Contact access is needed to pick contact for SOS, pleable enable it in settings and tap done'**
  String get text_open_contact_setting;

  /// No description provided for @text_open_camera_setting.
  ///
  /// In en, this message translates to:
  /// **'Camera access is needed to capture image, please enable it in settings and tap done'**
  String get text_open_camera_setting;

  /// No description provided for @text_open_photos_setting.
  ///
  /// In en, this message translates to:
  /// **'Photos access is needed to pick image, please enable it in settings and tap done'**
  String get text_open_photos_setting;

  /// No description provided for @text_enter_otp_login.
  ///
  /// In en, this message translates to:
  /// **'Enter Otp'**
  String get text_enter_otp_login;

  /// No description provided for @text_add_by_card.
  ///
  /// In en, this message translates to:
  /// **'Add by Card'**
  String get text_add_by_card;

  /// No description provided for @text_add_by_kiosk.
  ///
  /// In en, this message translates to:
  /// **'Add by Kiosk'**
  String get text_add_by_kiosk;

  /// No description provided for @text_pay_by_card.
  ///
  /// In en, this message translates to:
  /// **'Pay by Card'**
  String get text_pay_by_card;

  /// No description provided for @text_pay_by_kiosk.
  ///
  /// In en, this message translates to:
  /// **'Pay by Kiosk'**
  String get text_pay_by_kiosk;

  /// No description provided for @text_error_trip_otp.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid OTP'**
  String get text_error_trip_otp;

  /// No description provided for @text_bill_reference.
  ///
  /// In en, this message translates to:
  /// **'Bill Reference'**
  String get text_bill_reference;

  /// No description provided for @text_subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get text_subscriptions;

  /// No description provided for @text_select_sub_plan.
  ///
  /// In en, this message translates to:
  /// **'Select a plan to continue'**
  String get text_select_sub_plan;

  /// No description provided for @text_sub_text1.
  ///
  /// In en, this message translates to:
  /// **'Spot payment to your wallet'**
  String get text_sub_text1;

  /// No description provided for @text_sub_text2.
  ///
  /// In en, this message translates to:
  /// **'Benefits of getting whole amount'**
  String get text_sub_text2;

  /// No description provided for @text_sub_text3.
  ///
  /// In en, this message translates to:
  /// **'Get priority customer support'**
  String get text_sub_text3;

  /// No description provided for @text_sub_text4.
  ///
  /// In en, this message translates to:
  /// **'0% commission'**
  String get text_sub_text4;

  /// No description provided for @text_sub_ended.
  ///
  /// In en, this message translates to:
  /// **'Your Subscription is ended'**
  String get text_sub_ended;

  /// No description provided for @text_sub_ended_1.
  ///
  /// In en, this message translates to:
  /// **'Your Subscription has ended on '**
  String get text_sub_ended_1;

  /// No description provided for @text_purchase_now.
  ///
  /// In en, this message translates to:
  /// **'Purchase now'**
  String get text_purchase_now;

  /// No description provided for @text_browse_plans.
  ///
  /// In en, this message translates to:
  /// **'Browse Plans'**
  String get text_browse_plans;

  /// No description provided for @text_monthly_plan.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get text_monthly_plan;

  /// No description provided for @text_yearly_plan.
  ///
  /// In en, this message translates to:
  /// **'Yearly Plan'**
  String get text_yearly_plan;

  /// No description provided for @text_rideLaterTime.
  ///
  /// In en, this message translates to:
  /// **'Ride Scheduled at'**
  String get text_rideLaterTime;

  /// No description provided for @text_cancel_ride.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get text_cancel_ride;

  /// No description provided for @text_sub_ended_2.
  ///
  /// In en, this message translates to:
  /// **'Subscribe a plan to continue getting rides'**
  String get text_sub_ended_2;

  /// No description provided for @text_make_complaints.
  ///
  /// In en, this message translates to:
  /// **'Make Complaints'**
  String get text_make_complaints;

  /// No description provided for @text_complaint_1.
  ///
  /// In en, this message translates to:
  /// **'Click Below to Choose Type'**
  String get text_complaint_1;

  /// No description provided for @text_complaint_2.
  ///
  /// In en, this message translates to:
  /// **'Write your complaint here'**
  String get text_complaint_2;

  /// No description provided for @text_complaint_success.
  ///
  /// In en, this message translates to:
  /// **'We Successfully Got Your Concern...'**
  String get text_complaint_success;

  /// No description provided for @text_complaint_success_2.
  ///
  /// In en, this message translates to:
  /// **'We Will Get You Sooner'**
  String get text_complaint_success_2;

  /// No description provided for @text_thankyou.
  ///
  /// In en, this message translates to:
  /// **'Thank You'**
  String get text_thankyou;

  /// No description provided for @text_complaint_3.
  ///
  /// In en, this message translates to:
  /// **'minimum 10 characters'**
  String get text_complaint_3;

  /// No description provided for @text_free_trail_1.
  ///
  /// In en, this message translates to:
  /// **'Try Free Trial for 1 Month'**
  String get text_free_trail_1;

  /// No description provided for @text_free_trail_2.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to get Free Trial for 1 month'**
  String get text_free_trail_2;

  /// No description provided for @text_waiting_time.
  ///
  /// In en, this message translates to:
  /// **'Waiting Time'**
  String get text_waiting_time;

  /// No description provided for @text_mins.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get text_mins;

  /// No description provided for @text_waiting_time_1.
  ///
  /// In en, this message translates to:
  /// **'Free Waiting Time'**
  String get text_waiting_time_1;

  /// No description provided for @text_waiting_time_2.
  ///
  /// In en, this message translates to:
  /// **'Free Waiting Time Before Trip Start'**
  String get text_waiting_time_2;

  /// No description provided for @text_waiting_time_3.
  ///
  /// In en, this message translates to:
  /// **'Free Waiting Time After Trip Start'**
  String get text_waiting_time_3;

  /// No description provided for @text_waiting_price.
  ///
  /// In en, this message translates to:
  /// **'Waiting Price'**
  String get text_waiting_price;

  /// No description provided for @text_discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get text_discount;

  /// No description provided for @text_no_service.
  ///
  /// In en, this message translates to:
  /// **'Service not available in your location'**
  String get text_no_service;

  /// No description provided for @text_tax_inclusive.
  ///
  /// In en, this message translates to:
  /// **'Inclusive of TAX'**
  String get text_tax_inclusive;

  /// No description provided for @text_surge_fee.
  ///
  /// In en, this message translates to:
  /// **'Surge fee'**
  String get text_surge_fee;

  /// No description provided for @text_choose_payment.
  ///
  /// In en, this message translates to:
  /// **'Choose Payment Method'**
  String get text_choose_payment;

  /// No description provided for @text_rental_ride.
  ///
  /// In en, this message translates to:
  /// **'Rental Ride'**
  String get text_rental_ride;

  /// No description provided for @text_regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get text_regular;

  /// No description provided for @text_ride_type.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get text_ride_type;

  /// No description provided for @text_referral_code.
  ///
  /// In en, this message translates to:
  /// **'please enter valid referral code'**
  String get text_referral_code;

  /// No description provided for @text_arrive_eta.
  ///
  /// In en, this message translates to:
  /// **'Driver arrives in'**
  String get text_arrive_eta;

  /// No description provided for @text_email_validation.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get text_email_validation;

  /// No description provided for @text_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get text_delete_account;

  /// No description provided for @text_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete your account'**
  String get text_delete_confirm;

  /// No description provided for @text_add_cancel_reason.
  ///
  /// In en, this message translates to:
  /// **'Add Cancel Reason'**
  String get text_add_cancel_reason;

  /// No description provided for @text_chatwithuser.
  ///
  /// In en, this message translates to:
  /// **'Chat with Passenger'**
  String get text_chatwithuser;

  /// No description provided for @text_available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get text_available;

  /// No description provided for @text_onboard.
  ///
  /// In en, this message translates to:
  /// **'OnBoard'**
  String get text_onboard;

  /// No description provided for @text_offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get text_offline;

  /// No description provided for @text_no_data_found.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get text_no_data_found;

  /// No description provided for @text_manage_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Manage Vehicles'**
  String get text_manage_vehicle;

  /// No description provided for @text_manage_drivers.
  ///
  /// In en, this message translates to:
  /// **'Manage Drivers'**
  String get text_manage_drivers;

  /// No description provided for @text_driver_added.
  ///
  /// In en, this message translates to:
  /// **'Driver Added Successfully'**
  String get text_driver_added;

  /// No description provided for @text_no_driver.
  ///
  /// In en, this message translates to:
  /// **'No Driver '**
  String get text_no_driver;

  /// No description provided for @text_assign_new_driver.
  ///
  /// In en, this message translates to:
  /// **'Assign new Driver +'**
  String get text_assign_new_driver;

  /// No description provided for @text_select_driver.
  ///
  /// In en, this message translates to:
  /// **'Please Select Driver'**
  String get text_select_driver;

  /// No description provided for @text_fleet_not_assigned.
  ///
  /// In en, this message translates to:
  /// **'Fleet Not Assigned'**
  String get text_fleet_not_assigned;

  /// No description provided for @text_no_driver_found.
  ///
  /// In en, this message translates to:
  /// **'No Drivers Found'**
  String get text_no_driver_found;

  /// No description provided for @text_select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get text_select_date;

  /// No description provided for @text_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get text_user;

  /// No description provided for @text_driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get text_driver;

  /// No description provided for @text_driver_not_assigned.
  ///
  /// In en, this message translates to:
  /// **'Driver Not Assigned'**
  String get text_driver_not_assigned;

  /// No description provided for @text_waiting_approval.
  ///
  /// In en, this message translates to:
  /// **'Waiting For Approval'**
  String get text_waiting_approval;

  /// No description provided for @text_no_vehicle_found.
  ///
  /// In en, this message translates to:
  /// **'No Vehicle Found'**
  String get text_no_vehicle_found;

  /// No description provided for @text_assign_driver.
  ///
  /// In en, this message translates to:
  /// **'Assign Driver'**
  String get text_assign_driver;

  /// No description provided for @text_upload_doc.
  ///
  /// In en, this message translates to:
  /// **'Upload Docs'**
  String get text_upload_doc;

  /// No description provided for @text_vehicle_added.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Succefully Added'**
  String get text_vehicle_added;

  /// No description provided for @text_add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get text_add_photo;

  /// No description provided for @text_login_driver.
  ///
  /// In en, this message translates to:
  /// **'Login as a Driver'**
  String get text_login_driver;

  /// No description provided for @text_login_owner.
  ///
  /// In en, this message translates to:
  /// **'Login as a Owner'**
  String get text_login_owner;

  /// No description provided for @text_fleet_details.
  ///
  /// In en, this message translates to:
  /// **'Fleet Details'**
  String get text_fleet_details;

  /// No description provided for @text_delete_driver.
  ///
  /// In en, this message translates to:
  /// **'Delete Driver'**
  String get text_delete_driver;

  /// No description provided for @text_delete_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete this driver ?'**
  String get text_delete_confirmation;

  /// No description provided for @text_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get text_yes;

  /// No description provided for @text_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get text_no;

  /// No description provided for @text_fleet_diver_low_bal.
  ///
  /// In en, this message translates to:
  /// **'Your owner wallet balance is low, please contact your owner'**
  String get text_fleet_diver_low_bal;

  /// No description provided for @text_add_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get text_add_vehicle;

  /// No description provided for @text_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get text_address;

  /// No description provided for @text_add_driver.
  ///
  /// In en, this message translates to:
  /// **'Add Driver'**
  String get text_add_driver;

  /// No description provided for @text_choose_area.
  ///
  /// In en, this message translates to:
  /// **'Choose Area'**
  String get text_choose_area;

  /// No description provided for @text_company_name.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get text_company_name;

  /// No description provided for @text_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get text_city;

  /// No description provided for @text_postal_code.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get text_postal_code;

  /// No description provided for @text_tax_number.
  ///
  /// In en, this message translates to:
  /// **'Tax Number'**
  String get text_tax_number;

  /// No description provided for @text_no_fleet_assigned.
  ///
  /// In en, this message translates to:
  /// **'No Fleet Assigned'**
  String get text_no_fleet_assigned;

  /// No description provided for @text_ridewithout_destination.
  ///
  /// In en, this message translates to:
  /// **'Ride without Destination'**
  String get text_ridewithout_destination;

  /// No description provided for @text_notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get text_notification;

  /// No description provided for @text_delete_notification.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to Delete the Notication'**
  String get text_delete_notification;

  /// No description provided for @text_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get text_share;

  /// No description provided for @text_share_money.
  ///
  /// In en, this message translates to:
  /// **'Share Money'**
  String get text_share_money;

  /// No description provided for @text_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get text_close;

  /// No description provided for @text_fill_fileds.
  ///
  /// In en, this message translates to:
  /// **'Fill The Fields'**
  String get text_fill_fileds;

  /// No description provided for @text_admin_commision.
  ///
  /// In en, this message translates to:
  /// **'Admin Commission'**
  String get text_admin_commision;

  /// No description provided for @text_notification_deleted.
  ///
  /// In en, this message translates to:
  /// **'Notification  Deleted'**
  String get text_notification_deleted;

  /// No description provided for @text_transferred_successfully.
  ///
  /// In en, this message translates to:
  /// **'Transferred Successfully'**
  String get text_transferred_successfully;

  /// No description provided for @text_testing.
  ///
  /// In en, this message translates to:
  /// **'Testing'**
  String get text_testing;

  /// No description provided for @money_deposited.
  ///
  /// In en, this message translates to:
  /// **'Money Deposited'**
  String get money_deposited;

  /// No description provided for @admin_commission_for_trip.
  ///
  /// In en, this message translates to:
  /// **'Admin Commission For Trip'**
  String get admin_commission_for_trip;

  /// No description provided for @trip_commission.
  ///
  /// In en, this message translates to:
  /// **'Trip Commission'**
  String get trip_commission;

  /// No description provided for @cancellation_fee_title.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Fee'**
  String get cancellation_fee_title;

  /// No description provided for @money_deposited_by_admin.
  ///
  /// In en, this message translates to:
  /// **'Money Deposited By Admin'**
  String get money_deposited_by_admin;

  /// No description provided for @referral_commission.
  ///
  /// In en, this message translates to:
  /// **'Referral Commission'**
  String get referral_commission;

  /// No description provided for @spent_for_trip_request.
  ///
  /// In en, this message translates to:
  /// **'Spent For Trip Request'**
  String get spent_for_trip_request;

  /// No description provided for @withdrawn_from_wallet.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn From Wallet'**
  String get withdrawn_from_wallet;

  /// No description provided for @text_enter_vehicle_color.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Vehicle Color'**
  String get text_enter_vehicle_color;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
