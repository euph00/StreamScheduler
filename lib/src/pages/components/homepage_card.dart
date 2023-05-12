import 'package:flutter/material.dart';
import '../../model/broadcast_item.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomepageCard extends StatelessWidget {
  const HomepageCard({super.key, required this.broadcastItem});
  final BroadcastItem broadcastItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith(
      color: Colors.white,
    );
    final String itemType = broadcastItem.getLiveBroadcastContent() == 'live'
        ? "LIVE"
        : "UPCOMING @ ${broadcastItem.getScheduledStartTime().toLocal()}";

    return GestureDetector(
      onDoubleTap: () => broadcastItem.launchVideoUrl(),
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.grey,
              )),
          color: theme.colorScheme.onBackground,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      broadcastItem.getThumbnailUrl(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeText(
                        itemType,
                        style: bodyStyle,
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                      const Divider(),
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
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          )),
    );
  }
}
