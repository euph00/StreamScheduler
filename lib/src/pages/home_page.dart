import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../model/subscription_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();

    return Center(
      child: ElevatedButton(
          onPressed: () {
            sharedState.updateTrackedChannels();
          },
          child: Text("refresh")),
    );
  }
}
