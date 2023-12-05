import 'dart:convert';
import 'dart:developer';

import 'package:module_12/data_network_caller/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController {
  static String? token;
  static UserModel? user;

  static Future<void> saveUserInformation(String userToken ,UserModel model) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', userToken);
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    token = userToken;
    user = model;
  }

  static Future<void> updateUserInformation(UserModel model) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    user = model;
  }

  static Future<void> initializeUserCache() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getString('token');
    user = UserModel.fromJson(jsonDecode(sharedPreferences.getString('user') ?? '{}'));
    log(user.toString());
  }

  static Future<bool> checkAuthenticationState() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey('token')){
      await initializeUserCache();
      return true;
    }
    return false;
  }

  static Future<void> clearAuthenticationData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    user = null;
    token = null;
  }
}