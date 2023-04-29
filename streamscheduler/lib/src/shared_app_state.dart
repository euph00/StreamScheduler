import 'package:flutter/material.dart';
import 'secrets/secrets.dart' as secrets;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';


const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/youtube',
  'https://www.googleapis.com/auth/userinfo.profile',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: secrets.oauthClientId,
  scopes: scopes,
);

class MainAppState extends ChangeNotifier {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  late YouTubeApi? youTubeApi;

  void handleCreds() async {
    var account = _googleSignIn.currentUser;
    bool isAuthorized = account != null;
      // However, in the web...
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.requestScopes(scopes);
      }
      print(account);
      print(isAuthorized);
      
      _currentUser = account;
      _isAuthorized = isAuthorized;
      if (isAuthorized) {
        var httpClient = (await _googleSignIn.authenticatedClient())!;
        youTubeApi = YouTubeApi(httpClient);
      }
  }

  void login() {
    _googleSignIn.signInSilently().then((value) => handleCreds());
  }

  void displaySubscriptions() async {
    if (!_isAuthorized) {
      print("not auth");
      return;
    }
    String? id = (await youTubeApi!.channels.list(["id"], mine: true)).items![0].id; // get own channel id
    var subs = (await youTubeApi!.subscriptions.list(['snippet'], channelId: id, maxResults: 50)).items!; // list subs
    for (var item in subs) {
      print(item.snippet!.title);
    }
  }

}
