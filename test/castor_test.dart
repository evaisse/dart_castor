import 'package:castor/castor.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void main() {
  /// This test is just there to prove the risk in using `dynamic`
  /// keyword and the cumbersome code which is mandatory to ensure a safe
  /// code with standard tools
  ///
  test('`dynamic` keyword is Bad bad bad not good', () {
    dynamic object;
    expect(() {
      return object.tryAs<Object?>();
    }, throwsA(TypeMatcher<NoSuchMethodError>()));
  });

  /// the `castOr` extension or helper allow you to unwrap an optional
  /// without risking an exception to be thrown.
  ///
  group('Unwrapping without the postfix null promotion operator', () {
    for (final value in _values) {
      test("With ${value.runtimeType} —> $value.", () {
        expect(castOr<String>(value, (_) => 'ok').runtimeType, String);
        expect(value.castOr<String>((_) => 'ok').runtimeType, String);
      });
    }
  });

  /// the [castOrNull] is similar to the previous helper but give you a
  /// nullable instead of a mandatory unwrapped value
  ///
  group('Is null?', () {
    test("With a string", () {
      expect("hello world".castOrNull<String>(), "hello world");
    });
    for (final value in _values) {
      test("With ${value.runtimeType} —> $value.", () {
        expect(value?.castOrNull<Error>(), null);
        expect(castOrNull<Error>(value), null);
      });
    }
  });

  group('Unnecessary type check', () {
    for (final value in _values) {
      test("With ${value.runtimeType} —> $value.", () {
        // ignore: unnecessary_type_check
        expect(value?.castOrNull<String>(), TypeMatcher<String?>());
      });
    }
  });

  group("Expect an isFinite <int>", () {
    for (final value in _values) {
      test("With ${value.runtimeType} —> $value.", () {
        final asBool = value.castOr<int>((_) => 32).isFinite;
        expect(asBool.runtimeType, bool);
      });
    }
  });

  group("Expect an alternative of the same type if null", () {
    for (final value in _values) {
      test("With ${value.runtimeType} —> $value.", () {
        expect(value.castOrNull<int>()?.isFinite, TypeMatcher<bool?>());
      });
    }
  });

  group("Try an alternative casting", () {
    for (final value in _values) {
      test("With ${value.runtimeType} —> $value.", () {
        return value
            ?.castOrNull<int>(
                (val) => val != null && val is double ? val.toInt() : 34)
            ?.isFinite;
      });
    }
  });

  group("Fetch an alternative an alternative of the same type if null", () {
    for (final value in _values) {
      test("With ${value.runtimeType} —> $value.", () {
        expect(
          value?.castOrNull<int>((val) => 34),
          TypeMatcher<int?>(),
        );
      });
    }
  });

  group("Alternative with the alternate syntax and providing a default", () {
    for (final value in _values) {
      test("With ${value.runtimeType} —> $value.", () {
        /// note there that the int is inferred and
        /// the promotion of the null value
        final int myInt = value.castOr((that) => 43);
        expect(myInt, TypeMatcher<int>());
      });
    }
  });

  group("Providing a complete other value A.K.A transform", () {
    for (final value in _values) {
      test("With ${value.runtimeType} —> $value.", () {
        final testRes = value
            // map this value into a Set of int
            .castOr<Set<int>>((val) => {val is int ? val : 43})
            // and fetch it back as an int
            .castOr<int>((val) => val?.toList().elementAtOrNull(0) ?? 34);
        expect(testRes, TypeMatcher<int>());
      });
    }
  });
}

@isTest
void _testWithSamples<T>(
  String testName,
  Set<dynamic> samples,
  Object? Function(Object? object) testCase,
) {
  group("$testName will return expected type <$T>", () {
    for (final value in samples) {
      test("With ${value.runtimeType} —> $value.", () {
        final transformedValue = testCase(value);
        expect(transformedValue, TypeMatcher<T>());
      });
    }
  });
}

final _values = {
  null,
  33,
  "myString",
  [33, "myString"]
};
