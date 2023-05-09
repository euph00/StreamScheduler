import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamscheduler/src/model/subscription_item.dart';
import '../model/shared_app_state.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'components/subscription_card.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});
  static const int logicalPixelWidthPerCard = 300;

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
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  sharedState.updateSubscriptions();
                },
                child: Text("refresh")),
            const SizedBox(width: 5),
            const _SortingDropdownButton(),
            const SizedBox(width: 5),
            const _FilteringDropdownButton(),
            const SizedBox(width: 5),
            _SearchTextField(),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        Observer(
            builder: (_) => Text(
                "no. entries: ${sharedState.displayedSubscriptions.length}")),
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: Observer(
                builder: (_) => GridView.builder(
                  itemCount: sharedState.displayedSubscriptions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (screenWidth / logicalPixelWidthPerCard).ceil(),
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0),
                  itemBuilder: (context, index) {
                    return SubscriptionCard(
                        subscription:
                            sharedState.displayedSubscriptions[index]);
                  },
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
const List<String> _sortingOptions = <String>['Unsorted', 'A to Z', 'Z to A'];

class _SortingDropdownButton extends StatefulWidget {
  const _SortingDropdownButton({super.key});
  static Comparator<SubscriptionItem> aToZcomparator =
      (a, b) => a.getChannelTitle().compareTo(b.getChannelTitle());
  static Comparator<SubscriptionItem> zToAcomparator =
      (a, b) => -(a.getChannelTitle().compareTo(b.getChannelTitle()));

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
          case 'Unsorted':
            sharedState.displayedSubscriptions.setComparator(
                (a, b) => 0); // all elements equal, no preferred sort order
            break;
          case 'A to Z':
            sharedState.displayedSubscriptions
                .setComparator(_SortingDropdownButton.aToZcomparator);
            break;
          case 'Z to A':
            sharedState.displayedSubscriptions
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

// Widget for selecting filter option
const List<String> _filterOptions = <String>[
  'No filter',
  'Checked',
  'Unchecked'
];

class _FilteringDropdownButton extends StatefulWidget {
  const _FilteringDropdownButton({super.key});

  @override
  State<_FilteringDropdownButton> createState() =>
      __FilteringDropdownButtonState();
}

class __FilteringDropdownButtonState extends State<_FilteringDropdownButton> {
  String filteringDropdownValue = _filterOptions.first;

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();

    return DropdownButton<String>(
      value: filteringDropdownValue,
      onChanged: (String? value) {
        switch (value) {
          case 'No filter':
            sharedState.displayedSubscriptions.clear();
            sharedState.displayedSubscriptions
                .setFilter((element) => true); // no filter, allow all elements
            sharedState.displayedSubscriptions
                .addAll(sharedState.subscriptions);
            break;
          case 'Checked':
            sharedState.displayedSubscriptions.clear();
            sharedState.displayedSubscriptions
                .setFilter((element) => element.isChecked);
            sharedState.displayedSubscriptions
                .addAll(sharedState.subscriptions);
            break;
          case 'Unchecked':
            sharedState.displayedSubscriptions.clear();
            sharedState.displayedSubscriptions
                .setFilter((element) => !element.isChecked);
            sharedState.displayedSubscriptions
                .addAll(sharedState.subscriptions);
            break;
          default:
            throw UnimplementedError(
                "No such option for filtering: $filteringDropdownValue");
        }
        setState(() {
          filteringDropdownValue = value!;
        });
      },
      items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
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
  static const prompt = 'Search for a channel by name...';

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
      Iterable<SubscriptionItem> matching = sharedState.subscriptions.where(
          (element) =>
              pattern.hasMatch(element.getChannelTitle().toLowerCase()));
      sharedState.displayedSubscriptions.clear();
      sharedState.displayedSubscriptions.addAll(matching);
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
