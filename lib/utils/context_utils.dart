import 'package:flutter/material.dart';

class ContextUtils {
  static Size? getSize(BuildContext context) {
    final rb = context.findRenderObject() as RenderBox?;
    if (rb?.hasSize == true) {
      return rb?.size;
    }
    return null;
  }
}
