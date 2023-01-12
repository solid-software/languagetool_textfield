import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:languagetool_text_field/controllers/timeout.dart' as tout;

void main() async {
  void runWithTiming<T>(T Function() callback) {
    final stopwatch = clock.stopwatch()..start();
    callback();
    print('It took ${stopwatch.elapsed}!');
  }

  test('Test single Timeout run with preint(Hello) function... ', () {
    FakeAsync().run((async) {
      tout.Timeout timer = tout.Timeout(
        const Duration(seconds: 3),
      );
      expect(
        () {
          runWithTiming(() {
            timer.run(() {
              print("Hello");
            });
          });
        },
        prints('Hello\nIt took 0:00:00.000000!\n'),
      );
    });
  });

  test(
      'Test two run() calls with 1 second gap between them,' +
          'should take 4 seconds to print Hello twice', () {
    FakeAsync().run((async) {
      tout.Timeout timer = tout.Timeout(
        const Duration(seconds: 3),
      );
      expect(
        () {},
        prints('Hello\nHello\n'),
      );
    });
  });
}
