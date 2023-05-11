import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/shared_app_state.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'components/upcoming_card.dart';
import 'package:streamscheduler/src/model/broadcast_item.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key});
  static const int logicalPixelWidthPerCard = 800;

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const SizedBox(width: 5),
            ElevatedButton(
                onPressed: () {
                  sharedState.updateVideoLists();
                },
                child: const Text("refresh")),
            const SizedBox(width: 5),
            const _SortingDropdownButton(),
            const SizedBox(width: 5),
            _SearchTextField(),
            const SizedBox(width: 5),
          ],
        ),
        Observer(
            builder: (_) => Text(
                "____________________UPCOMING: ${sharedState.displayedUpcomingStreams.length}____________________")),
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
                  children: sharedState.displayedUpcomingStreams
                      .map((element) => UpcomingCard(broadcastItem: element))
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

// Widget for selecting sort option
const List<String> _sortingOptions = <String>[
  'Earliest to latest',
  'Latest to earliest',
  'A to Z Channel name',
  'Z to A Channel name'
];

class _SortingDropdownButton extends StatefulWidget {
  const _SortingDropdownButton({super.key});
  static Comparator<BroadcastItem> aToZcomparator =
      (a, b) => a.getChannelTitle().compareTo(b.getChannelTitle());
  static Comparator<BroadcastItem> zToAcomparator =
      (a, b) => -(a.getChannelTitle().compareTo(b.getChannelTitle()));
  static Comparator<BroadcastItem> earlyToLateComparator =
      (a, b) => a.getActualStartTime().compareTo(b.getActualStartTime());
  static Comparator<BroadcastItem> lateToEarlyComparator =
      (a, b) => -(a.getActualStartTime().compareTo(b.getActualStartTime()));

  @override
  State<_SortingDropdownButton> createState() => __SortingDropdownButtonState();
}

class __SortingDropdownButtonState extends State<_SortingDropdownButton> {
  String sortingDropdownValue = _sortingOptions.first;

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();
    return DropdownButton<String>(
      value: sortingDropdownValue,
      onChanged: (String? value) {
        switch (value) {
          case 'Earliest to latest':
            sharedState.displayedUpcomingStreams
                .setComparator(_SortingDropdownButton.earlyToLateComparator);
            break;
          case 'Latest to earliest':
            sharedState.displayedUpcomingStreams
                .setComparator(_SortingDropdownButton.lateToEarlyComparator);
            break;
          case 'A to Z Channel name':
            sharedState.displayedUpcomingStreams
                .setComparator(_SortingDropdownButton.aToZcomparator);
            break;
          case 'Z to A Channel name':
            sharedState.displayedUpcomingStreams
                .setComparator(_SortingDropdownButton.zToAcomparator);
            break;
          default:
            throw UnimplementedError(
                "No such option for sorting: $sortingDropdownValue");
        }
        setState(() {
          sortingDropdownValue = value!;
        });
      },
      items: _sortingOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

// Widget for searching by channel name
class _SearchTextField extends StatefulWidget {
  static const prompt = 'Search for upcoming livestream by channel name...';

  @override
  State<_SearchTextField> createState() => __SearchTextFieldState();
}

class __SearchTextFieldState extends State<_SearchTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();

    void filterForName(String value) {
      final pattern = RegExp(".*${value.toLowerCase()}.*");
      Iterable<BroadcastItem> matching = sharedState.upcomingStreams.where(
          (element) =>
              pattern.hasMatch(element.getChannelTitle().toLowerCase()));
      sharedState.displayedUpcomingStreams.clear();
      sharedState.displayedUpcomingStreams.addAll(matching);
    }

    return Expanded(
      child: TextField(
        controller: _controller,
        onSubmitted: (value) {
          filterForName(value);
        },
        onChanged: (String value) {
          filterForName(value);

          _controller.value = TextEditingValue(
              text: value,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: value.characters.length)));
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: _SearchTextField.prompt,
        ),
      ),
    );
  }
}
