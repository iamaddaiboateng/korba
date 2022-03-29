import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// these are notifications to displayed to user
/// [successNotification] displays a green notification at the top of the screen
/// and last for 3 seconds
successNotification(String message, {int duration = 3}) {
  Get.snackbar(
    'Successful',
    message,
    maxWidth: 400,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(20),
    snackStyle: SnackStyle.GROUNDED,
    icon: const CircleAvatar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.teal,
      child: Icon(Icons.thumb_up),
    ),
    colorText: Colors.white,
    backgroundColor: Colors.teal,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: duration),
  );
}

/// [errorNotification] displays a red notification at the bottom of the screen
/// and last for 3 seconds
errorNotification(String message, {int duration = 3}) {
  Get.snackbar(
    'Error',
    message,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.all(20),
    snackStyle: SnackStyle.GROUNDED,
    icon: const CircleAvatar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.red,
      child: Icon(Icons.error),
    ),
    maxWidth: 400,
    colorText: Colors.white,
    backgroundColor: Colors.red,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: duration),
  );
}

/// [networkErrorNotification] displays a red notification at the bottom of the screen
/// and last for 5 seconds
networkErrorNotification() {
  String message = 'Please ensure you have an active internet connection';
  Get.snackbar(
    'An Error Occurred',
    message,
    maxWidth: 400,
    colorText: Colors.white,
    backgroundColor: Colors.red,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 5),
  );
}
