// ignore_for_file: use_build_context_synchronously

import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/authentication_pages/login_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/home_pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? vendorId;

  splashLaunch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);
    await Future.delayed(const Duration(seconds: 1));
    if (vendorId == "" || vendorId == null || vendorId == "null") {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const LoginPage();
        },
      ));
    }
    else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const DashboardPage();
        },
      ));
    }
  }

  @override
  void initState() {
    splashLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: FashionHubColors.primaryColor,
        child: Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(FashionHubImages.imgLogo))),
          ),
        ),
      ),
    );
  }
}
