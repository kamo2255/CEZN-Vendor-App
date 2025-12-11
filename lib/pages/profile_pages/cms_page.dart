import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/profile_models/cmspage_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../theme/theme_controller.dart';

class CmsPage extends StatefulWidget {
  final String? isComeFrom;
  const CmsPage({super.key,this.isComeFrom});

  @override
  State<CmsPage> createState() => _CmsPageState();
}

class _CmsPageState extends State<CmsPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  CmsPageModel? responseData;
  final themeData = Get.put(ThemeController());
  late WebViewController webViewController = WebViewController();

  cmsAPI() async {
    try {
      var response = await Dio().get(DefaultApi.apiUrl + GetApi.cmsPagesApi);
      if (response.statusCode == 200) {
        responseData = CmsPageModel.fromJson(response.data);
        return responseData;
      } else {
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
        appBar:  AppBar(
          leadingWidth: width/9,
          surfaceTintColor: themeData.isDark?FashionHubColors.blackColor:FashionHubColors.whiteColor,
          title:  Row(
            children: [
              Text(
                widget.isComeFrom.toString() == "1"
                    ? 'str_privacy_policy'.tr
                    : widget.isComeFrom.toString() == "2"
                    ? 'str_about_us'.tr
                    : "str_terms_conditions".tr,
                style:
                semiBoldFont.copyWith(fontSize: 15.sp),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
            future: cmsAPI(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: FashionHubColors.blackColor,
                  ),
                );
              }
              webViewController
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadHtmlString(widget.isComeFrom.toString() == "1"
                    ? responseData!.privecypolicy.toString()
                    : widget.isComeFrom.toString() == "2"
                    ? responseData!.aboutus.toString()
                    : responseData!.termscondition.toString());
              return WebViewWidget(controller: webViewController);
            }),
      ),
    );
  }
}
