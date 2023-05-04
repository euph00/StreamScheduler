import 'package:flutter/material.dart';
import '../../model/broadcast_item.dart';

class LiveCard extends StatelessWidget {
  const LiveCard({super.key, required this.broadcastItem});
  final BroadcastItem broadcastItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.bodyLarge!.copyWith(
      color: Colors.black,
    );
    final bodyStyle = theme.textTheme.bodyMedium!.copyWith(
      color: Colors.black,
    );

    return 
        Column(
          children: [
            Card(
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
                          children: [
                            Text(broadcastItem.getChannelTitle()),
                            Text('____________________Title____________________', style: headerStyle,),
                            Text(
                            broadcastItem.getVideoTitle(),
                            style: bodyStyle,
                            ),
                            Text('____________________Started____________________', style: headerStyle,),
                            Text('${broadcastItem.getActualStartTime().toLocal()}')
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        );
  }
}