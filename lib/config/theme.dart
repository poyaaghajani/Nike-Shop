import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';

const defaultTextStyle = TextStyle(
  fontFamily: 'SM',
  color: LightThemeColors.primaryTextColor,
);

class MyTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
      bodyMedium: defaultTextStyle,
      bodyLarge: defaultTextStyle.copyWith(fontSize: 18).apply(
            color: LightThemeColors.deepNavy,
          ),
      titleSmall: defaultTextStyle
          .apply(
            color: LightThemeColors.secondaryTextColor,
          )
          .copyWith(fontSize: 13),
      titleMedium: defaultTextStyle.apply(
        color: LightThemeColors.navy,
      ),
      labelLarge: defaultTextStyle.apply(
        color: LightThemeColors.purpule,
      ),
      headlineMedium: defaultTextStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: LightThemeColors.primaryColor,
      secondary: LightThemeColors.secondaryColor,
      onSecondary: Colors.white,
      onBackground: LightThemeColors.deepNavy,
      background: LightThemeColors.backgroundColor,
    ),
  );
}
