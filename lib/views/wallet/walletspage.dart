
// import 'components/pocketcardwidget.dart';

// //

// class WalletsPage extends GetView<WalletsController> {
//   WalletsPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(onWillPop: (() async {
//       return false;
//       // return (await showDialog(
//       //       context: context,
//       //       builder: (context) => AlertDialog(
//       //         title: new Text('Are you sure?'),
//       //         content: new Text('Do you want to close Index'),
//       //         actions: <Widget>[
//       //           TextButton(
//       //             onPressed: () =>
//       //                 Navigator.of(context).pop(false), //<-- SEE HERE
//       //             child: new Text('No'),
//       //           ),
//       //           TextButton(
//       //             onPressed: () =>
//       //                 Navigator.of(context).pop(true), // <-- SEE HERE
//       //             child: new Text('Yes'),
//       //           ),
//       //         ],
//       //       ),
//       //     )) ??
//       false;
//     }), child: GetBuilder<WalletsController>(builder: (_) {
//       return FutureBuilder<List<Pocket>>(
//           future: controller.getWallets(),
//           builder: (context, snapshot) {
//             printLog("Switch changed ${snapshot.connectionState}");
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return Scaffold(
//                   body: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         height: 200,
//                       ),
//                       const CircularProgressIndicator(
//                         color: AppColors.appblue,
//                       ),
//                       const SizedBox(
//                         height: 200,
//                       ),
//                       processingWidget(
//                           "Loading Wallets", 30, AppColors.indexcolor),
//                     ],
//                   ),
//                 );
//               case ConnectionState.active:
//               case ConnectionState.done:
//                 printLog("Done get wallets Response ${snapshot.data}");

//                 if (snapshot.data!.isEmpty) {
//                   printLog("No wallets Found");
//                 }
//                 return WalletCardWidget(wallets: snapshot.data!);
//             }
//             return const Center(
//                 child: CircularProgressIndicator(
//               color: AppColors.appblue,
//             ));
//           });

//       return const Center(
//           child: CircularProgressIndicator(
//         color: AppColors.appblue,
//       ));
//     }));
//   }

//   chart(context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 20, top: 20, bottom: 10.h),
//           child: Text("16.50 Units",
//               style: TextStyle(
//                   fontSize: 30,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w900)),
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 20, bottom: 10.h),
//           child: Text("Total water consumed (x 1,000 L)",
//               style: TextStyle(fontSize: 15, color: Colors.black54)),
//         ),
//         Center(
//             child: Container(
//           width: MediaQuery.of(context).size.width * 0.95,
//           height: 200.0,
//           decoration: BoxDecoration(
//             color: Colors.white60, //(255, 151, 204, 196),
//             borderRadius: BorderRadius.circular(12.w),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(15.0.w),
//             child: Sparkline(
//               lineWidth: 3,
//               data: controller.data,
//               pointsMode: PointsMode.none,
//               useCubicSmoothing: true,
//               cubicSmoothingFactor: 0.2,
//               pointSize: 8.0,
//               sharpCorners: false,
//               fillColor: AppColors.appbluelight,
//               enableGridLines: true,
//               fillMode: FillMode.below,
//             ),
//           ),
//         )),
//       ],
//     );
//   }

//   tabtitle(context, String s) {
//     return GestureDetector(
//       onTap: () {
//         print("tapped $s ");

//         if (controller.start.isAfter(controller.end)) {
//           CustomToast.errorToast("Sorry", "Selected Dates are invalid");
//           return;
//         }

//         controller.currentseletion = s.obs;
//         controller.update();
//       },
//       child: ClipRRect(
//           borderRadius: BorderRadius.all(Radius.circular(50.0.w)),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.2,
//             height: 50,
//             color: controller.currentseletion.value == s
//                 ? const Color(0xFF0F75BC)
//                 : Colors.grey.shade200,
//             child: Center(
//                 child: Padding(
//               padding: EdgeInsets.all(8.0.w),
//               child: Text(s,
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: controller.currentseletion.value == s
//                         ? Colors.white
//                         : const Color(0xFF0F75BC),
//                   )),
//             )),
//           )),
//     );
//   }

//   datefield(bool _startorend) {
//     return GestureDetector(
//       onTap: () => GetDate(controller, _startorend),
//       child: ClipRRect(
//           borderRadius: BorderRadius.all(Radius.circular(50.0.w)),
//           child: Container(
//             width: 250, // MediaQuery.of(Get.context!).size.width * 0.5,
//             height: 50,
//             color: const Color(0xFF0F75BC),
//             child: Center(
//                 child: Padding(
//               padding: EdgeInsets.all(8.0.w),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // IconButton(
//                   //   icon: Icon(
//                   //     Icons.calendar_today,
//                   //   ),
//                   //   onPressed: () {
//                   //     GetDate(_startorend);
//                   //   },
//                   // ),
//                   Text(
//                     _startorend ? "From: " : "To: ",
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     _startorend
//                         ? controller.start.toString().substring(0, 10)
//                         : controller.end.toString().substring(0, 10),
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   SizedBox(
//                     width: 2,
//                   ),
//                 ],
//               ),
//             )),
//           )),
//     );
//   }

//   onaction(act) {
//     printLog("Clicked $act");
//   }

//   cardRequest(Pocket _wallet, _request, _value) {
//     if (_request == "SELECTED") {
//       controller.selectedwallet = _wallet;
//       // controller.update();
//     }
//     printLog("B Requested $_request value $_value on ${_wallet.pocketName}");
//   }
// }
