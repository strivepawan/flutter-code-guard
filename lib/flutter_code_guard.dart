import 'dart:io';
import 'dart:convert';

/// Run a one-time Dart analyzer check
Future<void> runAnalyzer() async {
  final result = await Process.run('dart', ['analyze', '--format=json']);

  // Try to parse JSON output from stderr first (when there are issues)
  if (result.stderr.isNotEmpty) {
    try {
      final output = jsonDecode(result.stderr);
      if (output['diagnostics'] != null) {
        for (final issue in output['diagnostics']) {
          final file = issue['location']['file'];
          final line = issue['location']['range']['start']['line'];
          final severity = issue['severity'];
          final message = issue['problemMessage'];
          print("⚠️  $severity at $file:$line: $message");
        }
        return;
      }
    } catch (e) {
      // If JSON parsing fails, try stdout
    }
  }

  // Try stdout as fallback
  if (result.stdout.isNotEmpty) {
    try {
      final output = jsonDecode(result.stdout);
      if (output['diagnostics'] != null) {
        for (final issue in output['diagnostics']) {
          final file = issue['location']['file'];
          final line = issue['location']['range']['start']['line'];
          final severity = issue['severity'];
          final message = issue['problemMessage'];
          print("⚠️  $severity at $file:$line: $message");
        }
        return;
      }
    } catch (e) {
      // JSON parsing failed
    }
  }

  if (result.exitCode != 0) {
    print('❌ Analyzer failed: ${result.stderr}');
    return;
  }

  print('✅ No issues found!');
}

/// Watch project files and re-run analyzer when code changes
Future<void> watchAndAnalyze() async {
  final dir = Directory.current;

  await runAnalyzer(); // first run

  dir.watch(recursive: true).listen((event) {
    if (event.type == FileSystemEvent.modify &&
        event.path.endsWith('.dart')) {
      print("\n💾 File changed: ${event.path}");
      runAnalyzer();
    }
  });
}
