library tek_handle_race_condition;

import 'dart:async';

typedef TekHandleRaceConditionCallback<T> = Future<T> Function();

class TekHandleRaceCondition<T> {
  TekHandleRaceCondition();

  Completer<T>? _completer;

  bool? get isCompleted => _completer?.isCompleted;

  Future<T> call(TekHandleRaceConditionCallback<T> callback) async {
    // Nếu chưa khởi tạo thì khởi tạo Completer mới
    // Nếu đã khởi tạo rồi thì check isCompleted
    // Nếu isCompleted đã hoàn thành thì tạo Completer mới và chạy lại luồng cũ
    // Nếu isCompleted chưa hoàn thành thì trả về future cũ
    if (_completer == null || _completer!.isCompleted) {
      _completer = Completer<T>();
      await _handleCallBack(callback);
      return _completer!.future;
    }

    // Nếu chưa hoàn thành thì trả về future cũ
    return _completer!.future;
  }

  Future _handleCallBack(TekHandleRaceConditionCallback<T> callback) async {
    try {
      // Call API
      final result = await callback();
      // When API call is done, complete the Completer with the result
      _completer!.complete(result);
    } catch (e) {
      // If there is an error, complete the Completer with the error
      _completer!.completeError(e);
    }
  }
}
