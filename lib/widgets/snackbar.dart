import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:etracker/utils/mysize.dart';

class CustomSnackBar {
  static void show({
    required String message,
    required bool isError,
  }) {

    Color backgroundColor = isError ? Colors.red.shade500 : Colors.green.shade400;

    Get.snackbar(
      '',
      message,
      titleText: Text(isError? 'Alert ⚠️' : 'Notification:',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      borderRadius: MySize.size10,
      margin: EdgeInsets.symmetric(horizontal: MySize.size24, vertical: MySize.size10),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      icon: Icon(isError ? Icons.error : Icons.check_circle, color: Colors.white),
      shouldIconPulse: false,
      barBlur: 20,
      isDismissible: true,
      onTap: (snack) => Get.back(),
    );
  }
}
