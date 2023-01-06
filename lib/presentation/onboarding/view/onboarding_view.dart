import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temp/domain/model/models.dart';
import 'package:temp/presentation/onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:temp/presentation/resources/assets_manager.dart';
import 'package:temp/presentation/resources/color_manager.dart';
import 'package:temp/presentation/resources/constants_manager.dart';
import 'package:temp/presentation/resources/routes_manager.dart';
import 'package:temp/presentation/resources/strings_manager.dart';
import 'package:temp/presentation/resources/values_manager.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();

  void _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<SliderViewObject>(
        stream: _viewModel.outputSliderViewObject,
        builder:
            (BuildContext context, AsyncSnapshot<SliderViewObject> snapshot) {
          return _getContentWidget(snapshot.data);
        },
      );

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
        elevation: AppSizeConstants.s0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorConstants.white,
            statusBarBrightness: Brightness.dark),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: sliderViewObject.numOfSliders,
        onPageChanged: (index) => _viewModel.onPageChanged(index),
        itemBuilder: (context, index) {
          return OnBoardingPage(sliderViewObject.sliderObject);
        },
      ),
      bottomSheet: Container(
        color: ColorConstants.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  AppStrings.skip,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.loginRoute);
                },
              ),
            ),
            _getBottomSheetWidget(sliderViewObject),
          ],
        ),
      ),
    );
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorConstants.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left arrow icon
          Padding(
            padding: const EdgeInsets.all(
              AppPaddingConstants.p8,
            ),
            child: GestureDetector(
                onTap: () {
                  // go to previous slide
                  _pageController.animateToPage(
                   _viewModel.goPrevious(),
                    duration: const Duration(
                        milliseconds: AppConstants.sliderAnimation),
                    curve: Curves.bounceInOut,
                  );
                },
                child: SizedBox(
                  width: AppSizeConstants.s20,
                  height: AppSizeConstants.s20,
                  child: SvgPicture.asset(ImageAssets.leftArrowIc),
                )),
          ),
          // get proper circle
          for (int counter = 0; counter < sliderViewObject.numOfSliders; counter++)
            Padding(
              padding: const EdgeInsets.all(AppPaddingConstants.p8),
              child: _getProperCircle(counter,sliderViewObject.currentIndex),
            ),

          // right arrow icon
          Padding(
            padding: const EdgeInsets.all(
              AppPaddingConstants.p8,
            ),
            child: GestureDetector(
                onTap: () {
                  // go to next slide
                  _pageController.animateToPage(
                   _viewModel.goNext(),
                    duration: const Duration(
                        milliseconds: AppConstants.sliderAnimation),
                    curve: Curves.bounceInOut,
                  );
                },
                child: SizedBox(
                  width: AppSizeConstants.s20,
                  height: AppSizeConstants.s20,
                  child: SvgPicture.asset(ImageAssets.rightArrowIc),
                )),
          )
        ],
      ),
    );
  }

  Widget _getProperCircle(int counter, int currentPageIndex) {
    if (counter == currentPageIndex) {
      return SvgPicture.asset(ImageAssets.hollowCircleIc);
    } else {
      return SvgPicture.asset(ImageAssets.solidCircleIc);
    }
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;
  const OnBoardingPage(this._sliderObject, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSizeConstants.s40,
        ),
        Padding(
          padding: const EdgeInsets.all(AppPaddingConstants.p8),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPaddingConstants.p8),
          child: Text(
            _sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        const SizedBox(
          height: AppSizeConstants.s60,
        ),
        SvgPicture.asset(_sliderObject.image),
      ],
    );
  }
}
