import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    primaryColor: FashionHubColors.primaryColor,
    textTheme: const TextTheme(),
    fontFamily: 'OpenSansRegular',
    scaffoldBackgroundColor: FashionHubColors.lightGreyColor,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: FashionHubColors.blackColor),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: mediumFont.copyWith(
        color: FashionHubColors.blackColor,
        fontSize: 16.sp,
      ),
      backgroundColor: FashionHubColors.transparentColor,
    ),
  );

  static final darkTheme = ThemeData(
    fontFamily: 'OpenSansRegular',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: FashionHubColors.blackColor,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: FashionHubColors.whiteColor),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: mediumFont.copyWith(
        color: FashionHubColors.whiteColor,
        fontSize: 15.sp,
      ),
      backgroundColor: FashionHubColors.transparentColor,
    ),
  );
}
