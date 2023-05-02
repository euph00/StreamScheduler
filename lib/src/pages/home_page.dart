import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../model/subscription_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!.copyWith(
      color: Colors.black,
    );

    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                sharedState.updateTrackedChannels();
              },
              child: Text("refresh")),
          const SizedBox(
            height: 10,
          ),
          Observer(
              builder: (_) => Text(
                    "____________________LIVE: ${sharedState.liveStreams.length}____________________",
                  )),
          Observer(
              builder: (_) => Column(
                    children: sharedState.liveStreams
                        .map((element) => Text(
                              element.getVideoTitle(),
                              style: style,
                            ))
                        .toList(),
                  )),
          const SizedBox(
            height: 20,
          ),
          Observer(
              builder: (_) => Text(
                    "____________________UPCOMING: ${sharedState.upcomingStreams.length}____________________",
                  )),
          Observer(
              builder: (_) => Column(
                    children: sharedState.upcomingStreams
                        .map((element) => Text(
                              element.getVideoTitle(),
                              style: style,
                            ))
                        .toList(),
                  )),
        ],
      ),
    );
  }
}
