import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'components/homepage_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const int logicalPixelWidthPerCard = 800;

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();
    double screenWidth = MediaQuery.of(context).size.width;
    if (sharedState.isColdBoot) {
      sharedState
          .updateSubscriptions()
          .then((value) => sharedState.updateTrackedChannels())
          .then((value) => sharedState.updateVideoLists());
      sharedState.isColdBoot = false;
    }

    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              sharedState
                  .updateSubscriptions()
                  .then((value) => sharedState.updateTrackedChannels())
                  .then((value) => sharedState.updateVideoLists());
            },
            child: const Text("refresh")),
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: Observer(
                builder: (_) => GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (screenWidth / logicalPixelWidthPerCard).ceil(),
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 2.9),
                  children: sharedState.homePageList
                      .map((element) => HomepageCard(broadcastItem: element))
                      .toList(),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
