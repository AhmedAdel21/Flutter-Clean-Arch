import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:temp/presentation/resources/assets_manager.dart';
import 'package:temp/presentation/resources/color_manager.dart';
import 'package:temp/presentation/resources/font_manager.dart';
import 'package:temp/presentation/resources/strings_manager.dart';
import 'package:temp/presentation/resources/styles_manager.dart';
import 'package:temp/presentation/resources/values_manager.dart';

enum StateRendererType {
  // popup states (Dialog)
  popupLoadingState,
  popupErrorState,
  popupSuccessState,
  // full screen states
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

  // general
  contentState,
}

class StateRenderer extends StatelessWidget {
  final StateRendererType stateRendererType;
  final String message;
  final String title;
  final Function retryAction;

  const StateRenderer({
    required this.stateRendererType,
    required this.retryAction,
    this.message = AppStrings.loading,
    this.title = "",
    super.key,
  });

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message),
        ]);
      case StateRendererType.popupErrorState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.ok, context),
        ]);
      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message),
        ]);
      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.retryAgain, context),
        ]);
      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.empty),
          _getMessage(message),
        ]);
      case StateRendererType.popupSuccessState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.success),
          _getMessage(title),
          _getMessage(message),
          _getRetryButton(AppStrings.ok, context),
        ]);
      case StateRendererType.contentState:
        return Container();
    }
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getPopUpDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizeConstants.s14),
      ),
      elevation: AppSizeConstants.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: ColorConstants.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppSizeConstants.s14),
            boxShadow: const [BoxShadow(color: Colors.black26)]),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
      height: AppSizeConstants.s100,
      width: AppSizeConstants.s100,
      child: Lottie.asset(animationName),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPaddingConstants.p18),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (stateRendererType == StateRendererType.fullScreenErrorState) {
                // call retry function
                retryAction.call();
              } else {
                // popup error state
                Navigator.of(context).pop();
              }
            },
            child: Text(buttonTitle).tr(),
          ),
        ),
      ),
    );
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPaddingConstants.p8),
        child: Text(
          message,
          style: getRegularStyle(
            fontSize: FontSizeConstants.s18,
            color: ColorConstants.black,
          ),
          textAlign: TextAlign.center,
        ).tr(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }
}
