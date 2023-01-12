import 'package:flutter_test/flutter_test.dart';
import 'package:languagetool_text_field/controllers/timeout.dart' as tout;

void main() async {
  test(
    "Timout test...",
    () async {
      final timeout = tout.Timeout(const Duration(seconds: 3));
      timeout.run(() {
        print("run");
      });
    },
  );
}
