/// Cast Or provide default value (optional or safely defaulted)
/// ```
///           ___
///          /. .\
///         =\_t_/=
///           [|]
/// ```
extension CastOrExtension<FROM> on FROM {
  TO? let<TO extends Object>(TO? Function(FROM value) func) {
    final that = this;
    return that != null ? func(that) : null;
  }

  /// Safely cast anything :
  ///
  /// ```dart
  /// null.castOrNull<int>()?.isFinite; // stupid but fine...
  /// null.castOrNull<int>((val) => 34)?.isFinite; // stupid but fine...
  /// null.castOrNull<int>((val) => val ?? 34)?.isFinite; // stupid but fine...
  /// ```
  ///
  TO? castOrNull<TO extends Object>([CastOrNullFallback<FROM, TO>? rescue]) =>
      _castOrNullImpl(this, rescue);

  /// It worth mentioning that [castOr] can provide a complete other type than
  /// the original one, for example :
  /// ```dart
  /// "String".as<List<String?>>((val) => [val]); => List<String?> => ["String"]
  /// ```
  TO castOr<TO extends Object>(CastOrFallback<FROM, TO> rescue) =>
      _castOrImpl<TO, FROM>(this, rescue);
}

TO castOr<TO extends Object>(
        Object? input, CastOrFallback<Object, TO> rescue) =>
    _castOrImpl(input, rescue);

TO? castOrNull<TO extends Object>(Object? input,
        [CastOrNullFallback<Object, TO>? rescue]) =>
    _castOrNullImpl(input, rescue);

typedef CastOrNullFallback<FROM, TO extends Object> = TO? Function(FROM? it);
typedef CastOrFallback<FROM, TO extends Object?> = TO Function(FROM? it);

TO _castOrImpl<TO extends Object, FROM>(
    FROM? input, CastOrFallback<FROM, TO> rescue) {
  if (input is TO) {
    return input;
  } else {
    return rescue(input);
  }
}

TO? _castOrNullImpl<TO extends Object, FROM>(FROM? input,
    [CastOrNullFallback<FROM, TO>? rescue]) {
  if (input is TO) {
    return input;
  } else {
    return rescue != null ? rescue(input) : null;
  }
}

// O? tryCast<O extends I>([CastOrNullFallback? rescue]) {
//   final that = this;
//   final valueTransformer = rescue ?? (val) => that is O ? that : null;
//   try {
//     return valueTransformer(that);
//   } catch (_) {
//     // guard anything
//     return null;
//   }
// }
