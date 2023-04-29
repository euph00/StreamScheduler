import '../secrets/secrets.dart' as secrets;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'youtube_data_controller.dart';

const List<String> _scopes = <String>[
  'https://www.googleapis.com/auth/youtube',
  'https://www.googleapis.com/auth/userinfo.profile',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: secrets.oauthClientId,
  scopes: _scopes,
);

class SignInController {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  static final SignInController _singletonInstance =
      SignInController._internal();

  factory SignInController() {
    return _singletonInstance;
  }
  SignInController._internal();

  // Returns true iff user is signed in AND authorised
  Future<bool> _handleCreds() async {
    var account = _googleSignIn.currentUser;
    bool isAuthorized = account != null;
    if (kIsWeb && account != null) {
      isAuthorized = await _googleSignIn.requestScopes(_scopes);
    }

    _currentUser = account;
    _isAuthorized = isAuthorized;
    return isAuthorized;
  }

  GoogleSignIn getGsiInstance() {
    return _googleSignIn;
  }

  bool getAuthStatus() {
    return _isAuthorized;
  }

  // Logs the user in, and also initialises the YoutubeDataController instance.
  void login() {
    _googleSignIn
        .signInSilently()
        .then((value) => _handleCreds())
        .then((value) => YoutubeDataController().initialiseYoutubeApi(this));
  }
}
