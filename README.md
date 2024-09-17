# CastOr 🦫

CastOr provide a `.castOr<T>(())`, `.castOrNull<T>()` helpers and extension to safely transform/cast and provide defaults values
when you deal with untyped data. The package provide also a `.let<T>()` implementation (similar to kotlin).

This package try to solve 2 typical issue when dealing with nullsafety on your dart projects. 

`as` casting will fail if we not ensure the type before, and the usage of the `!` postfix null promotion operator.
Both usage should be avoided at all cost. 

Consider the following code :

```dart
void main() {
  dynamic a = 3;
  final String? s;
  try {
    s = a as S;
  } catch (e) {
    s = null;
  }
}
```

which can be solved  

```dart
import 'package:castor/castor.dart';

void main() {
  dynamic dyn = null;
  final obj = (dyn as Object?);
  // the basic [castOr] always expect to get an uwrapped value of the input type    
  int b = obj.castOr<String>(a, (_) => 'alternative string').length;
  int c = castOr<int>(a, (_) => 'alternative string').length;
  
  // the [castOrNull] equivalent just accept a nullable when casting is wrong
  bool? asHelper = castOrNull<bool>(a, (_) => 'alternative string').length;
  bool? asExt = obj?.castOrNull();
  
  int? s = castOrNull<String>(a)?.length;
  /// and with [a] an Object?
  int s2 = a?.castOr<String>((val) => 'alternative string').length;
  int? s = a?.castOrNull<String>(a)?.length;
}
```

It's ok for now but this will crash probably at some time if someone remove the if clause, because no static analysis will check on the code.

## Usage

### `.castOr` casting or provide a default value

You want ensure that the given value is of the correct type without having 
to mix with error prone `as` keyword. Consider the following code :

```dart
void main() {
  dynamic a = 3;
  final String? s;
  try {
    s = a as S;
  } catch (e) {
    s = null;
  }
}
``` 


```dart
import 'package:castor/castor.dart';


void main () {
  /// considering [a] a dynamic
  int s2 = castOr<String>(a, (_) => 'alternative string').length;
  int? s = castOrNull<String>(a)?.length;
  /// and with [a] an Object?
  int s2 = a?.castOr<String>((val) => 'alternative string').length;
  int? s = a?.castOrNull<String>(a)?.length;
}
```

### promoting

promoting with the `!` should be avoided at all cost. With the following code :

```dart
if (this.a != null) this.a!.length;
```

It's ok for now but this will crash probably at some time if someone remove the if clause, because no static analysis will check on the code. 

## Additional information

Before writing this package, I found many other alternative solutions, most of them trying to mimic the `.let`
behavior of kotlin, and other `guard` keyword to ensure null safety everywhere in the code.

I choose to publish this little one because of the cute name but mostly about the small footprint or your codebase.

Regarding dart and null safety right now, there is 3 common pitfalls when you start believing in nullsafety in dart.

- First is the `dynamic` keyword, and the `!` postfix null promotion operator. Both should be avoid at all cost and you should prefer the `Object?` which is not equivalent but can be simply switch 
- Secondly, you'll have to check the `as` keyword, which without concealing it into a try/catch block or prefixing with `if (a is b)` control block.
- And finally, there is a lot of throwing methods out there that you can't avoid staticaly without tools like DCM.

## Trivia

_"Castor"_ is the french word for _"Beaver"_. That's why you should find a beaver symbol 🦫 there and there.

```txt
             ██  ██████████████▓▓██  ████
           ██▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒██
           ██▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒██
             ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
           ██▒▒▒▒▒▒██▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▓▓
         ██▒▒▒▒▒▒▒▒██▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒██
       ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
     ██▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
     ██▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒██  ░░
     ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒██
     ██▒▒▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒██
     ██▒▒▒▒▓▓██████████████████▓▓▒▒▒▒▒▒▒▒▒▒▓▓▒▒██
     ▓▓▒▒▒▒▒▒▓▓██    ██    ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒██
     ██▒▒▒▒▒▒▒▒██    ██    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
     ██▒▒▒▒▒▒▒▒██    ██    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒██
     ██▓▓▒▒▒▒▒▒▒▒██████████▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒██
       ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██░░██▒▒▒▒▒▒▒▒▒▒▓▓▒▒██
         ████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██░░▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▓▓▒▒██
             ████▓▓▒▒▓▓██████▓▓██░░▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ████████
                 ██▓▓██▒▒▒▒▓▓██░░▒▒██▓▓▒▒▒▒██▒▒▒▒██▒▒▓▓▒▒██  ██▒▒▒▒▒▒▒▒██
                 ██▒▒▒▒▒▒▓▓██░░▒▒▒▒▒▒██▓▓▒▒▒▒▒▒▓▓██▒▒▒▒▓▓▒▒██▒▒▓▓▓▓▒▒▓▓▒▒██
                 ██▓▓▓▓▓▓██░░▒▒▒▒▒▒██▓▓██▓▓▓▓▓▓██▓▓▒▒▒▒▒▒▒▒██▓▓▒▒▓▓▓▓▓▓▓▓██
                 ██████████▒▒▒▒▒▒██▓▓▓▓▓▓██████▓▓▒▒▒▒▓▓▒▒▒▒██▓▓▓▓▓▓▓▓▒▒▓▓██
                 ██▓▓██░░░░██▒▒▒▒██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒██▓▓▓▓▓▓▓▓▓▓▓▓██
                 ██▓▓▓▓██░░░░████▒▒██▒▒▒▒▓▓▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒██▓▓▒▒▓▓▓▓▓▓████
                   ██▓▓▓▓████▓▓▓▓██▒▒██▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▓▓▓▓▓▓████
                   ██▓▓▓▓▓▓▓▓▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██▓▓▓▓▒▒████
                 ██████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██████████████████████
               ██░░░░░░██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██░░░░░░░░░░░░████████
             ██▒▒██▒▒▒▒▒▒██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒▒▒▒▒▒██▒▒██▒▒▒▒██
             ██▓▓██████████████▓▓████████████████████████████▓▓
 credits : https://textart.sh/topic/beaver
```

## More

- Discussion about the `let` keyword https://github.com/dart-lang/language/issues/2703
- Null safety patterns https://github.com/dart-lang/language/blob/main/accepted/3.0/patterns/feature-specification.md
