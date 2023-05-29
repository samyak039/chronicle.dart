class StackParser {
  /// Absolute file path
  late final String? path;

  /// File name
  late final String? file;

  /// Class name where the [Chronicle] is being called
  late final String? classs;

  /// Function name where the [Chronicle] is being called
  late final String? function;

  /// line number, where the [Chronicle] was called
  late final int? line;

  /// column number, where the [Chronicle] was called
  late final int? column;

  /// Delimiter inside name
  final String _;

  StackParser(StackTrace stackTrace, [this._ = ':']) {
    List<String> st = stackTrace.toString().split('\n');
    final String info = st[M.fileInfo];

    final int filePathStarts = info.indexOf('file://');
    final int filePathEnds = info.lastIndexOf('.dart');
    path = info.substring(filePathStarts + M.fileSchemeLength,
        M.dartExtensionLength + filePathEnds);
    file = path?.split('/').last;

    final int functionInfoStarts = info.indexOf(RegExp('[A-Za-z]'));
    final int functionInfoEnd = info.indexOf('(');
    final List<String> functionInfo =
        info.substring(functionInfoStarts, functionInfoEnd).trim().split('.');
    function = functionInfo.last;
    classs = (functionInfo.first != function) ? functionInfo.first : null;
    // if (functionInfo.first != function) classs = functionInfo.first;

    line = int.tryParse(info.split(':')[M.line]);
    column = int.tryParse(info.split(':')[M.column].replaceFirst(')', ''));
  }

  @override
  String toString() => 'StackParser('
      'path: $path, '
      'file: $file, '
      'class: $classs, '
      'function: $function, '
      'line: $line, '
      'column: $column'
      ')';

  String get deepName {
    String nm = '';

    if (classs != null) nm += '$classs$_$_';
    if (function != null) nm += '$function';
    if (line != null) nm += '$_$line';

    return nm;
  }

  String get deeperName {
    String nm = '';

    if (file != null) nm += '$file$_$_';
    nm += deepName;
    if (column != null) nm += '$_$column';

    return nm;
  }

  String get deepestName {
    String nm = '';

    if (path != null) nm += '$path$_$_';
    nm += deepName;
    if (column != null) nm += '$_$column';

    return nm;
  }
}

/// Magic Variables :)
class M {
  static const int fileInfo = 0;

  static const int fileSchemeLength = 'file://'.length;
  static const int dartExtensionLength = '.dart'.length;

  static const int line = 2;
  static const int column = 3;
}
