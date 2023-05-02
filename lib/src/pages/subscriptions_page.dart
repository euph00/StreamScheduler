import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../model/subscription_item.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();

    return Column(
      children: [
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0),
                  itemBuilder: (context, index) {
                    return SubscriptionCard(
                        subscription: sharedState.subscriptions[index]);
                  },
                ),
              )),
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

class SubscriptionCard extends StatefulWidget {
  const SubscriptionCard({
    super.key,
    required this.subscription,
  });

  final SubscriptionItem subscription;

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
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
                widget.subscription.getThumbnailUrl(),
              )),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Checkbox(
                      value: widget.subscription.isChecked,
                      onChanged: (checkStatus) {
                        setState(
                            () => {widget.subscription.setCheck(checkStatus!)});
                      }),
                  Flexible(
                    child: Text(
                      widget.subscription.getChannelTitle(),
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
