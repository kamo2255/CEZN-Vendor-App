// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/profile_models/deleteaccount_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/authentication_pages/login_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../common/shared_preferences.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  bool isChecked = false;
  String? vendorId;
  DeleteAccountModel? responseData;
  final themeData = Get.put(ThemeController());

  deleteAccountAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    vendorId = prefs.getString(vendorIdPreference);
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
      };
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.deleteVendorApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        responseData = DeleteAccountModel.fromJson(response.data);
        if (responseData!.status.toString() == "1") {
          prefs.remove(vendorIdPreference);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const LoginPage();
            },
          ));
        } else {
          DialogBox.dialogBoxControl(description: responseData!.message.toString());
        }
      } else {
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
      }
    } catch (e) {
      Loader.hideLoading();
      DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return AppScaffold(
      offlineStatus: (p0) {

      },isCachesEnable: true,child: Scaffold(
         appBar: AppBar(
          surfaceTintColor: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.whiteColor,
          leadingWidth: width/8,
          title: Row(
            children: [
              Text("str_delete_account".tr,style: mediumFont.copyWith(
                  fontSize: 14.sp),),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/26,vertical: height/36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("str_delete_account_msg_1".tr,style: boldFont.copyWith(fontSize: 14.sp)),
              SizedBox(height: height/46),
              Row(
                children: [
                  Icon(Icons.circle_outlined,size: 8,color: FashionHubColors.greyColor,),
                  SizedBox(width: width/46),
                  SizedBox(
                    width: width/1.2,
                    child: Text("str_delete_account_msg_2".tr,
                        style: regularFont.copyWith(fontSize: 10.sp,color: FashionHubColors.greyColor)),
                  ),
                ],
              ),
              SizedBox(height: height/96),
              Row(
                children: [
                  Icon(Icons.circle_outlined,size: 8,color: FashionHubColors.greyColor,),
                  SizedBox(width: width/46),
                  SizedBox(
                    width: width/1.2,
                    child: Text("delete_account_msg_3".tr,
                        style: regularFont.copyWith(fontSize: 10.sp,color: FashionHubColors.greyColor)),
                  ),
                ],
              ),
              SizedBox(height: height/46),
              Row(
                children: [
                  SizedBox(
                    height: height/66,
                    width: height/66,
                    child: Checkbox(
                      checkColor: FashionHubColors.whiteColor,
                      activeColor: FashionHubColors.primaryColor,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: width/26),
                  Text("str_delete_account_checkbox".tr,style: regularFont.copyWith(fontSize: 10.sp)),
                ],
              ),
              SizedBox(height: height/26),
              InkWell(
                splashColor: FashionHubColors.transparentColor,
                highlightColor: FashionHubColors.transparentColor,
                onTap: () {
                  if(isChecked == false){
                    DialogBox.dialogBoxControl(description: "str_delete_account_checkbox_msg".tr);
                  }else{
                    showDialog(
                        builder: (context) => AlertDialog(
                          backgroundColor: themeData.isDark ? FashionHubColors.darkModeColor : FashionHubColors.whiteColor,
                          title: Text("str_app_name".tr,
                              textAlign: TextAlign.center,
                              style: semiBoldFont.copyWith(fontSize: 18.sp)),
                          content: Text(
                            "str_delete_account_confirmation".tr,
                            style: regularFont.copyWith(fontSize: 10.sp),
                          ),
                          actionsAlignment: MainAxisAlignment.end,
                          actions: [
                            ElevatedButton(
                                style:
                                ElevatedButton.styleFrom(
                                    backgroundColor: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.blackColor,),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "str_no".tr,
                                  style: regularFont.copyWith(color: FashionHubColors.whiteColor),
                                )),
                            ElevatedButton(
                              onPressed: ()  {
                                if (DemoData.environment == "Test") {
                                  DialogBox.dialogBoxControl(
                                      description:
                                      "str_demo_mode_message".tr);
                                } else {
                                  deleteAccountAPI();
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: FashionHubColors.primaryColor),
                              child:
                              Text("str_yes".tr, style: regularFont.copyWith(color: FashionHubColors.whiteColor)),
                            )
                          ],
                        ),
                        context: context);
                  }
                },
                child: Container(
                  height: height/15,
                  width: width/1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: FashionHubColors.redColor,
                  ),
                  child: Center(
                    child: Text("str_delete_account".tr,style: mediumFont.copyWith(fontSize: 12.sp,color: FashionHubColors.whiteColor)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
