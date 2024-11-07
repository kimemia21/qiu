import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user.dart';
import 'local_storage.dart';
import 'securestorage.dart';
import 'utils.dart';

/// 检查是否有 token
Future<bool> isAuthenticated() async {
  var profileJSON = LocalStorage().getJSON(STORAGE_USER_PROFILE_KEY);
  return profileJSON != null ? true : false;
}

/// 删除缓存token
Future deleteAuthentication() async {
  current_user = new userModel(active: false);
  currentIndexUser = IndexUserModel(
      active: false, userEmail: "", userName: "", userPass: "", userPhone: "");
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('is_first_app_launch', false);
  await SecureStorageService.writeValue("index_user", "");
  await LocalStorage().remove(STORAGE_USER_PROFILE_KEY);
  LocalStorage().setJSON(STORAGE_USER_PROFILE_KEY, null);

  await SecureStorageService.deleteAllValues();
}

/// 重新登录
void deleteTokenAndReLogin() async {
  await deleteAuthentication();
  // Get.offAndToNamed('/login');
}
