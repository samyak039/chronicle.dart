import 'package:chronicle/chronicle.dart';

void main() {
  Chronicle(StackTrace.current, 'Hello, World!');
  master(5);

  Add c = Add(1, 1);
  c.sum();

  Chronicle(StackTrace.current, c.toString(),
      error: c.toString(), length: ChronicleName.xtraLong);
}

void master(int i) {
  Chronicle(StackTrace.current, i.toString(), length: ChronicleName.xtraLong);
}

class Add {
  int a;
  int b;

  Add(this.a, this.b);

  int sum() {
    Chronicle(StackTrace.current, 'a: $a');
    Chronicle(StackTrace.current, 'b: $b', length: ChronicleName.long);
    return a + b;
  }

  @override
  String toString() => '$a + $b = ${sum()}';
}
