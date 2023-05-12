import 'package:flutter/material.dart';
import '../../model/shared_app_state.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key, required this.sharedState});
  final SharedAppState sharedState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        sharedState
            .updateSubscriptions()
            .then((value) => sharedState.updateTrackedChannels())
            .then((value) => sharedState.updateVideoLists());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      icon: const Icon(
        Icons.refresh,
        color: Colors.black,
      ),
      label: const Text(
        "refresh",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
