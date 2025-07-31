import 'dart:async';

/// A [StreamTransformer] that splits incoming lists into smaller fixed-size chunks.
///
/// This transformer takes a stream of lists and emits sublists of at most [chunkSize] elements.
/// Useful for processing or transmitting large lists in manageable parts, for example,
/// when sending data over a network or writing to files in chunks.
///
/// The last chunk may be smaller than [chunkSize] if there are not enough remaining elements.
///
/// ## Example
///
/// ```dart
/// final dataStream = Stream.value(List.generate(10000, (i) => i));
/// final chunkedStream = dataStream.transform(const ChunkTransformer<int>(chunkSize: 1024));
/// await for (final chunk in chunkedStream) {
///   print('Chunk with ${chunk.length} items');
/// }
/// ```
///
/// See also:
///
///  * [StreamTransformer], which is the base class for all stream transformations.
///  * [Stream.chunked] (extension in package:collection), which splits iterables into chunks.
///
class ChunkTransformer<T> implements StreamTransformerBase<List<T>, List<T>> {
  /// Creates a [ChunkTransformer] that emits sublists of at most [chunkSize] elements.
  ///
  /// The [chunkSize] must be greater than zero. Defaults to 8192.
  const ChunkTransformer({this.chunkSize = 8192});

  /// The maximum number of elements in each emitted chunk.
  final int chunkSize;

  @override
  Stream<List<T>> bind(Stream<List<T>> stream) => stream.transform(
    StreamTransformer<List<T>, List<T>>.fromHandlers(
      handleData: (data, sink) {
        var start = 0;
        while (start < data.length) {
          var end = start + chunkSize;
          if (end > data.length) end = data.length;
          sink.add(data.sublist(start, end));
          start = end;
        }
      },
    ),
  );

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<List<T>, List<T>, RS, RT>(this);
}
