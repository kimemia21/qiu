import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../../Models/walletmodel.dart';
import '../../comms/credentials.dart';
import '../../utils/utils.dart';

class WalletsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final count = 0.obs;
  var selected_meter_id = "".obs;
  RxBool isLoading = false.obs;
  RxBool fetchingusage = false.obs;
  RxBool fetchingtokenbalances = false.obs;
  RxBool fetchingtokens = false.obs;
  RxString currentseletion = "Day".obs;
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  RxList<double> consumptiondata =
      [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0].obs;

  DateTime start = DateTime.now().add(
      Duration(days: -7)); // DateTime.parse(DateFormat('yyyy-MM-dd 00:00:00');
  //     .format(DateTime.now())); //DateTime.now().add(Duration(days: -1));
  DateTime end = DateTime.now();

  late TabController tabcontroller;
  Pocket? selectedwallet = null;

  @override
  void onInit() {
    super.onInit();
    tabcontroller = TabController(vsync: this, length: 3);
    printLog("Inited wallets ");
  }

  @override
  void onClose() {
    tabcontroller.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    print("Wallets  ready\n\n");
  }

  void increment() => count.value++;

  void pickDate(DateTime pickStart, DateTime pickEnd) {
    // start = pickStart;
    // end = pickEnd;
    update();

    Get.back();
  }

  Future<void> getWallets() async {
    // isLoading = false.obs;
    // update();

    await comms_repo.FetchWallets().then((value) async {
      printLog("Wallet login Response $value");
    });
    ;
  }
}
