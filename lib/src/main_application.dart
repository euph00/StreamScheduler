import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamscheduler/src/pages/sign_in_page.dart';
import 'pages/home_page.dart';
import 'pages/subscriptions_page.dart';
import 'model/shared_app_state.dart';
import 'pages/upcoming_page.dart';
import 'pages/live_page.dart';
import '../main.dart';

class MainApplication extends StatefulWidget {
  const MainApplication({super.key, required this.title});
  final String title;

  @override
  State<MainApplication> createState() => _MainApplicationState();
}

class _MainApplicationState extends State<MainApplication> {
  bool _isExpanded = false;
  var _selectedIndex = 0;

  void _toggleNavigationBar() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.background,
    );

    var sharedState = context.watch<SharedAppState>();

    // if not signed in, display sign in screen
    if (!sharedState.verifyLoginStatus()) {
      print("not signed in");
      return const Scaffold(
        body: SignInPage(),
      );
    }

    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const SubscriptionsPage();
        break;
      case 2:
        page = const UpcomingPage();
        break;
      case 3:
        page = const LivePage();
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primaryContainer,
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _toggleNavigationBar,
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  sharedState.reset(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: theme.colorScheme.background,
                ))
          ],
        ),
        body: Center(
          child: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: _isExpanded,
                  minExtendedWidth: 200,
                  backgroundColor: theme.colorScheme.onBackground,
                  destinations: [
                    NavigationRailDestination(
                        //index 0
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
                        //index 1
                        icon: Icon(
                          Icons.subscriptions_outlined,
                          color: theme.colorScheme.background,
                        ),
                        selectedIcon: Icon(
                          Icons.subscriptions,
                          color: theme.colorScheme.onBackground,
                        ),
                        label: Text("Subscriptions", style: style)),
                    NavigationRailDestination(
                        //index 2
                        icon: Icon(
                          Icons.upcoming_outlined,
                          color: theme.colorScheme.background,
                        ),
                        selectedIcon: Icon(
                          Icons.upcoming,
                          color: theme.colorScheme.onBackground,
                        ),
                        label: Text("Upcoming", style: style)),
                    NavigationRailDestination(
                        //index 3
                        icon: Icon(
                          Icons.live_tv_outlined,
                          color: theme.colorScheme.background,
                        ),
                        selectedIcon: Icon(
                          Icons.live_tv,
                          color: theme.colorScheme.onBackground,
                        ),
                        label: Text("Live", style: style)),
                  ],
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      if (value == 1 && sharedState.subscriptions.isEmpty) {
                        sharedState.updateSubscriptions();
                      }
                      _selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  child: page,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
