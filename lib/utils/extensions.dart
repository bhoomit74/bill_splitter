import 'package:flutter/material.dart';

extension ClickListener on Widget {
  Widget onClick(Function() clickHandler) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: clickHandler,
      child: this,
    );
  }
}

extension ConvertToRupee on double {
  String convertToRupee() {
    return "${toStringAsFixed(truncateToDouble() == this ? 0 : 1)} \u{20B9} ";
  }
}
