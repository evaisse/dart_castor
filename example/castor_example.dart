import 'package:castor/castor.dart';

dynamic fetchDynamicValue([dynamic input]) {
  return input;
}

class Url {
  Url._();
  static Url? tryParse(String url) {
    return url.isEmpty ? null : Url._();
  }
}

void main() {
  final myValue = fetchDynamicValue() as Object?;

  /// You get an unexpected value, and you want to ensure the type is correct
  /// or provide another value.
  myValue?.castOrNull<int>()?.isOdd;

  /// You can also map it by providing an alternative value
  /// or provide another value.
  myValue?.castOrNull<int>((it) => 32)?.isOdd;
  final int myNum = (null as Object?).castOr((it) => 32);

  /// or even unwrap and get a default value in any case,
  /// this one duplicate the elegant `??`operator but if you plan
  /// to chain call is a handy helper.
  (null as Object?).castOr<int>((it) => 32).isOdd;
  final int myNumBis = (null as Object?).castOr((it) => 32);

  /// When the input value is a dynamic one, you should not try to use castOr
  /// as a extension since it will
  final dynamic myDynamicRef = fetchDynamicValue();
  castOr<int>(myDynamicRef, (it) => 32).isOdd;
  castOrNull<int>(myDynamicRef)?.isOdd;

  /// You can also transform the sample value into another.
  /// This is very helpful while chaining method calls.
  (myValue)
      // map this value into a Set of int
      ?.castOr<Set<int>>((it) => {it is int ? it : 43})
      // and fetch it back as an int
      .castOr<int>((it) => it?.toList().elementAtOrNull(0) ?? 34)
      // you can provide mostly any transformation there
      .isFinite;

  /// You can just transform a value into another type
  final result = 42.castOr<Set<int>>((i) => {i ?? 45});

  /// A classic is when you have to deal with nullable values AND
  /// nullable parameters, take the following example...
  /// ```dart
  ///   Uri? valueTransformer(String? url) {
  ///     final thisUri = url;
  ///     if (thisUri == null) return null;
  ///     return Uri.tryParse(thisUrl);
  ///   }
  /// ```
  final String? urlString = '...';
  final url1 = urlString?.let<Url>(Url.tryParse);
  final Url? url2 = urlString?.let(Url.tryParse); // note the inference
}
