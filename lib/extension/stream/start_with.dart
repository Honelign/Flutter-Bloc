import 'package:async/async.dart' show StreamGroup;

extension StartWith<T> on Stream<T> {
  // what it does is that when first loads the stream starts immediately
  //then it will subscribe to other stream
  //you can find the detailed video on minute 6 hour and 18 minute in navad bloc tutorial
  Stream<T> startWith(T value) => StreamGroup.merge([
        this,
        Stream<T>.value(value),
      ]);
}
