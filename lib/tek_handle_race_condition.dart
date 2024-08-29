library tek_handle_race_condition;

import 'dart:async';

typedef TekHandleRaceConditionCallback<T> = Future<T> Function();

class TekHandleRaceCondition<T> {
  TekHandleRaceCondition();

  Completer<T>? _completer;

  bool? get isCompleted => _completer?.isCompleted;

  void reset() {
    _completer = null;
  }

  /// Nếu chưa khởi tạo thì khởi tạo Completer mới
  /// Nếu đã khởi tạo rồi thì check isCompleted
  /// Nếu isCompleted đã hoàn thành thì tạo Completer mới và chạy lại luồng cũ
  /// Nếu isCompleted chưa hoàn thành thì trả về future cũ
  Future<T?> call(TekHandleRaceConditionCallback<T> callback) async {
    if (_completer != null) return _completer!.future;
    _completer = Completer<T>();
    final result = await _handleCallBack(callback);
    return result;
  }

  Future _handleCallBack(TekHandleRaceConditionCallback<T> callback) async {
    late final dynamic result;
    try {
      // Call API
      result = await callback();
      // When API call is done, complete the Completer with the result
      _completer!.complete(result);
    } catch (e) {
      // If there is an error, complete the Completer with the error
      _completer!.completeError(e);
      result = null;
    }
    reset();
    return result;
  }
}
