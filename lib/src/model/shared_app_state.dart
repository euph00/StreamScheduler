import 'package:flutter/foundation.dart';
import 'package:googleapis/youtube/v3.dart';
import '../controller/sign_in_controller.dart';
import '../controller/youtube_data_controller.dart';
import 'package:mobx/mobx.dart';
import 'subscription_item.dart';

class SharedAppState extends ChangeNotifier {
  final SignInController signInController = SignInController();
  final YoutubeDataController youtubeDataController = YoutubeDataController();
  final ObservableList<SubscriptionItem> subscriptions = ObservableList<SubscriptionItem>.of(<SubscriptionItem>[]);
  final ObservableList<Channel> _trackedChannels = ObservableList<Channel>.of(<Channel>[]);

  // Login

  void login() async {
    signInController.login().then((value) => notifyListeners());
  }

  bool verifyLoginStatus() {
    return signInController.getAuthStatus();
  }

  // Subscriptions

  void updateSubscriptions() async {
    subscriptions.clear();
    subscriptions.addAll((await youtubeDataController.getSubscriptions()).map((e) => SubscriptionItem(sub: e)));
  }

  // Filtered channels
  

  void _testFunction() {
    var sub = subscriptions[1];
    var channelId = sub.getChannelId();
    youtubeDataController.test(channelId);
  }
}
