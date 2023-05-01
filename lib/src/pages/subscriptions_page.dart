import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();
    
    return ListView(children: sharedState.subscriptions.map((e) => Text(e.snippet!.title!)).toList(),);
  }
}
