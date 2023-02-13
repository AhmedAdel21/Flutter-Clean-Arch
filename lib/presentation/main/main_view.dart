import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:temp/presentation/main/pages/home/view/home_page.dart';
import 'package:temp/presentation/main/pages/notifications/notification_page.dart';
import 'package:temp/presentation/main/pages/search/search_page.dart';
import 'package:temp/presentation/main/pages/settings/view/settings_page.dart';
import 'package:temp/presentation/resources/color_manager.dart';
import 'package:temp/presentation/resources/strings_manager.dart';
import 'package:temp/presentation/resources/values_manager.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    NotificationPage(),
    SettingsPage(),
  ];
  final List<String> titles = const [
    AppStrings.home,
    AppStrings.search,
    AppStrings.notifications,
    AppStrings.settings,
  ];
  String title = AppStrings.home;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // pages.add(const HomePage());
    // pages[0] = const HomePage();
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ).tr(),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
              color: ColorConstants.lightGrey,
              spreadRadius: AppSizeConstants.s1)
        ]),
        child: BottomNavigationBar(
          selectedItemColor: ColorConstants.primary,
          unselectedItemColor: ColorConstants.grey,
          currentIndex: _currentIndex,
          onTap: _onTap,
          items:  [
            BottomNavigationBarItem(
                icon:const Icon(Icons.home), label: AppStrings.home.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search), label: AppStrings.search.tr()),
            BottomNavigationBarItem(
                icon:const Icon(Icons.notifications),
                label: AppStrings.notifications.tr()),
            BottomNavigationBarItem(
                icon:const Icon(Icons.settings), label: AppStrings.settings.tr()),
          ],
        ),
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
      title = titles[_currentIndex];
    });
  }
}
