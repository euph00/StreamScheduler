import 'package:googleapis/youtube/v3.dart';
import 'sign_in_controller.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class YoutubeDataController {
  YouTubeApi? youTubeApi;
  SignInController? signInController;
  late final String _id;
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
    _id = (await youTubeApi!.channels.list(['id'], mine: true)).items![0].id!;
  }

  void clearCredentials() {
    youTubeApi = null;
    signInController = null;
  }

  Future<List<Subscription>> getSubscriptions() async {
    if (signInController == null) {
      print('NOT SIGNED IN');
    }
    var subs = <Subscription>[];
    var response = (await youTubeApi!.subscriptions
        .list(['snippet', 'contentDetails'], channelId: _id, maxResults: 50));
    for (int i = 0; i < 10; i++) {
      //currently support up to 500 subbed channels, due to api quotas
      for (var item in response.items!) {
        subs.add(item);
      }
      if (response.nextPageToken == null) break;
      response = (await youTubeApi!.subscriptions.list(['snippet'],
          channelId: _id, maxResults: 50, pageToken: response.nextPageToken));
    }
    return subs;
  }

  void test(String channelId) async {
    channelId = 'UC6eWCld0KwmyHFbAqK3V-Rw'; //koyori's channel id, since she has streams scheduled. this is for testing.
    print(channelId);
    Channel ch = (await youTubeApi!.channels.list(['snippet', 'contentDetails'], id: [channelId])).items![0];
    print(ch.snippet!.title);
    String playlistId = ch.contentDetails!.relatedPlaylists!.uploads!;
    print(playlistId);
    List<PlaylistItem> items = (await youTubeApi!.playlistItems.list(['snippet'], playlistId: playlistId)).items!;
    for (PlaylistItem item in items) {
      print(item.snippet!.title);
    }
  }
}
