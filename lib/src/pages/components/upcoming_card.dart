import 'package:flutter/material.dart';
import '../../model/broadcast_item.dart';

class LiveCard extends StatelessWidget {
  const LiveCard({super.key, required this.broadcastItem});
  final BroadcastItem broadcastItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!.copyWith(
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
          child: Column(
            children: [
              Expanded(
                  child: Image.network(
                broadcastItem.getThumbnailUrl(),
              )),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      broadcastItem.getVideoTitle(),
                      style: style,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}