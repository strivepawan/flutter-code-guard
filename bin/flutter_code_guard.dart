import 'package:flutter_code_guard/flutter_code_guard.dart';

void main(List<String> arguments) async {
  if (arguments.contains('--watch')) {
    print('👀 Watching project files for changes...');
    await watchAndAnalyze();
  } else {
    print('🔍 Running one-time analysis...');
    await runAnalyzer();
  }
}
