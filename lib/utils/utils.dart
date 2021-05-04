import 'dart:convert';
import 'dart:math';

/// small function to always check if mounted before running setState()
void setState(bool mounted, void Function() fn) {
  if (mounted) {
    fn.call();
  }
}

/// courtesy of @modulovalue (https://github.com/modulovalue/dart_intersperse/blob/master/lib/src/intersperse.dart)
/// intersperses elements in between list items - used to insert dividers between
/// toolbar buttons when using [ToolbarType.nativeScrollable]
Iterable<T> intersperse<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;
  if (iterator.moveNext()) {
    yield iterator.current;
    while (iterator.moveNext()) {
      yield element;
      yield iterator.current;
    }
  }
}

/// Generates a random string to be used as the [VisibilityDetector] key.
/// Technically this limits the number of editors to a finite number, but
/// nobody will be embedding enough editors to reach the theoretical limit
/// (yes, this is a challenge ;-) )
String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}