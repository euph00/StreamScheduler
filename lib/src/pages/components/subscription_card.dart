import 'package:flutter/material.dart';
import '../../model/subscription_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import '../../model/shared_app_state.dart';

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
    final style = theme.textTheme.bodyLarge!.copyWith(
      color: Colors.white,
    );
    var sharedState = context.watch<SharedAppState>();

    return GestureDetector(
      onDoubleTap: () => widget.subscription.launchChannelUrl(),
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.grey,
              )),
          color: theme.colorScheme.onBackground,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.subscription.getThumbnailUrl(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: widget.subscription.isChecked,
                        onChanged: (checkStatus) {
                          setState(() {
                            widget.subscription.setCheck(checkStatus!);
                            sharedState.updateTrackedChannels();
                          });
                        }),
                    Flexible(
                      child: AutoSizeText(
                        widget.subscription.getChannelTitle(),
                        style: style,
                        minFontSize: 12,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
