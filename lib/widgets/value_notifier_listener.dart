import 'package:flutter/widgets.dart';

/// A widget that listens to a [ValueNotifier] and triggers [onChange]
/// without rebuilding the widget tree.
///
/// [ValueNotifierListener] wires up a listener to the provided [notifier]
/// in [initState] and removes it in [dispose]. When the notifier's value
/// changes, it calls the [onChange] callback with the latest value. The
/// [child] is returned directly from [build] and is not rebuilt when the
/// value changes.
///
/// This is useful for performing side effects (e.g. showing a SnackBar,
/// triggering an animation, logging) in response to value changes while
/// keeping the UI stable. If you need to rebuild UI when the value changes,
/// prefer using [ValueListenableBuilder].
///
/// Example
///
/// ```dart
/// final counter = ValueNotifier<int>(0);
///
/// ValueNotifierListener<int>(
///   notifier: counter,
///   onChange: (value) => debugPrint('Counter: $value'),
///   child: const Text('Static child'),
/// )
/// ```
///
/// See also:
///  * [ValueNotifier], a simple value holder that notifies listeners.
///  * [ValueListenableBuilder], which rebuilds when a [ValueListenable] changes.
///  * [ValueNotifierWrapper], which manages a [ValueNotifier] lifecycle and
///    exposes it to a builder.
class ValueNotifierListener<T> extends StatefulWidget {
  /// Creates a [ValueNotifierListener].
  ///
  /// The [notifier] is listened to for changes. The [onChange] callback is
  /// invoked with the new value when the notifier updates. The [child] is
  /// returned as-is from [build] and does not rebuild on changes.
  const ValueNotifierListener({
    required this.notifier,
    required this.onChange,
    required this.child,
    super.key,
  });

  /// The [ValueNotifier] whose value changes will be listened to.
  final ValueNotifier<T> notifier;
  
  /// Callback invoked when [notifier] value changes.
  final ValueChanged<T> onChange;

  /// The subtree that does not rebuild on notifier changes.
  final Widget child;

  @override
  State<ValueNotifierListener<T>> createState() =>
      _ValueNotifierListenerState<T>();
}

class _ValueNotifierListenerState<T> extends State<ValueNotifierListener<T>> {
  @override
  void initState() {
    super.initState();

    widget.notifier.addListener(onChange);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(onChange);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void onChange() => widget.onChange(widget.notifier.value);
}
