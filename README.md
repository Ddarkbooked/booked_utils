# Booked Utils

A set of practical utilities for building Flutter apps faster: typed builders, wrappers for common patterns (`ValueNotifier`, `StreamController`), stream extensions, and chunked transformations.

## Features

- **Typed Widget Builders** (`CallbackWidgetBuilder`)
- **Reactive Wrappers** for `ValueNotifier` and `StreamController`
- **Stream Extensions** (e.g., doOnFirst)
- **Chunked List Stream Transformer**
- **Navigation & Route Guards** (`BlocPopBuilder`)

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  booked_utils: ^<latest_version>
```

Import in your Dart files:

```dart
import 'package:booked_utils/booked_utils.dart';
```

> Note: `BlocPopBuilder` requires `flutter_bloc` in your app. Add it to your `pubspec.yaml` if you don't already use it.

```yaml
dependencies:
  flutter_bloc: ^8.1.5
```

---

## Contents

### 1. `CallbackWidgetBuilder<T>`

```dart
typedef CallbackWidgetBuilder<T> = Widget Function(T value);
```

A generic typedef for widget builders that take a value of type `T`.

---

### 2. `ValueNotifierWrapper<T>`

```dart
ValueNotifierWrapper<int>(
  initialValue: 0,
  onChange: (value) => print('Value changed: $value'),
  child: (notifier) => ValueListenableBuilder<int>(
    valueListenable: notifier,
    builder: (context, value, _) => Text('Value: $value'),
  ),
)
```

Wraps a `ValueNotifier` for local, reactive state. Automatically disposes the notifier and can notify about changes.

---

### 3. `StreamControllerWrapper<T>`

```dart
StreamControllerWrapper<String>(
  child: (controller) => StreamBuilder<String>(
    stream: controller.stream,
    builder: (context, snapshot) => Text(snapshot.data ?? ''),
  ),
)
```

Manages the lifecycle of a `StreamController` and exposes it to a widget subtree.

---

### 4. `ChunkTransformer<T>`

```dart
final chunkedStream = Stream.value(List.generate(10000, (i) => i))
  .transform(const ChunkTransformer<int>(chunkSize: 1024));
await for (final chunk in chunkedStream) {
  print('Chunk size: ${chunk.length}');
}
```

A `StreamTransformer` that splits large incoming lists into fixed-size chunks. Useful for chunked uploads, network transfers, or file operations.

---

### 5. `DoOnFirstEvent<T>` Extension

```dart
Stream<int>.fromIterable([1, 2, 3])
  .doOnFirst((first) async => print('First event: $first'))
  .listen(print); // Prints: First event: 1, then 1, 2, 3
```

Allows performing an action (sync or async) on the first event of a stream, for initialization or logging.

---

### 6. `BlocPopBuilder<B, S>`

```dart
BlocPopBuilder<MyBloc, MyState>(
  bloc: context.read<MyBloc>(),
  // Return `true` to BLOCK pop, `false` to ALLOW pop
  blockWhen: (state) => state is SavingState,
  child: const MyFormScreen(),
)
```

A widget that controls back navigation based on BLoC/Cubit state using a `blockWhen` predicate. Internally it listens to the provided `bloc` and feeds a computed `canPop` value into `PopScope`, so system back gestures and buttons respect your rule.

---

## Why use booked_utils?

- **Reduces boilerplate:** No need to manually manage controllers or notifiers for simple scenarios.
- **Composable patterns:** Designed for local state and micro-architecture without global dependencies.
- **Production-ready:** Null-safe, thoroughly tested in real Flutter apps.

---

## API Reference

Each class and extension is documented with code samples in the source. See  

- [`ValueNotifierWrapper`](./lib/wrappers/value_notifier_wrapper.dart)  
- [`StreamControllerWrapper`](./lib/wrappers/stream_controller_wrapper.dart)  
- [`ChunkTransformer`](./lib/transformers/chunk_transformer.dart)  
- [`DoOnFirstEvent`](./lib/extensions/do_on_first_event.dart)  
- [`CallbackWidgetBuilder`](./lib/typedefs/callback_widget_builder.dart)  
- [`BlocPopBuilder`](./lib/builders/bloc_pop_builder.dart)

---

## License

MIT
