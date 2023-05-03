import 'package:flutter/material.dart';
import '../../model/broadcast_item.dart';

class BroadcastCard extends StatelessWidget {
  const BroadcastCard({super.key, required this.broadcastItem});
  final BroadcastItem broadcastItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!.copyWith(
      color: Colors.black,
    );

    return Card(
        shape: const RoundedRectangleBorder(
            side: BorderSide(
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