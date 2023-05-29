import 'dart:developer';

import 'stack_parser.dart';

/// Depth of the [Chronicle] name
enum NameDepth { deep, deeper, deepest }

class Chronicle {
  /// [StackTrace.current]
  final StackTrace stackTrace;

  /// Log message
  final String message;

  /// List of objects to be evaluated
  final List<Object> object;

  /// IF error then print in red
  final bool isError;

  /// How deep you want to know about your [Chronicle]
  ///
  /// @default: [NameDepth.deep]
  final NameDepth nameDepth;

  /// Delimiter inside name (length: 1)
  ///
  /// @default: `':'`
  final String delimiter;

  Chronicle(
    this.stackTrace,
    this.message,
    this.object, {
    this.isError = false,
    this.nameDepth = NameDepth.deep,
    this.delimiter = ':',
  }) : assert(delimiter.length == 1, 'Delimiter should 1 character long') {
    final name = _nameByDepth(StackParser(stackTrace, delimiter), nameDepth);
    final objectStr = _objectToString(object);
    final msg = _messageFormatter();

    if (isError) {
      log('', error: '$msg$objectStr', name: name);
    } else {
      log('$msg$objectStr', name: name);
    }
  }

  @override
  String toString() {
    final String name = _nameByDepth(StackParser(stackTrace, delimiter));
    return '[$name] $message';
  }

  String _messageFormatter() {
    if (message.isEmpty || message.endsWith(delimiter) || object.isEmpty) {
      return message;
    } else {
      return '$message$delimiter ';
    }
  }

  String _objectToString(Object? object) {
    try {
      if (object is List) {
        String str = '';
        for (final Object obj in object) {
          str += '${_objectToString(obj)}, ';
        }
        return str;
      } else if (object is String) {
        return object;
      } else if (object is Function) {
        return object().toString();
      } else {
        return object.toString();
      }
    } catch (e) {
      log('', error: e);
      return '_';
    }
  }

  String _nameByDepth(
    StackParser stackParser, [
    NameDepth depth = NameDepth.deep,
  ]) {
    switch (depth) {
      case NameDepth.deep:
        return stackParser.deepName;
      case NameDepth.deeper:
        return stackParser.deeperName;
      case NameDepth.deepest:
        return stackParser.deepestName;
    }
  }
}
