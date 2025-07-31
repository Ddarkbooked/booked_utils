import 'package:flutter/widgets.dart';

/// Signature for a function that creates a widget for a given value of type [T].
///
/// Used for scenarios where a widget needs to be built from a single value,
/// such as mapping a data model to a widget.
///
/// See also:
///
///  * [WidgetBuilder], which is similar but takes a [BuildContext].
///  * [IndexedWidgetBuilder], which is similar but also takes an index and a [BuildContext].
///  * [ValueWidgetBuilder], which is similar but takes a value and a child widget.
///  * [TransitionBuilder], which is similar but also takes a child.
typedef CallbackWidgetBuilder<T> = Widget Function(T value);
