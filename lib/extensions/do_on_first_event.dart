/// An extension on [Stream] that allows performing an action on the first event.
///
/// The [doOnFirst] method executes the provided [onFirst] callback
/// with the first event emitted by the stream, before yielding any events downstream.
///
/// This is useful for scenarios such as lazy initialization, logging, authentication,
/// or resource allocation that should occur only once, just before processing the stream.
///
/// The [onFirst] callback can be asynchronous; the stream will pause
/// until [onFirst] completes before passing the first event further.
///
/// ## Example
///
/// ```dart
/// Stream<int>.fromIterable([1, 2, 3])
///   .doOnFirst((event) async {
///     print('First event is $event');
///   })
///   .listen(print); // Prints: First event is 1 \n 1 \n 2 \n 3
/// ```
///
/// See also:
///
///  * [Stream.doOnData] in [rxdart](https://pub.dev/packages/rxdart), which allows reacting to every event.
extension DoOnFirstEvent<T> on Stream<T> {
  /// Invokes [onFirst] with the first event emitted by the stream before any events are yielded.
  ///
  /// The [onFirst] callback can return a [Future]; the stream waits for this
  /// future to complete before forwarding the first event.
  ///
  /// Subsequent events are passed through without invoking [onFirst].
  Stream<T> doOnFirst(Future<void> Function(T event) onFirst) async* {
    var isFirst = true;

    await for (final event in this) {
      if (isFirst) {
        isFirst = false;
        await onFirst(event);
      }
      yield event;
    }
  }
}
