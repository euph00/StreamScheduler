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
              Expanded(child: ListView(children: sharedState.subscriptions.map((e) => SubscriptionCard(subscription: e)).toList(),)),
              ElevatedButton(onPressed: () {sharedState.updateSubscriptions();}, child: Text("refresh")),
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
    final style = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(subscription.snippet!.title!, style: style,),
        )
    );
  }
}