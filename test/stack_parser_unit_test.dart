import 'package:chronicle/src/stack_parser.dart';
import 'package:test/test.dart';

void main() {
  group('StackParser', () {
    test('Creates a StackParser instance', () {
      final stackTrace = StackTrace.current;
      final stackParser = StackParser(stackTrace);

      // Test properties of StackParser
      expect(stackParser.path, endsWith('/test/stack_parser_unit_test.dart'));
      expect(stackParser.file, 'stack_parser_unit_test.dart');
      expect(stackParser.classs, 'main');
      expect(stackParser.function, '<anonymous closure>');
      expect(stackParser.line, 7);
      expect(stackParser.column, 37);

      // Test the name getter
      expect(stackParser.deepName, isNotNull);

      // Test the longName getter
      expect(stackParser.deeperName, isNotNull);

      // Test the extraLongName getter
      expect(stackParser.deepestName, isNotNull);
    });
  });
}
