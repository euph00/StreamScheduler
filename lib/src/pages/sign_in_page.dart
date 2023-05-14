import 'package:flutter/material.dart';
import '../model/shared_app_state.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: Colors.white,
    );
    
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/background.png'), fit: BoxFit.cover),
      ),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 200,
          ),
          AutoSizeText(
            "Welcome to StreamScheduler",
            style: style,
            maxLines: 1,
          ),
          const SizedBox(
            height: 100,
          ),
          IconButton(
              onPressed: () => sharedState.login(),
              icon: Image.asset(
                  'assets/images/btn_google_signin_light_normal_web@2x.png'),
              padding: EdgeInsets.zero),
          
          Image.asset(
              'assets/images/developed-with-youtube-sentence-case-light.png')
        ],
      )),
    );
  }
}
