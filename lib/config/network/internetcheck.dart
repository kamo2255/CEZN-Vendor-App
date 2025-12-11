// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:developer' as developer;

import 'package:sizer/sizer.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

import '../../common/colors.dart';
import '../../common/fonts.dart';
import '../../theme/theme_controller.dart';

ConnectivityResult connectionStatus = ConnectivityResult.none;
bool isOnline = connectionStatus.name != "none";
bool isRepeat =true ;

class AppScaffold extends StatefulWidget {
  final Widget child;
  final bool isCachesEnable;
  final bool? isAppBar;
  final Function(int) offlineStatus;



  const AppScaffold(
      {super.key,
      required this.child,
      this.isAppBar,
      required this.isCachesEnable,
      required this.offlineStatus});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final Connectivity _connectivity = Connectivity();
  final themedata = Get.put(ThemeController());
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isDeviceConnected = false;
  bool dialog = false;
  // bool isRepeat = true;

  showDialogBox() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                'No Connection'.tr,
                  style: boldFont.copyWith(fontSize: 14.sp,)
              ),
              content: Text(
                'Please check your internet connectivity.'.tr,
                  style: regularFont.copyWith(fontSize: 12.sp,)

              ),
              actions: [
                InkWell(
                  onTap: () async {
                    const OpenSettingsPlusAndroid().wifi();
                    Get.back();
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {
                      showDialogBox();
                      dialog = true;
                    } else {
                      dialog = false;
                    }
                  },
                  child: Container(
                    height: 5.h,
                    width: 18.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: FashionHubColors.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        'Ok'.tr,
                          style: regularFont.copyWith(fontSize: 12.sp,color: FashionHubColors.whiteColor)

                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  @override
  void initState() {
    super.initState();
    isRepeat == true ?
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus) : _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus1);
    initConnectivity();
  }

  @override
  void dispose() {
    // isRepeat == true ?
    // _connectivitySubscription.cancel(): null;
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // ignore: unused_local_variable
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    // return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    isRepeat = false;
      debugPrint("0=-0=-0=-0=-=-=-result[0 ${result[0]}");
      connectionStatus = result[0];
      isOnline = connectionStatus.name != "none";
      widget.offlineStatus(connectionStatus != "none" ? 1 : 0);
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {

      showDialogBox();
      dialog = true;
    } else if (isDeviceConnected && dialog) {
    dialog = false;
      Get.back();
    }
}

  Future<void> _updateConnectionStatus1(List<ConnectivityResult> result) async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (isDeviceConnected && dialog) {
      dialog = false;
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return connectionStatus.name.toString() == "none"
        ? widget.isCachesEnable
            ? widget.child
            : Container(
                child: widget.isAppBar == false
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/bg.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : Scaffold(
                        appBar: AppBar(
                          title: const Text('Zeymo'),
                          automaticallyImplyLeading: false,
                        ),
                        body: const Center(child: CircularProgressIndicator()),
                      ),
              )
        : widget.child;
  }
}
