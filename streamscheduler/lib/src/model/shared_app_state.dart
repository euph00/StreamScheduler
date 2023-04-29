import 'package:flutter/foundation.dart';
import '../controller/sign_in_controller.dart';
import '../controller/youtube_data_controller.dart';

class SharedAppState extends ChangeNotifier {
  final SignInController signInController = SignInController();
  final YoutubeDataController youtubeDataController = YoutubeDataController();

  void login() {
    signInController.login();
  }
}
