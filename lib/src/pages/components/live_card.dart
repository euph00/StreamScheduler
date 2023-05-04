import 'package:flutter/material.dart';
import '../../model/broadcast_item.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LiveCard extends StatelessWidget {
  const LiveCard({super.key, required this.broadcastItem});
  final BroadcastItem broadcastItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyLarge!.copyWith(
      color: Colors.black,
    );

    return Card(
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
                      'Started at: ${broadcastItem.getActualStartTime().toLocal()}',
                      style: bodyStyle,
                      maxLines: 1,
                      minFontSize: 10,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
