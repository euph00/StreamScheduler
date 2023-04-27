import 'package:flutter/material.dart';
// import 'expandable_navigation_bar.dart';

bool isExpanded = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _toggleNavigationBar() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primaryContainer,
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _toggleNavigationBar,
          ),
        ),
        body: Center(
          child: Row(
            children: [
              SafeArea(
                child: ExpandableNavigationBar(
                  constraints: constraints,
                  theme: theme,
                ),
              ),
              const Expanded(
                child: Placeholder(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => print('pressed button'),
          tooltip: 'placeholder',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}

class ExpandableNavigationBar extends StatefulWidget {
  const ExpandableNavigationBar({
    super.key,
    required this.constraints,
    required this.theme,
  });

  final BoxConstraints constraints;
  final ThemeData theme;

  @override
  State<ExpandableNavigationBar> createState() =>
      _ExpandableNavigationBarState();
}

class _ExpandableNavigationBarState extends State<ExpandableNavigationBar> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.background,
    );

    return NavigationRail(
      extended: isExpanded,
      minExtendedWidth: 200,
      backgroundColor: theme.colorScheme.onBackground,
      destinations: [
        NavigationRailDestination(
            icon: Icon(
              Icons.home_outlined,
              color: theme.colorScheme.background,
            ),
            selectedIcon: Icon(
              Icons.home,
              color: theme.colorScheme.onBackground,
            ),
            label: Text(
              "Home",
              style: style,
            )),
        NavigationRailDestination(
            icon: Icon(
              Icons.subscriptions_outlined,
              color: theme.colorScheme.background,
            ),
            selectedIcon: Icon(
              Icons.subscriptions,
              color: theme.colorScheme.onBackground,
            ),
            label: Text("Subscriptions", style: style)),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) {
        setState(() {
          selectedIndex = value;
        });
      },
    );
  }
}
