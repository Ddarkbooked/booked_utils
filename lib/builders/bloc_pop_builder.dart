import 'package:booked_utils/wrappers/wrappers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A convenience widget that toggles the ability to pop the current route
/// based on a BLoC/Cubit state.
///
/// `BlocPopBuilder` listens to a `B extends StateStreamable<S>` (e.g. a
/// `Bloc` or `Cubit`) and evaluates [blockWhen] for every new state. If
/// [blockWhen] returns `true`, the current route **cannot** be popped (i.e.
/// back navigation is blocked). If it returns `false`, the route **can**
/// be popped.
///
/// Internally it:
///  * uses a [BlocListener] to observe state changes;
///  * stores the computed `canPop` value in a [ValueNotifier] (via
///    [ValueNotifierWrapper]);
///  * exposes that value to a [PopScope] so the system back gesture / back
///    button honors the computed `canPop`.
///
/// The [child] subtree is passed as the `child` parameter of
/// [ValueListenableBuilder] so it doesn't rebuild when `canPop` changes; only
/// the [PopScope] wrapper is rebuilt.
///
/// {@tool snippet}
/// ### Basic usage
/// Block back navigation while a form is saving:
///
/// ```dart
/// BlocPopBuilder<MyBloc, MyState>(
///   bloc: context.read<MyBloc>(),
///   // Block when we're busy (e.g. saving / loading).
///   blockWhen: (state) => state is MySavingState,
///   child: const MyFormScreen(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///  * [PopScope], which controls whether the route can pop.
///  * [BlocListener], which is used to react to BLoC/Cubit state changes.
///  * [ValueListenableBuilder], which rebuilds only the wrapper when `canPop` changes.
class BlocPopBuilder<B extends StateStreamable<S>, S> extends StatelessWidget {
  /// Creates a [BlocPopBuilder].
  ///
  /// The [bloc], [child], and [blockWhen] parameters must not be null.
  const BlocPopBuilder({
    required this.bloc,
    required this.child,
    required this.blockWhen,
    super.key,
  });

  /// The BLoC/Cubit whose state drives the pop-blocking behavior.
  ///
  /// Typically obtained via `context.read<B>()` or passed from above.
  final B bloc;

  /// The subtree to display. It is not rebuilt when the `canPop` value changes.
  final Widget child;

  /// A predicate that decides whether back navigation should be blocked
  /// for a given state.
  ///
  /// Return `true` to **block** popping (i.e. `canPop == false`),
  /// return `false` to **allow** popping (i.e. `canPop == true`).
  final bool Function(S state) blockWhen;

  @override
  Widget build(BuildContext context) => ValueNotifierWrapper<bool>(
    initialValue: true,
    child: (popNotifier) => BlocListener<B, S>(
      bloc: bloc,
      listener: (_, state) => popNotifier.value = !blockWhen(state),
      child: ValueListenableBuilder<bool>(
        valueListenable: popNotifier,
        builder: (_, canPop, child) =>
            PopScope<void>(canPop: canPop, child: child!),
        child: child,
      ),
    ),
  );
}
