import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    if (isNegative) {
      return "- \u{20B9}${abs().toStringAsFixed(truncateToDouble() == this ? 0 : 1)}";
    }
    return "\u{20B9}${toStringAsFixed(truncateToDouble() == this ? 0 : 1)}";
  }
}

extension TimeStampToDate on int? {
  String toDate() {
    if (this != null) {
      var dateTime = DateTime.fromMicrosecondsSinceEpoch(this!);
      return DateFormat("dd MMM yyyy").format(dateTime);
    } else {
      return "";
    }
  }
}

extension TimestampToTIme on int? {
  String toTime() {
    if (this != null) {
      var dateTime = DateTime.fromMicrosecondsSinceEpoch(this!);
      return DateFormat("hh:mm aa").format(dateTime);
    } else {
      return "";
    }
  }
}
