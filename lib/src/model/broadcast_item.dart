import 'video_item.dart';

class BroadcastItem extends VideoItem {
  BroadcastItem({
    required super.vid,
  });

  DateTime getActualStartTime() {
    try {
      return super.vid.liveStreamingDetails!.actualStartTime!;
    } on TypeError catch (e) {
      print(e.toString());
      return DateTime.now();
    }
  }

  DateTime getActualEndTime() {
    try {
      return super.vid.liveStreamingDetails!.actualEndTime!;
    } on TypeError catch (e) {
      print(e.toString());
      return DateTime.now();
    }
  }

  DateTime getScheduledStartTime() {
    try {
      return super.vid.liveStreamingDetails!.scheduledStartTime!;
    } on TypeError catch (e) {
      print(e.toString());
      return DateTime.now();
    }
  }

  DateTime getScheduledEndTime() {
    try {
      return super.vid.liveStreamingDetails!.scheduledEndTime!;
    } on TypeError catch (e) {
      print(e.toString());
      return DateTime.now();
    }
  }

  String getConcurrentViewers() {
    try {
      return super.vid.liveStreamingDetails!.concurrentViewers!;
    } on TypeError catch (e) {
      print(e.toString());
      return "No live viewership data";
    }
  }
}
