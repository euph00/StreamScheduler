import 'package:flutter/material.dart';
import '../../model/subscription_item.dart';

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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
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
