import 'dart:async';

import 'package:temp/domain/models.dart';
import 'package:temp/presentation/base/baseviewmodel.dart';
import 'package:temp/presentation/resources/assets_manager.dart';
import 'package:temp/presentation/resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  // private variables
  final StreamController<SliderViewObject> _streamController =
      StreamController<SliderViewObject>();
  late final List<SliderObject> _list;
  int _currentPageIndex = 0;
  // OnBoarding ViewModel Initialization
  @override
  void start() {
    _list = _getSliderData();
    _currentPageIndex = 0;
    _postDataToView();
  }

  @override
  void dispose() {
    _streamController.close();
  }

  // OnBoarding ViewModel Inputs
  @override
  int goNext() {
    int nextIndex = _currentPageIndex + 1;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = _currentPageIndex - 1;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentPageIndex = index;
    _postDataToView();
  }

  @override
  Sink<SliderViewObject> get inputSliderViewObject => _streamController.sink;

  // OnBoarding ViewModel outputs
  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);

  // OnBoarding private functions
  void _postDataToView() {
    inputSliderViewObject.add(SliderViewObject(
        _list[_currentPageIndex], _list.length, _currentPageIndex));
  }

  List<SliderObject> _getSliderData() {
    return [
      SliderObject(AppStrings.onBoardingTitle1, AppStrings.onBoardingSubTitle1,
          ImageAssets.onboardingLogo1),
      SliderObject(AppStrings.onBoardingTitle2, AppStrings.onBoardingSubTitle2,
          ImageAssets.onboardingLogo2),
      SliderObject(AppStrings.onBoardingTitle3, AppStrings.onBoardingSubTitle3,
          ImageAssets.onboardingLogo3),
      SliderObject(AppStrings.onBoardingTitle4, AppStrings.onBoardingSubTitle4,
          ImageAssets.onboardingLogo4),
    ];
  }
}

// inputs mean that "Orders" that our view model will  receive from View
abstract class OnBoardingViewModelInputs {
  int goNext(); // when user clicks on the right arrow or swipe left
  int goPrevious(); // when user clicks on the left arrow or swipe right
  void onPageChanged(
      int index); // when page index changed will receive the new index
  // stream controller input
  Sink<SliderViewObject> get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutputs {
  // stream controller output
  Stream<SliderViewObject> get outputSliderViewObject;
}
