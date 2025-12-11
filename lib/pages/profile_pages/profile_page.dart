// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/authentication_pages/login_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/profile_pages/deleteaccount_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/profile_pages/editprofile_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/profile_pages/changepassword_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/profile_pages/contactus_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/profile_pages/cms_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  String? vendorName;
  String? vendorImage;
  String? adminEmail;
  String? adminMobile;
  String? adminAddress;
  final themeData = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      vendorName = pref.getString(vendorNamePreference);
      vendorImage = pref.getString(vendorImagePreference);
    });
    adminEmail = pref.getString(adminEmailPreference);
    adminMobile = pref.getString(adminMobilePreference);
    adminAddress = pref.getString(adminAddressPreference);
  }

  refreshData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      vendorName = pref.getString(vendorNamePreference);
      vendorImage = pref.getString(vendorImagePreference);
    });
  }

  Future<bool> logout() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("str_app_name".tr,
                  style: boldFont.copyWith(fontSize: 14.sp)),
              content: Text(
                "str_exit_app".tr,
                style: regularFont.copyWith(fontSize: 11.sp),
              ),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FashionHubColors.redColor,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "str_no".tr,
                      style: regularFont.copyWith(
                          color: FashionHubColors.whiteColor),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FashionHubColors.greenColor,
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove(vendorIdPreference);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ));
                    },
                    child: Text("str_yes".tr,
                        style: regularFont.copyWith(
                            color: FashionHubColors.whiteColor)))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return WillPopScope(
      onWillPop: logout,
      child: GetBuilder<ThemeController>(builder: (controller) {
        return AppScaffold(
          offlineStatus: (p0) {

          },isCachesEnable: true,child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: FashionHubColors.lightPrimaryColor,
              backgroundColor: FashionHubColors.lightPrimaryColor,
              leadingWidth: width / 9,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Text(
                    'str_profile'.tr,
                    style: boldFont.copyWith(fontSize: 20.sp),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width / 36, vertical: height / 36),
                child: Column(
                  children: [
                    if (vendorImage == "" || vendorImage == null) ...[
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: FashionHubColors.whiteColor,
                        backgroundImage:
                            const AssetImage(FashionHubImages.imgPlaceholder),
                      ),
                    ] else ...[
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: FashionHubColors.whiteColor,
                        backgroundImage: NetworkImage(vendorImage.toString()),
                      ),
                    ],
                    SizedBox(height: height / 56),
                    Text(vendorName.toString(),
                        style: boldFont.copyWith(fontSize: 15.sp)),
                    SizedBox(height: height / 26),
                    InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                  builder: (context) => const EditProfilePage()),
                            )
                            .then((val) => val ? refreshData() : null);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            FashionHubImages.imgName,
                            height: height / 36,
                            color: themeData.isDark
                                ? FashionHubColors.whiteColor
                                : FashionHubColors.blackColor,
                          ),
                          SizedBox(
                            width: width / 36,
                          ),
                          Text(
                            "str_edit_profile".tr,
                            style: mediumFont.copyWith(fontSize: 13.sp),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: height / 36,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 36,
                    ),
                    InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const ChangePasswordPage();
                          },
                        ));
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            FashionHubImages.imgPassword,
                            height: height / 36,
                            color: themeData.isDark
                                ? FashionHubColors.whiteColor
                                : FashionHubColors.blackColor,
                          ),
                          SizedBox(
                            width: width / 36,
                          ),
                          Text(
                            "str_change_password".tr,
                            style: mediumFont.copyWith(fontSize: 13.sp),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: height / 36,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 36,
                    ),
                    InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ContactUsPage(
                                adminEmail, adminMobile, adminAddress);
                          },
                        ));
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            FashionHubImages.imgChat,
                            height: height / 36,
                            color: themeData.isDark
                                ? FashionHubColors.whiteColor
                                : FashionHubColors.blackColor,
                          ),
                          SizedBox(
                            width: width / 36,
                          ),
                          Text(
                            "str_contact_us".tr,
                            style: mediumFont.copyWith(fontSize: 13.sp),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: height / 36,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 36,
                    ),
                    InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const CmsPage(isComeFrom: "1");
                          },
                        ));
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            FashionHubImages.imgPrivacyPolicy,
                            height: height / 36,
                            color: themeData.isDark
                                ? FashionHubColors.whiteColor
                                : FashionHubColors.blackColor,
                          ),
                          SizedBox(
                            width: width / 36,
                          ),
                          Text(
                            "str_privacy_policy".tr,
                            style: mediumFont.copyWith(fontSize: 13.sp),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: height / 36,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 36,
                    ),
                    InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const CmsPage(isComeFrom: "2");
                          },
                        ));
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            FashionHubImages.imgAboutUs,
                            height: height / 36,
                            color: themeData.isDark
                                ? FashionHubColors.whiteColor
                                : FashionHubColors.blackColor,
                          ),
                          SizedBox(
                            width: width / 36,
                          ),
                          Text(
                            "str_about_us".tr,
                            style: mediumFont.copyWith(fontSize: 13.sp),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: height / 36,
                            color: themeData.isDark
                                ? FashionHubColors.whiteColor
                                : FashionHubColors.blackColor,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 36,
                    ),
                    InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const CmsPage(isComeFrom: "3");
                          },
                        ));
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            FashionHubImages.imgPrivacyPolicy,
                            height: height / 36,
                            color: themeData.isDark
                                ? FashionHubColors.whiteColor
                                : FashionHubColors.blackColor,
                          ),
                          SizedBox(
                            width: width / 36,
                          ),
                          Text(
                            "str_terms_conditions".tr,
                            style: mediumFont.copyWith(fontSize: 13.sp),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: height / 36,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 36,
                    ),
                    Row(children: [
                      Image.asset(
                        FashionHubImages.imgDarkMode,
                        height: height / 36,
                        color: themeData.isDark
                            ? FashionHubColors.whiteColor
                            : FashionHubColors.blackColor,
                      ),
                      SizedBox(
                        width: width / 36,
                      ),
                      Text(
                        "str_dark_mode".tr,
                        style: mediumFont.copyWith(fontSize: 13.sp),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: height / 30,
                        child: Switch(
                          activeColor: FashionHubColors.whiteColor,
                          onChanged: (state) {
                            themeData.changeThem(state);
                            themeData.update();
                          },
                          value: themeData.isDark,
                        ),
                      )
                    ]),
                    SizedBox(
                      height: height / 36,
                    ),
                    InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const DeleteAccountPage();
                          },
                        ));
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            FashionHubImages.imgDelete,
                            height: height / 36,
                            color: themeData.isDark
                                ? FashionHubColors.whiteColor
                                : FashionHubColors.blackColor,
                          ),
                          SizedBox(
                            width: width / 36,
                          ),
                          Text(
                            "str_delete_account".tr,
                            style: mediumFont.copyWith(fontSize: 13.sp),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: height / 36,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 36,
                    ),
                    InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        logout();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            FashionHubImages.imgLogout,
                            height: height / 36,
                            color: FashionHubColors.redColor,
                          ),
                          SizedBox(
                            width: width / 36,
                          ),
                          Text(
                            "str_logout".tr,
                            style: mediumFont.copyWith(
                                fontSize: 13.sp,
                                color: FashionHubColors.redColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
