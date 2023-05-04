import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'components/subscription_card.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});
  static const int logicalPixelWidthPerCard = 300;

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        ElevatedButton(
                  onPressed: () {
                    sharedState.updateSubscriptions();
                  },
                  child: Text("refresh")),
        Observer(
            builder: (_) =>
                Text("no. entries: ${sharedState.subscriptions.length}")),
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: Observer(
                builder: (_) => GridView.builder(
                  itemCount: sharedState.subscriptions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (screenWidth/logicalPixelWidthPerCard).ceil(),
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0),
                  itemBuilder: (context, index) {
                    return SubscriptionCard(
                        subscription: sharedState.subscriptions[index]);
                  },
                ),
              )),
              
            ],
          ),
        ),
      ],
    );
  }
}
