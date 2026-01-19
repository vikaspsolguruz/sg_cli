import 'package:max_arch/environments/environments.dart';

final String kStaticToken = staticTokens[currentEnvironment]!;

const kDefaultRegion = 'IN';
const mapApiKey = "map-api-key";
const String kLogFileName = 'app.log';

const kMimeTypeVideo = 'video/';
const kMimeTypeImage = 'image/';
const kSVGExtension = '.svg';
const kPNGExtension = '.png';

// Firebase auth exceptions
const kFirebaseAuthWeakPasswordException = 'weak-password';
const kFirebaseAuthUserNotFoundException = 'user-not-found';
const kFirebaseAuthWrongPasswordException = 'wrong-password';
const kFirebaseAuthTooManyRequestsException = 'too-many-requests';
const kFirebaseAuthInvalidCodeException = 'invalid-verification-code';
const kFirebaseAuthSessionExpiredException = 'session-expired';
const kFirebaseAuthSessionEmailAlreadyInUse = 'email-already-in-use';

const String kSomethingWentWrong = 'Oops! Something went wrong';

const double kHorizontalPadding = 16;
const double kInnerHorizontalPadding = 12;
const double kVerticalPadding = 16;
const double kInnerVerticalPadding = 12;
const double kBorderRadius = 8;
const int kResendOTPDuration = 30;

const int kGroupDescriptionCharacterLimit = 150;
const int kGroupMinimumMemberLimit = 50;
const int kSetupPreferenceLength = 5;
const int kCreateGroupPageLength = 8;
const int kPubPreferencePageLength = 11;

const kGoogle = 'google';
const kApple = 'apple';

// App-link's keys
final String kAppLinkBaseUrl = deeplinkBaseUrls[currentEnvironment]!;
const String kPub = 'pub';
const String kGroup = 'group';
const String kClub = 'club';
const String kMatch = 'match';
const String kCheckIn = 'checkIn';
const String kUser = 'user';
const String kOffer = 'offer';
const String kApp = 'app';
