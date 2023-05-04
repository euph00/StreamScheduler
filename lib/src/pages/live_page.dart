import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'components/broadcast_card.dart';
import 'components/live_card.dart';

class LivePage extends StatelessWidget {
  const LivePage({super.key});
  static const int logicalPixelWidthPerCard = 800;


  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!.copyWith(
      color: Colors.black,
    );
    double screenWidth = MediaQuery.of(context).size.width;


    return Column(
      children: [
        ElevatedButton(
                  onPressed: () {
                    sharedState.updateTrackedChannels();
                  },
                  child: Text("refresh")),
        Observer(
            builder: (_) =>
                Text("____________________LIVE: ${sharedState.liveStreams.length}____________________")),
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: Observer(
                builder: (_) => GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (screenWidth/logicalPixelWidthPerCard).ceil(),
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 3),
                  children: sharedState.liveStreams.map((element) => LiveCard(broadcastItem: element)).toList(),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}