import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../theme/theme_controller.dart';

class DialogBox {
  static void dialogBoxControl({
    String? description = "",
  }) {
    final themeData = Get.put(ThemeController());
    Fluttertoast.showToast(
      msg: description ?? '',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: themeData.isDark
          ? FashionHubColors.whiteColor
          : FashionHubColors.blackColor,
      textColor: themeData.isDark
          ? FashionHubColors.blackColor
          : FashionHubColors.whiteColor,
      fontSize: 15.0,
    );
  }
}