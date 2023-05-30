import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamscheduler/src/model/broadcast_item.dart';
import '../model/shared_app_state.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'components/live_card.dart';
import 'components/refresh_button.dart';

class LivePage extends StatelessWidget {
  const LivePage({super.key});
  static const int logicalPixelWidthPerCard = 800;

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();
    double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.onBackground,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(width: 5),
              RefreshButton(sharedState: sharedState),
              const SizedBox(width: 10),
              const _SortingDropdownButton(),
              const SizedBox(width: 10),
            ],
          ),
          Row(
            children: [
              _SearchTextField(),
              const SizedBox(width: 5),
            ],
          ),
          
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
                        childAspectRatio: 2.65),
                    children: sharedState.displayedLiveStreams
                        .map((element) => LiveCard(broadcastItem: element))
                        .toList(),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
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
    final theme = Theme.of(context);

    return DropdownButton<String>(
      dropdownColor: theme.colorScheme.onBackground,
      value: sortingDropdownValue,
      onChanged: (String? value) {
        switch (value) {
          case 'Earliest to latest':
            sharedState.displayedLiveStreams
                .setComparator(_SortingDropdownButton.earlyToLateComparator);
            break;
          case 'Latest to earliest':
            sharedState.displayedLiveStreams
                .setComparator(_SortingDropdownButton.lateToEarlyComparator);
            break;
          case 'A to Z Channel name':
            sharedState.displayedLiveStreams
                .setComparator(_SortingDropdownButton.aToZcomparator);
            break;
          case 'Z to A Channel name':
            sharedState.displayedLiveStreams
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
          child: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}

// Widget for searching by channel name
class _SearchTextField extends StatefulWidget {
  static const prompt = 'Search for livestream by channel name...';

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
      Iterable<BroadcastItem> matching = sharedState.liveStreams.where(
          (element) =>
              pattern.hasMatch(element.getChannelTitle().toLowerCase()));
      sharedState.displayedLiveStreams.clear();
      sharedState.displayedLiveStreams.addAll(matching);
    }

    return Expanded(
      child: TextField(
        style: const TextStyle(color: Colors.white),
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
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
