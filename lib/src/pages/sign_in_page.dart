import 'package:flutter/material.dart';
import '../model/shared_app_state.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var sharedState = context.watch<SharedAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.secondary,
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 180,),
          Text("Please sign in with Google", style: style,),
          SizedBox(height: 20,),
          IconButton(onPressed: () => sharedState.login(), icon: Image.asset('assets/images/btn_google_signin_dark_normal_web@2x.png'), padding: EdgeInsets.zero),
          SizedBox(height: 200,),
          Image.asset('assets/images/developed-with-youtube-sentence-case-dark.png')
        ],
      )
    );
  }
}