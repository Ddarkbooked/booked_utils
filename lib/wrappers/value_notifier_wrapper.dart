import 'package:booked_utils/booked_utils.dart';
import 'package:flutter/widgets.dart';

/// A [StatefulWidget] that manages a [ValueNotifier] and provides it to its [child] builder.
///
/// [ValueNotifierWrapper] simplifies working with [ValueNotifier] by handling its creation,
/// disposal, and optionally reacting to value changes via [onChange]. This widget is useful
/// for local, ephemeral state that doesn't require a full-blown state management solution,
/// and for building simple, reactive UI patterns.
///
/// The [child] builder receives the [ValueNotifier] so it can be used with widgets like [ValueListenableBuilder].
///
/// ## Example
///
/// ```dart
/// ValueNotifierWrapper<int>(
///   initialValue: 0,
///   onChange: (value) => print('Value changed: $value'),
///   child: (notifier) => ValueListenableBuilder<int>(
///     valueListenable: notifier,
///     builder: (context, value, _) => Text('Current value: $value'),
///   ),
/// )
/// ```
///
/// See also:
///
///  * [ValueNotifier], a simple class for holding a single value and notifying listeners.
///  * [ValueListenableBuilder], which rebuilds when a [ValueListenable] changes.
///  * [StreamControllerWrapper], for managing a [StreamController] in a similar pattern.
///  * [CallbackWidgetBuilder], the typedef used for the [child] builder.
class ValueNotifierWrapper<T> extends StatefulWidget {
  /// Creates a [ValueNotifierWrapper].
  ///
  /// The [initialValue] is used to initialize the [ValueNotifier].
  /// The [child] builder receives the [ValueNotifier] instance.
  /// The optional [onChange] callback is called whenever the value changes.
  const ValueNotifierWrapper({
    required this.initialValue,
    required this.child,
    this.onChange,
    super.key,
  });

  /// The initial value for the [ValueNotifier].
  final T initialValue;

  /// Callback called when the [ValueNotifier] value changes.
  final ValueChanged<T>? onChange;

  /// Called to build the widget subtree and provides the [ValueNotifier].
  final CallbackWidgetBuilder<ValueNotifier<T>> child;

  @override
  State<ValueNotifierWrapper<T>> createState() =>
      _ValueNotifierWrapperState<T>();
}

class _ValueNotifierWrapperState<T> extends State<ValueNotifierWrapper<T>> {
  late final ValueNotifier<T> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier<T>(widget.initialValue);

    if (widget.onChange == null) return;
    _notifier.addListener(() => widget.onChange?.call(_notifier.value));
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child(_notifier);
}
