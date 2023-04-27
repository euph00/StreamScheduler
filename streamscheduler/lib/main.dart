import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/home_page.dart' as home_page;
import 'src/main_app_state.dart' as main_app_state;

void main() {
  runApp(const StreamScheduler());
}

class StreamScheduler extends StatelessWidget {
  const StreamScheduler({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => main_app_state.MainAppState(),
      child: MaterialApp(
        title: 'StreamScheduler',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        ),
        home: const home_page.HomePage(title: 'StreamScheduler'),
      ),
    );
  }
}
