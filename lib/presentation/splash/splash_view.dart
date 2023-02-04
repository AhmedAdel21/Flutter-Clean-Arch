import 'dart:async';

import 'package:flutter/material.dart';
import 'package:temp/app/app_prefs.dart';
import 'package:temp/app/di.dart';
import 'package:temp/presentation/resources/assets_manager.dart';
import 'package:temp/presentation/resources/color_manager.dart';
import 'package:temp/presentation/resources/constants_manager.dart';
import 'package:temp/presentation/resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();
  void _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  void _goNext() {
    // Navigator.pushReplacementNamed(context, Routes.mainRoute);
    bool isUserLoggedIn = _appPreferences.isUserLoggedIn();
    if (isUserLoggedIn) {
      // navigate to main Screen
      Navigator.pushReplacementNamed(context, Routes.mainRoute);
    } else {
      bool isOnBoardingViewed = _appPreferences.isOnBoardingScreenViewed();
      if (isOnBoardingViewed) {
        // navigate to login screen
        Navigator.pushReplacementNamed(context, Routes.loginRoute);
      } else {
        // navigate to OnBoarding Screen
        Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorConstants.primary,
      body: Center(child: Image(image: AssetImage(ImageAssets.splashLogo))),
    );
  }
}
