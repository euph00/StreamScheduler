import 'package:flutter/material.dart';
import '../../model/broadcast_item.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UpcomingCard extends StatelessWidget {
  const UpcomingCard({super.key, required this.broadcastItem});
  final BroadcastItem broadcastItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith(
      color: Colors.black,
    );

    Duration timeTillStart =
        broadcastItem.getScheduledStartTime().difference(DateTime.now());
    print(timeTillStart);
    int timeTillStartH = timeTillStart.isNegative
        ? -timeTillStart.inHours
        : timeTillStart.inHours;
    int timeTillStartM = timeTillStart.isNegative
        ? -(timeTillStart.inMinutes % 60)
        : timeTillStart.inMinutes % 60;
    print(DateTime.now().isBefore(broadcastItem.getScheduledStartTime()));
    String timeTillStartHM = "$timeTillStartH Hours, $timeTillStartM Minutes";

    return GestureDetector(
      onDoubleTap: () => broadcastItem.launchVideoUrl(),
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.black,
              )),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                    child: Image.network(
                  broadcastItem.getThumbnailUrl(),
                )),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeText(
                        broadcastItem.getChannelTitle(),
                        style: bodyStyle,
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                      const Divider(),
                      AutoSizeText(
                        broadcastItem.getVideoTitle(),
                        style: bodyStyle,
                        maxLines: 2,
                        minFontSize: 10,
                      ),
                      const Divider(),
                      AutoSizeText(
                        'Scheduled for: ${broadcastItem.getScheduledStartTime().toLocal()}',
                        style: bodyStyle,
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                      AutoSizeText(
                        'Time till start: $timeTillStartHM',
                        style: bodyStyle,
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
