import 'package:flutter/foundation.dart';
import 'package:googleapis/youtube/v3.dart';
import '../controller/sign_in_controller.dart';
import '../controller/youtube_data_controller.dart';

class SharedAppState extends ChangeNotifier {
  final SignInController signInController = SignInController();
  final YoutubeDataController youtubeDataController = YoutubeDataController();
  final List<Subscription> subscriptions = <Subscription>[];

  void login() async {
    signInController.login().then((value) => notifyListeners());
  }

  void updateSubscriptions() async {
    subscriptions.clear();
    for (Subscription sub in await youtubeDataController.getSubscriptions()) {
      subscriptions.add(sub);
    }
    _testFunction();
    notifyListeners();
  }

  bool verifyLoginStatus() {
    return signInController.getAuthStatus();
  }

  void _testFunction() {
    var sub = subscriptions[1];
    var channelId = sub.snippet!.resourceId!.channelId!;
    youtubeDataController.test(channelId);
  }
}
