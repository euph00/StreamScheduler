import 'package:googleapis/youtube/v3.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String getChannelUrl() {
    return "https://www.youtube.com/channel/${getChannelId()}";
  }

  Future<void> launchChannelUrl() async {
    Uri url = Uri.parse(getChannelUrl());
    if (!await launchUrl(url)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  int get hashCode => getChannelId().hashCode;

  @override
  bool operator ==(Object other) {
    return other is SubscriptionItem && other.getChannelId() == getChannelId();
  }
}
