import 'dart:async';

class CancellableTask<T> {
  final Future<T> _future;
  bool _isCancelled = false;

  CancellableTask(this._future);

  void cancel() {
    _isCancelled = true;
  }

  Future<T?> get value async {
    try {
      final result = await _future;
      return _isCancelled ? null : result;
    } catch (e) {
      if (!_isCancelled) {
        rethrow;
      }
      return null;
    }
  }
}
