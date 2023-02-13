import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temp/app/app_prefs.dart';
import 'package:temp/app/di.dart';
import 'package:temp/data/data_source/local_data_source.dart';
import 'package:temp/presentation/resources/assets_manager.dart';
import 'package:temp/presentation/resources/language_manager.dart';
import 'package:temp/presentation/resources/routes_manager.dart';
import 'package:temp/presentation/resources/strings_manager.dart';
import 'package:temp/presentation/resources/values_manager.dart';
import 'dart:math' as math;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  Widget getTrailing() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
      child: SvgPicture.asset(ImageAssets.rightArrowSettingsIc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPaddingConstants.p8),
        children: [
          ListTile(
            leading: SvgPicture.asset(ImageAssets.changeLangIc),
            title: Text(
              AppStrings.changeLanguage,
              style: Theme.of(context).textTheme.bodyLarge,
            ).tr(),
            trailing: getTrailing(),
            onTap: _changeLanguage,
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.contactUsIc),
            title: Text(
              AppStrings.contactUs,
              style: Theme.of(context).textTheme.bodyLarge,
            ).tr(),
            trailing: getTrailing(),
            onTap: _contactUs,
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.inviteFriendsIc),
            title: Text(
              AppStrings.inviteYourFriends,
              style: Theme.of(context).textTheme.bodyLarge,
            ).tr(),
            trailing: getTrailing(),
            onTap: _inviteFriends,
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.logoutIc),
            title: Text(
              AppStrings.logout,
              style: Theme.of(context).textTheme.bodyLarge,
            ).tr(),
            trailing: getTrailing(),
            onTap: _logOut,
          ),
        ],
      ),
    );
  }

  bool isRtl() {
    return context.locale == LanguageLocaleConstant.arabicLocale;
  }

  void _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  void _contactUs() {}

  void _inviteFriends() {
    // task to share app name to friends
  }

  void _logOut() async {
    // navigate to login screen
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
    // clear shared pref
    await _appPreferences.logOut();
    // clear run time cache
    _localDataSource.clearCache();
  }
}
