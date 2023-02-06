import 'package:flutter/material.dart';
import 'package:temp/presentation/resources/color_manager.dart';
import 'package:temp/presentation/resources/font_manager.dart';
import 'package:temp/presentation/resources/values_manager.dart';
import 'package:temp/presentation/styles_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main colors
    primaryColor: ColorConstants.primary,
    primaryColorLight: ColorConstants.lightPrimary,
    primaryColorDark: ColorConstants.darkPrimary,
    disabledColor: ColorConstants.grey1DisabledColor,
    splashColor: ColorConstants.lightPrimary,

    // cardView Theme
    cardTheme: const CardTheme(
      color: ColorConstants.white,
      shadowColor: ColorConstants.grey,
      elevation: AppSizeConstants.s4,
    ),

    // app bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorConstants.primary,
      elevation: AppSizeConstants.s4,
      shadowColor: ColorConstants.lightPrimary,
      titleTextStyle: getRegularStyle(
        fontSize: FontSizeConstants.s14,
        color: ColorConstants.white,
      ),
    ),

    // button theme
    buttonTheme: const ButtonThemeData(
      shape: StadiumBorder(),
      disabledColor: ColorConstants.grey1DisabledColor,
      splashColor: ColorConstants.lightPrimary,
      buttonColor: ColorConstants.primary,
    ),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
          color: ColorConstants.white,
          fontSize: FontSizeConstants.s18,
        ),
        backgroundColor: ColorConstants.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSizeConstants.s12,
          ),
        ),
      ),
    ),

    // text theme
    textTheme: TextTheme(
      displayLarge: getSemiBoldStyle(
          color: ColorConstants.darkGrey, fontSize: FontSizeConstants.s16),
      headlineLarge: getSemiBoldStyle(
          color: ColorConstants.darkGrey, fontSize: FontSizeConstants.s16),
      headlineMedium: getRegularStyle(
          color: ColorConstants.darkGrey, fontSize: FontSizeConstants.s14),
      titleMedium: getMediumStyle(
          color: ColorConstants.primary, fontSize: FontSizeConstants.s16),
      titleSmall: getRegularStyle(
          color: ColorConstants.white, fontSize: FontSizeConstants.s16),
      bodyLarge: getRegularStyle(color: ColorConstants.grey1DisabledColor),
      bodySmall: getRegularStyle(color: ColorConstants.grey),
      labelSmall: getBoldStyle(
          color: ColorConstants.primary, fontSize: FontSizeConstants.s12),
      bodyMedium: getRegularStyle(
          color: ColorConstants.grey2, fontSize: FontSizeConstants.s12),
    ),

    // input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
        // content padding
        contentPadding: const EdgeInsets.all(AppPaddingConstants.p8),
        // hint style
        hintStyle: getRegularStyle(
            color: ColorConstants.grey, fontSize: FontSizeConstants.s14),
        labelStyle: getMediumStyle(
            color: ColorConstants.grey, fontSize: FontSizeConstants.s14),
        errorStyle: getRegularStyle(color: ColorConstants.error),

        // enabled border style
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorConstants.grey, width: AppSizeConstants.s1_5),
            borderRadius:
                BorderRadius.all(Radius.circular(AppSizeConstants.s8))),
        // focused border style
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorConstants.primary, width: AppSizeConstants.s1_5),
            borderRadius:
                BorderRadius.all(Radius.circular(AppSizeConstants.s8))),
        // error border style
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorConstants.error, width: AppSizeConstants.s1_5),
            borderRadius:
                BorderRadius.all(Radius.circular(AppSizeConstants.s8))),
        // focused border style
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorConstants.primary, width: AppSizeConstants.s1_5),
            borderRadius:
                BorderRadius.all(Radius.circular(AppSizeConstants.s8)))),
  );
}
