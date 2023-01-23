import 'package:flutter/material.dart';
import 'package:temp/presentation/resources/color_manager.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: ColorConstants.white,
        body: Center(
          child: Text("dola"),
        ));
  }
}
