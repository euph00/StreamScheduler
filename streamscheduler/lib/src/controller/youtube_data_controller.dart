import 'package:googleapis/youtube/v3.dart';
import 'sign_in_controller.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class YoutubeDataController {
  YouTubeApi? youTubeApi;
  SignInController? signInController;
  static final YoutubeDataController _singletonInstance =
      YoutubeDataController._internal();

  factory YoutubeDataController() {
    return _singletonInstance;
  }
  YoutubeDataController._internal();

  void initialiseYoutubeApi(SignInController signInController) async {
    var httpClient =
        (await signInController.getGsiInstance().authenticatedClient())!;
    youTubeApi = YouTubeApi(httpClient);
    this.signInController = signInController;
  }

  void clearCredentials() {
    youTubeApi = null;
    signInController = null;
  }

  void displaySubscriptions() async {
    if (signInController == null) {
      print('NOT SIGNED IN');
    }
    if (!signInController!.getAuthStatus()) {
      print("NOT AUTHORISED");
      return;
    }
    String? id = (await youTubeApi!.channels.list(["id"], mine: true))
        .items![0]
        .id; // get own channel id
    var subs = (await youTubeApi!.subscriptions
            .list(['snippet'], channelId: id, maxResults: 50))
        .items!; // list subs
    for (var item in subs) {
      print(item.snippet!.title);
    }
  }
}
