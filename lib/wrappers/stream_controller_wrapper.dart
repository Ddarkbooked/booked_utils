import 'dart:async';

import 'package:booked_utils/booked_utils.dart';
import 'package:flutter/widgets.dart';

/// A [StatefulWidget] that provides a [StreamController] to its [child] builder and
/// handles the controller's lifecycle.
///
/// [StreamControllerWrapper] is useful for managing a [StreamController] within
/// a widget subtree, ensuring the controller is properly created and disposed,
/// and allowing callbacks for stream listen and cancel events.
///
/// This widget is commonly used in scenarios where a local [StreamController] is
/// required for event handling, such as for reactive UI updates, simplified
/// state management, or custom input streams.
///
/// ## Example
///
/// ```dart
/// StreamControllerWrapper<int>(
///   child: (controller) {
///     return StreamBuilder<int>(
///       stream: controller.stream,
///       builder: (context, snapshot) {
///         return ElevatedButton(
///           onPressed: () => controller.add(1),
///           child: Text('Current value: ${snapshot.data ?? 0}'),
///         );
///       },
///     );
///   },
/// )
/// ```
///
/// See also:
///
///  * [StreamController], which provides a way to manage a stream of events.
///  * [StreamBuilder], which builds a widget tree based on the latest snapshot of interaction with a [Stream].
///  * [ValueNotifierWrapper], a similar pattern but for [ValueNotifier].
class StreamControllerWrapper<T> extends StatefulWidget {
  /// Creates a [StreamControllerWrapper].
  ///
  /// The [child] parameter must not be null.
  /// The [sync] parameter controls whether the [StreamController] is synchronous.
  /// The [onListen] and [onCancel] callbacks are invoked when the underlying
  /// stream is listened to or canceled, respectively.
  const StreamControllerWrapper({
    required this.child,
    this.onListen,
    this.onCancel,
    this.sync = false,
    super.key,
  });

  /// Called to build the widget subtree and provides the [StreamController].
  final CallbackWidgetBuilder<StreamController<T>> child;

  /// Optional callback when the stream is first listened to.
  final VoidCallback? onListen;

  /// Optional callback when the stream subscription is canceled.
  final VoidCallback? onCancel;

  /// Whether the [StreamController] is synchronous.
  final bool sync;

  @override
  State<StreamControllerWrapper<T>> createState() =>
      _StreamControllerWrapperState<T>();
}

class _StreamControllerWrapperState<T>
    extends State<StreamControllerWrapper<T>> {
  late final StreamController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<T>(
      sync: widget.sync,
      onListen: widget.onListen,
      onCancel: widget.onCancel,
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child(_controller);
}
