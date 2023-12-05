import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:module_12/app.dart';
import 'package:module_12/ui/controllers/authentication_controller.dart';
import 'package:module_12/ui/screen/login_screen.dart';
import 'network_response.dart';

class NetworkCaller {
  Future<NetworkResponse> postRequest(String url,
      {dynamic requestBody , bool isLogin = false}) async {
    try {
      log(url);
      log(requestBody.toString());
      final Response response = await post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'token' : AuthenticationController.token.toString(),
        }
      );
      log(AuthenticationController.token.toString());
      log(response.headers.toString());
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
          statusCode: 200,
        );
      }
      else if(response.statusCode == 401){
        if(isLogin == false) {
          backToLogin();
        }
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          jsonResponse: jsonDecode(response.body),
        );
      }
      else {
        return NetworkResponse(
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      return NetworkResponse(
        isSuccess: false,
        errorMassage: error.toString(),
      );
    }
  }

  Future<NetworkResponse> getRequest(String url) async {
    try {
      log(url);
      final Response response = await get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'token' : AuthenticationController.token.toString(),
          }
      );
      log(AuthenticationController.token.toString());
      log(response.headers.toString());
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
          statusCode: 200,
        );
      }
      else if(response.statusCode == 401){
        backToLogin();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          jsonResponse: jsonDecode(response.body),
        );
      }
      else {
        return NetworkResponse(
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      return NetworkResponse(
        isSuccess: false,
        errorMassage: error.toString(),
      );
    }
  }

  Future<void> backToLogin() async {
    await AuthenticationController.clearAuthenticationData();
    Navigator.pushAndRemoveUntil(
        TaskManagerApp.navigatorFormKey.currentContext!,
        MaterialPageRoute(builder: (context) => const LoginScreen()), (
            route) => false);
  }
}
