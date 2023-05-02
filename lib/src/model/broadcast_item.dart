import 'video_item.dart';

class BroadcastItem extends VideoItem {
  BroadcastItem({
    required super.vid,
  });

  DateTime getActualStartTime() {
    return super.vid.liveStreamingDetails!.actualStartTime!;
  }

  DateTime getActualEndTime() {
    return super.vid.liveStreamingDetails!.actualEndTime!;
  }

  DateTime getScheduledStartTime() {
    return super.vid.liveStreamingDetails!.scheduledStartTime!;
  }

  DateTime getScheduledEndTime() {
    return super.vid.liveStreamingDetails!.scheduledEndTime!;
  }

  String getConcurrentViewers() {
    return super.vid.liveStreamingDetails!.concurrentViewers!;
  }
}