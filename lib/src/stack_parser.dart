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

  StackParser(StackTrace stackTrace) {
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
    if (functionInfo.first != function) classs = functionInfo.first;

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

  String get name {
    String nm = '';

    if (classs != null) nm += '$classs::';
    if (function != null) nm += '$function';

    return nm;
  }

  String get longName {
    String nm = '';

    if (file != null) nm += '$file::';
    nm += _nameWithLineColumn;

    return nm;
  }

  String get extraLongName {
    String nm = '';

    if (path != null) nm += '$path::';
    nm += _nameWithLineColumn;

    return nm;
  }

  String get _nameWithLineColumn {
    String nm = '';

    nm += name;
    if (line != null) nm += ':$line';
    if (column != null) nm += ':$column';

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
