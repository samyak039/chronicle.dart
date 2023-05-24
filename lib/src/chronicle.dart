import 'dart:developer';

import 'stack_parser.dart';

enum ChronicleName { def, long, xtraLong }

class Chronicle {
  final StackTrace stackTrace;

  final String? message;
  final Object? error;

  ChronicleName length;

  Chronicle(
    this.stackTrace,
    this.message, {
    this.error,
    this.length = ChronicleName.def,
  }) {
    StackParser sp = StackParser(stackTrace);

    String name;
    switch (length) {
      case ChronicleName.def:
        name = sp.name;
        break;
      case ChronicleName.long:
        name = sp.longName;
        break;
      case ChronicleName.xtraLong:
        name = sp.extraLongName;
        break;
    }

    log(message ?? '', error: error, name: name);
  }
}
