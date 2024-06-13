## Features

- Flutter handle race condition

## Getting started

- Add this to your package's pubspec.yaml file

```yaml
dependencies: 
  tek_handle_race_condition: ^0.0.1
```

## Usage

```dart
import 'package:tek_handle_race_condition/tek_handle_race_condition.dart';

void main() async {
  final TekHandleRaceCondition<String> tekHandleRaceCondition = TekHandleRaceCondition<String>();

  final DateTime time = DateTime.now();
  print("Start time: $time");

  Future<String> callApi(int i) async {
    await Future.delayed(Duration(seconds: i));
    return 'After ${i}s: $i';
  }

  final result = await Future.wait([
    tekHandleRaceCondition.call(() => callApi(2)),
    tekHandleRaceCondition.call(() => callApi(3)),
    tekHandleRaceCondition.call(() => callApi(4)),
    tekHandleRaceCondition.call(() => callApi(5)),
  ]);

  print("tekHandleRaceCondition.isCompleted ${tekHandleRaceCondition.isCompleted}");

  print("End time: ${DateTime.now()}");
  print("Time run function: ${DateTime.now().difference(time).inSeconds}s");

  print("Result: $result");
}
```

## ❤️ Buy me a coffee

[![](https://raw.githubusercontent.com/nghetien/tek_handle_race_condition/main/assets/images/Buy-me-a-coffee.png)](https://buymeacoffee.com/nghequyetts)
