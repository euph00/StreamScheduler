import 'package:googleapis/youtube/v3.dart';

class SubscriptionItem {
  SubscriptionItem({
    required this.sub,
  });

  final Subscription sub;
  bool isChecked = false;

  void setCheck(bool checkStatus) {
    isChecked = checkStatus;
    print(isChecked);
  }

  String getThumbnailUrl() {
    return sub.snippet!.thumbnails!.medium!.url!;
  }

  String getChannelId() {
    return sub.snippet!.resourceId!.channelId!;
  }

  String getChannelTitle() {
    return sub.snippet!.title!;
  }
}
