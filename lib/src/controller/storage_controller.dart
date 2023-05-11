import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import '../model/channel_item.dart';

class StorageController {
  void saveTrackedChannels(Iterable<ChannelItem> trackedChannels) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setStringList('trackedChannels', trackedChannels.map((e) => e.getChannelId()).toList());
  }

  void saveTrackedChannelsById(Iterable<String> trackedChannels) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setStringList('trackedChannels', trackedChannels.toList());
  }

  Future<Set<String>> retrieveTrackedChannels() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    List<String>? items = storage.getStringList('trackedChannels');
    if (items == null) return HashSet();
    Set<String> result = HashSet.from(items);
    return result;
  }
}