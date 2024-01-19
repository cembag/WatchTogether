import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension Unfocus on GetInterface {
  void unfocus() {
    if (context != null) {
      FocusScope.of(context!).unfocus();
      FocusScope.of(context!).requestFocus(FocusNode());
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
