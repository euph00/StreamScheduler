import 'package:flutter/foundation.dart';
import 'package:googleapis/youtube/v3.dart';
import '../controller/sign_in_controller.dart';
import '../controller/youtube_data_controller.dart';
import 'package:mobx/mobx.dart';

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