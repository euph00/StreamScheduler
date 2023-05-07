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
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  sharedState.updateSubscriptions();
                },
                child: Text("refresh")),
            const _SortingDropdownButton(),
            const _FilteringDropdownButton(),
          ],
        ),
        Observer(
            builder: (_) =>
                Text("no. entries: ${sharedState.displayedSubscriptions.length}")),
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
                        subscription: sharedState.displayedSubscriptions[index]);
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
  static Comparator<SubscriptionItem> aToZcomparator = (a, b) => a.getChannelTitle().compareTo(b.getChannelTitle()); 
  static Comparator<SubscriptionItem> zToAcomparator = (a, b) => -(a.getChannelTitle().compareTo(b.getChannelTitle())); 

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
            sharedState.displayedSubscriptions.setComparator((a, b) => 0); // all elements equal, no preferred sort order
            break;
          case 'A to Z':
            sharedState.displayedSubscriptions.setComparator(_SortingDropdownButton.aToZcomparator);
            break;
          case 'Z to A':
            sharedState.displayedSubscriptions.setComparator(_SortingDropdownButton.zToAcomparator);
            break;
          default:
            throw UnimplementedError("No such option for sorting: $sortingDropdownValue");
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
const List<String> _filterOptions = <String>['No filter', 'Checked', 'Unchecked'];
class _FilteringDropdownButton extends StatefulWidget {
  const _FilteringDropdownButton({super.key});

  @override
  State<_FilteringDropdownButton> createState() => __FilteringDropdownButtonState();
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
          sharedState.displayedSubscriptions.addAll(sharedState.subscriptions);
            break;
          case 'Checked':
            List<SubscriptionItem> checked = sharedState.subscriptions.where((element) => element.isChecked).toList();
            sharedState.displayedSubscriptions.clear();
            sharedState.displayedSubscriptions.addAll(checked);
            break;
          case 'Unchecked':
            List<SubscriptionItem> unchecked = sharedState.subscriptions.where((element) => !element.isChecked).toList();
            sharedState.displayedSubscriptions.clear();
            sharedState.displayedSubscriptions.addAll(unchecked);
            break;
          default:
            throw UnimplementedError("No such option for filtering: $filteringDropdownValue");
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
