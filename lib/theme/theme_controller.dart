import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController{
  bool isDark = false;

  @override
  void onInit(){
    SharedPreferences.getInstance().then((value) {
      isDark = value.getBool(darkModePreference) ?? true;
      if(isDark){
        Get.changeTheme(MyThemes.darkTheme);
      }else{
        Get.changeTheme(MyThemes.lightTheme);
      }
      update();
    });

    super.onInit();
  }

  Future<void> changeThem (state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool(darkModePreference) ?? true;
    isDark = !isDark;

    prefs.setBool(darkModePreference, isDark);

    if (state == true) {
      Get.changeTheme(MyThemes.darkTheme);
      isDark = true;
    }
    else {
      Get.changeTheme(MyThemes.lightTheme);
      isDark = false;
    }
    update();
  }
}