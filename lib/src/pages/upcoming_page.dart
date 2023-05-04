import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'components/broadcast_card.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key});
  static const int logicalPixelWidthPerCard = 300;

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
                Text("____________________UPCOMING: ${sharedState.upcomingStreams.length}____________________")),
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: Observer(
                builder: (_) => GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (screenWidth/logicalPixelWidthPerCard).ceil(),
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0),
                  children: sharedState.upcomingStreams.map((element) => BroadcastCard(broadcastItem: element)).toList(),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}