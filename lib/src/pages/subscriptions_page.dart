import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';
import 'package:googleapis/youtube/v3.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();

    return Column(
      children: [
        Text("no. entries: ${sharedState.subscriptions.length}"),
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: GridView.count(
                    crossAxisCount: 5,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 8.0,
                    children: sharedState.subscriptions.map((e) => SubscriptionCard(subscription: e)).toList(),
                    )
                  ),
              ElevatedButton(
                  onPressed: () {
                    sharedState.updateSubscriptions();
                  },
                  child: Text("refresh")),
            ],
          ),
        ),
      ],
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.subscription,
  });

  final Subscription subscription;

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
          )
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(child: Image.network(subscription.snippet!.thumbnails!.medium!.url!,)),
              const SizedBox(height: 10,),
              Text(
                subscription.snippet!.title!,
                style: style,
              ),
            ],
          ),
        ));
  }
}
