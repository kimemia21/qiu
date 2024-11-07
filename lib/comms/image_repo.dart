// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:dio/dio.dart';

// import 'credentials.dart';

// class ImageRepository {
//   final Dio _dio = Dio(BaseOptions(
//     connectTimeout: const Duration(seconds: 30),
//     sendTimeout: const Duration(seconds: 60),
//     baseUrl: image_url,
//     responseType: ResponseType.json,
//     contentType: ContentType.json.toString(),
//   ));

//   Future<Map<String, dynamic>?> uploadImage(file, depath) async {
//     String fileName = depath.split('/').last;
//     file.path.split('/').last;

//     //signature
//     //api_key
//     //timestamp
//     printLog("Try Upload image $fileName");
//     String api_key = '882344881974131';
//     String api_secret = "9jgqJZkrwZ1bhSn_AEFZV7TTQto";
//     String cloudname = "dt4yfuuuw";

//     int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//     // Generate a secure signature using the API secret key and the timestamp
//     String signature =
//         sha1.convert(utf8.encode('timestamp=$timestamp$api_secret')).toString();

//     FormData data = FormData.fromMap({
//       "file": await MultipartFile.fromFile(
//         depath,
//         filename: getCustomUniqueId(),
//       ),
//       "tag": "meter",
//       'timestamp': '$timestamp',
//       'cloud_name': cloudname,
//       'api_secret': api_secret,
//       'api_key': api_key,
//       'signature': signature,
//       // 'folder': 'EarthView'
//     });
//     try {
//       var rsp = await _dio.post(
//         image_url, // '/media/upload/image',
//         data: data,
//       );

//       return rsp.data;
//       printLog("$rsp");
//     } on DioError catch (e) {
//       printLog(" upload Image ${e.error}");
//       printLog(" upload Image ${e.message}");
//     } catch (e) {
//       printLog("error on login, ${e.toString}");
//     }
//     return null;
//   }

//   String getCustomUniqueId() {
//     const String pushChars =
//         '-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';
//     int lastPushTime = 0;
//     List lastRandChars = [];
//     int now = DateTime.now().millisecondsSinceEpoch;
//     bool duplicateTime = (now == lastPushTime);
//     lastPushTime = now;
//     List timeStampChars = List<String>.filled(8, '0');
//     for (int i = 7; i >= 0; i--) {
//       timeStampChars[i] = pushChars[now % 64];
//       now = (now / 64).floor();
//     }
//     if (now != 0) {
//       print("Id should be unique");
//     }
//     String uniqueId = timeStampChars.join('');
//     if (!duplicateTime) {
//       for (int i = 0; i < 12; i++) {
//         lastRandChars.add((Random().nextDouble() * 64).floor());
//       }
//     } else {
//       int i = 0;
//       for (int i = 11; i >= 0 && lastRandChars[i] == 63; i--) {
//         lastRandChars[i] = 0;
//       }
//       lastRandChars[i]++;
//     }
//     for (int i = 0; i < 12; i++) {
//       uniqueId += pushChars[lastRandChars[i]];
//     }
//     return uniqueId;
//   }

//   // randomIdGenerator() {
//   //   var ranAssets = RanKeyAssets();
//   //   String first4alphabets = '';
//   //   String middle4Digits = '';
//   //   String last4alphabets = '';
//   //   for (int i = 0; i < 4; i++) {
//   //     first4alphabets += ranAssets.smallAlphabets[
//   //         math.Random.secure().nextInt(ranAssets.smallAlphabets.length)];

//   //     middle4Digits += ranAssets
//   //         .digits[math.Random.secure().nextInt(ranAssets.digits.length)];

//   //     last4alphabets += ranAssets.smallAlphabets[
//   //         math.Random.secure().nextInt(ranAssets.smallAlphabets.length)];
//   //   }

//   //   return '$first4alphabets-$middle4Digits-${DateTime.now().microsecondsSinceEpoch.toString().substring(8, 12)}-$last4alphabets';
//   // }
// }

// class RanKeyAssets {
//   var smallAlphabets = [
//     'a',
//     'b',
//     'c',
//     'd',
//     'e',
//     'f',
//     'g',
//     'h',
//     'i',
//     'j',
//     'k',
//     'l',
//     'm',
//     'n',
//     'o',
//     'p',
//     'q',
//     'r',
//     's',
//     't',
//     'u',
//     'v',
//     'w',
//     'x',
//     'y',
//     'z'
//   ];
//   var digits = [
//     '0',
//     '1',
//     '2',
//     '3',
//     '4',
//     '5',
//     '6',
//     '7',
//     '8',
//     '9',
//   ];
// }
