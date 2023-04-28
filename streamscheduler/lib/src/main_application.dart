import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/subscriptions_page.dart';
import 'package:yt/yt.dart';
import 'shared_app_state.dart';
import 'yt_login_generator.dart';
import 'secrets/secrets.dart';


class MainApplication extends StatefulWidget {
  const MainApplication({super.key, required this.title});
  final String title;

  @override
  State<MainApplication> createState() => _MainApplicationState();
}

class _MainApplicationState extends State<MainApplication> {
  bool _isExpanded = false;
  var _selectedIndex = 0;
  late final Yt yt;

  void _toggleNavigationBar() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void login() async {
    yt = await Yt.withGenerator(YtLoginGenerator());
    // YtLoginGenerator().generate();
  }

  @override
  void initState() {
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.background,
    );

    var sharedState = context.watch<MainAppState>();

    

    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = SubscriptionsPage();
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
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(child: page,),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("pressed");
          },
          tooltip: 'placeholder',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
