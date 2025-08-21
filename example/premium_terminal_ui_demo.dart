/// Premium Terminal UI Demo for Flutter Code Guard
/// This demonstrates beautiful, interactive terminal UI for code analysis results
library;

import 'dart:io';
import 'dart:math' as math;

// ============================================================================
// TERMINAL UI COMPONENTS
// ============================================================================

/// ANSI Color Codes for beautiful terminal output
class TerminalColors {
  // Basic Colors
  static const String reset = '\x1B[0m';
  static const String bold = '\x1B[1m';
  static const String dim = '\x1B[2m';
  static const String underline = '\x1B[4m';
  static const String blink = '\x1B[5m';
  static const String reverse = '\x1B[7m';

  // Text Colors
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';

  // Bright Colors
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String brightMagenta = '\x1B[95m';
  static const String brightCyan = '\x1B[96m';
  static const String brightWhite = '\x1B[97m';

  // Background Colors
  static const String bgRed = '\x1B[41m';
  static const String bgGreen = '\x1B[42m';
  static const String bgYellow = '\x1B[43m';
  static const String bgBlue = '\x1B[44m';
  static const String bgMagenta = '\x1B[45m';
  static const String bgCyan = '\x1B[46m';

  // Custom RGB Colors (24-bit)
  static String rgb(int r, int g, int b) => '\x1B[38;2;$r;$g;${b}m';
  static String bgRgb(int r, int g, int b) => '\x1B[48;2;$r;$g;${b}m';
}

/// Terminal UI Icons and Symbols
class TerminalIcons {
  // Status Icons
  static const String error = '❌';
  static const String warning = '⚠️';
  static const String info = 'ℹ️';
  static const String success = '✅';
  static const String loading = '🔄';

  // Industry Icons
  static const String fintech = '💰';
  static const String healthcare = '🏥';
  static const String ecommerce = '🛒';
  static const String gaming = '🎮';
  static const String enterprise = '🏢';

  // Code Icons
  static const String file = '📄';
  static const String folder = '📁';
  static const String security = '🔒';
  static const String performance = '⚡';
  static const String bug = '🐛';
  static const String fix = '🔧';
  static const String suggestion = '💡';

  // Progress Indicators
  static const List<String> spinner = [
    '⠋',
    '⠙',
    '⠹',
    '⠸',
    '⠼',
    '⠴',
    '⠦',
    '⠧',
    '⠇',
    '⠏'
  ];
  static const List<String> dots = ['⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'];
  static const List<String> pulse = ['●', '○', '◐', '◑', '◒', '◓'];
}

/// Terminal Box Drawing Characters
class BoxDrawing {
  // Single Line
  static const String topLeft = '┌';
  static const String topRight = '┐';
  static const String bottomLeft = '└';
  static const String bottomRight = '┘';
  static const String horizontal = '─';
  static const String vertical = '│';
  static const String cross = '┼';
  static const String teeDown = '┬';
  static const String teeUp = '┴';
  static const String teeRight = '├';
  static const String teeLeft = '┤';

  // Double Line
  static const String doubleTopLeft = '╔';
  static const String doubleTopRight = '╗';
  static const String doubleBottomLeft = '╚';
  static const String doubleBottomRight = '╝';
  static const String doubleHorizontal = '═';
  static const String doubleVertical = '║';

  // Rounded
  static const String roundTopLeft = '╭';
  static const String roundTopRight = '╮';
  static const String roundBottomLeft = '╰';
  static const String roundBottomRight = '╯';
}

// ============================================================================
// PREMIUM UI COMPONENTS
// ============================================================================

/// Premium Terminal UI Manager
class PremiumTerminalUI {
  static int _terminalWidth = 120;
  // static int _terminalHeight = 30; // Unused for now

  static void init() {
    try {
      _terminalWidth = stdout.terminalColumns;
      // _terminalHeight = stdout.terminalLines;
    } catch (e) {
      // Use defaults if terminal size detection fails
    }
  }

  /// Clear terminal screen
  static void clearScreen() {
    stdout.write('\x1B[2J\x1B[H');
  }

  /// Move cursor to position
  static void moveTo(int row, int col) {
    stdout.write('\x1B[${row};${col}H');
  }

  /// Hide/Show cursor
  static void hideCursor() => stdout.write('\x1B[?25l');
  static void showCursor() => stdout.write('\x1B[?25h');

  /// Create a fancy header
  static void showHeader(String title, String subtitle) {
    final width = _terminalWidth;
    final padding = (width - title.length) ~/ 2;

    print('');
    print(TerminalColors.brightCyan +
        BoxDrawing.doubleTopLeft +
        BoxDrawing.doubleHorizontal * (width - 2) +
        BoxDrawing.doubleTopRight);
    print(BoxDrawing.doubleVertical +
        ' ' * (padding - 1) +
        TerminalColors.bold +
        TerminalColors.brightWhite +
        title +
        TerminalColors.reset +
        TerminalColors.brightCyan +
        ' ' * (width - title.length - padding - 1) +
        BoxDrawing.doubleVertical);

    if (subtitle.isNotEmpty) {
      final subtitlePadding = (width - subtitle.length) ~/ 2;
      print(BoxDrawing.doubleVertical +
          ' ' * (subtitlePadding - 1) +
          TerminalColors.dim +
          TerminalColors.brightWhite +
          subtitle +
          TerminalColors.reset +
          TerminalColors.brightCyan +
          ' ' * (width - subtitle.length - subtitlePadding - 1) +
          BoxDrawing.doubleVertical);
    }

    print(BoxDrawing.doubleBottomLeft +
        BoxDrawing.doubleHorizontal * (width - 2) +
        BoxDrawing.doubleBottomRight +
        TerminalColors.reset);
    print('');
  }

  /// Create a fancy box around content
  static void showBox(String title, List<String> content, {String color = ''}) {
    final maxContentWidth =
        content.fold(0, (max, line) => math.max(max, _stripAnsi(line).length));
    final boxWidth = math.max(maxContentWidth + 4, title.length + 4);
    final actualColor = color.isNotEmpty ? color : TerminalColors.brightBlue;

    // Top border
    stdout.write(actualColor);
    stdout.write(BoxDrawing.roundTopLeft +
        BoxDrawing.horizontal * (boxWidth - 2) +
        BoxDrawing.roundTopRight);
    stdout.write(TerminalColors.reset + '\n');

    // Title
    if (title.isNotEmpty) {
      final titlePadding = (boxWidth - title.length - 2) ~/ 2;
      stdout.write(actualColor + BoxDrawing.vertical + TerminalColors.reset);
      stdout.write(' ' * titlePadding +
          TerminalColors.bold +
          title +
          TerminalColors.reset);
      stdout.write(' ' * (boxWidth - title.length - titlePadding - 2));
      stdout.write(
          actualColor + BoxDrawing.vertical + TerminalColors.reset + '\n');

      // Separator
      stdout.write(actualColor);
      stdout.write(BoxDrawing.teeRight +
          BoxDrawing.horizontal * (boxWidth - 2) +
          BoxDrawing.teeLeft);
      stdout.write(TerminalColors.reset + '\n');
    }

    // Content
    for (final line in content) {
      final strippedLine = _stripAnsi(line);
      final padding = boxWidth - strippedLine.length - 2;
      stdout.write(
          '${actualColor!}${BoxDrawing.vertical}${TerminalColors.reset}');
      stdout.write(' $line${' ' * (padding > 0 ? padding - 1 : 0)}');
      stdout
          .write('$actualColor${BoxDrawing.vertical}${TerminalColors.reset}\n');
    }

    // Bottom border
    stdout.write(actualColor);
    stdout.write(BoxDrawing.roundBottomLeft +
        BoxDrawing.horizontal * (boxWidth - 2) +
        BoxDrawing.roundBottomRight);
    stdout.write(TerminalColors.reset + '\n');
  }

  /// Show animated progress bar
  static void showProgress(String label, double progress, {String color = ''}) {
    final barWidth = 40;
    final filled = (progress * barWidth).round();
    final empty = barWidth - filled;
    final percentage = (progress * 100).round();
    final actualColor = color.isNotEmpty ? color : TerminalColors.brightGreen;

    stdout.write('\r'); // Return to start of line
    stdout.write('$label ');
    stdout.write(actualColor + '[');
    stdout.write('█' * filled);
    stdout.write(TerminalColors.dim + '░' * empty + TerminalColors.reset);
    stdout.write(actualColor + ']');
    stdout.write(' $percentage%' + TerminalColors.reset);
    stdout.flush();
  }

  /// Show animated spinner
  static void showSpinner(String message, int frame) {
    final spinner = TerminalIcons.spinner[frame % TerminalIcons.spinner.length];
    stdout.write('\r$spinner $message');
    stdout.flush();
  }

  /// Strip ANSI escape codes for length calculation
  static String _stripAnsi(String text) {
    return text.replaceAll(RegExp(r'\x1B\[[0-9;]*[JKmsu]'), '');
  }
}

// ============================================================================
// CODE ANALYSIS RESULT DISPLAY
// ============================================================================

/// Code Issue Severity Levels
enum IssueSeverity { error, warning, info, suggestion }

/// Code Issue Class
class CodeIssue {
  final String file;
  final int line;
  final int column;
  final String rule;
  final String message;
  final IssueSeverity severity;
  final String? suggestion;
  final String? industry;

  const CodeIssue({
    required this.file,
    required this.line,
    required this.column,
    required this.rule,
    required this.message,
    required this.severity,
    this.suggestion,
    this.industry,
  });
}

/// Premium Issue Display
class PremiumIssueDisplay {
  static void showIssue(CodeIssue issue) {
    final severityInfo = _getSeverityInfo(issue.severity);
    final industryIcon = _getIndustryIcon(issue.industry);

    // Issue header with colored background
    print('');
    stdout.write(severityInfo['bgColor']);
    stdout.write(
        ' ${severityInfo['icon']} ${severityInfo['label']!.toUpperCase()} ');
    stdout.write(TerminalColors.reset);

    if (issue.industry != null) {
      stdout.write(' $industryIcon ${issue.industry!}');
    }
    print('');

    // File location
    final location = '${issue.file}:${issue.line}:${issue.column}';
    print('${TerminalColors.dim}📍 $location${TerminalColors.reset}');

    // Rule name
    print(
        '${TerminalColors.brightBlue}🔍 Rule: ${issue.rule}${TerminalColors.reset}');

    // Message
    PremiumTerminalUI.showBox('Issue Description',
        ['${severityInfo['color']!}${issue.message}${TerminalColors.reset}'],
        color: severityInfo['color']!);

    // Code suggestion if available
    if (issue.suggestion != null) {
      PremiumTerminalUI.showBox(
          '💡 Suggestion',
          [
            TerminalColors.brightGreen +
                issue.suggestion! +
                TerminalColors.reset
          ],
          color: TerminalColors.brightGreen);
    }

    print('');
  }

  static void showSummary(List<CodeIssue> issues) {
    final errors =
        issues.where((i) => i.severity == IssueSeverity.error).length;
    final warnings =
        issues.where((i) => i.severity == IssueSeverity.warning).length;
    final infos = issues.where((i) => i.severity == IssueSeverity.info).length;
    final suggestions =
        issues.where((i) => i.severity == IssueSeverity.suggestion).length;

    PremiumTerminalUI.showHeader('📊 Analysis Summary', 'Code Quality Report');

    final summaryLines = <String>[
      if (errors > 0)
        '❌ Errors: ${TerminalColors.brightRed}$errors${TerminalColors.reset}',
      if (warnings > 0)
        '⚠️  Warnings: ${TerminalColors.brightYellow}$warnings${TerminalColors.reset}',
      if (infos > 0)
        'ℹ️  Info: ${TerminalColors.brightBlue}$infos${TerminalColors.reset}',
      if (suggestions > 0)
        '💡 Suggestions: ${TerminalColors.brightGreen}$suggestions${TerminalColors.reset}',
    ];

    if (summaryLines.isEmpty) {
      summaryLines.add(
          '${TerminalColors.brightGreen}✨ No issues found! Code looks great!${TerminalColors.reset}');
    }

    PremiumTerminalUI.showBox('Summary', summaryLines);

    // Quality score
    final qualityScore = _calculateQualityScore(errors, warnings, infos);
    _showQualityScore(qualityScore);
  }

  static Map<String, String> _getSeverityInfo(IssueSeverity severity) {
    switch (severity) {
      case IssueSeverity.error:
        return {
          'icon': TerminalIcons.error,
          'label': 'error',
          'color': TerminalColors.brightRed,
          'bgColor': TerminalColors.bgRed + TerminalColors.brightWhite,
        };
      case IssueSeverity.warning:
        return {
          'icon': TerminalIcons.warning,
          'label': 'warning',
          'color': TerminalColors.brightYellow,
          'bgColor': TerminalColors.bgYellow + TerminalColors.black,
        };
      case IssueSeverity.info:
        return {
          'icon': TerminalIcons.info,
          'label': 'info',
          'color': TerminalColors.brightBlue,
          'bgColor': TerminalColors.bgBlue + TerminalColors.brightWhite,
        };
      case IssueSeverity.suggestion:
        return {
          'icon': TerminalIcons.suggestion,
          'label': 'suggestion',
          'color': TerminalColors.brightGreen,
          'bgColor': TerminalColors.bgGreen + TerminalColors.black,
        };
    }
  }

  static String _getIndustryIcon(String? industry) {
    switch (industry?.toLowerCase()) {
      case 'fintech':
        return TerminalIcons.fintech;
      case 'healthcare':
        return TerminalIcons.healthcare;
      case 'ecommerce':
        return TerminalIcons.ecommerce;
      case 'gaming':
        return TerminalIcons.gaming;
      case 'enterprise':
        return TerminalIcons.enterprise;
      default:
        return '🏭';
    }
  }

  static int _calculateQualityScore(int errors, int warnings, int infos) {
    var score = 100;
    score -= errors * 10; // -10 points per error
    score -= warnings * 5; // -5 points per warning
    score -= infos * 1; // -1 point per info
    return math.max(0, score);
  }

  static void _showQualityScore(int score) {
    String color;
    String icon;
    String grade;

    if (score >= 90) {
      color = TerminalColors.brightGreen;
      icon = '🏆';
      grade = 'A+';
    } else if (score >= 80) {
      color = TerminalColors.green;
      icon = '✨';
      grade = 'A';
    } else if (score >= 70) {
      color = TerminalColors.brightYellow;
      icon = '👍';
      grade = 'B';
    } else if (score >= 60) {
      color = TerminalColors.yellow;
      icon = '⚠️';
      grade = 'C';
    } else {
      color = TerminalColors.brightRed;
      icon = '🚨';
      grade = 'F';
    }

    PremiumTerminalUI.showBox(
        'Code Quality Score',
        [
          '$icon ${color}Score: $score/100 (Grade: $grade)${TerminalColors.reset}'
        ],
        color: color);
  }
}

// ============================================================================
// REAL-TIME MONITORING DISPLAY
// ============================================================================

class RealtimeMonitor {
  static void showFileWatcher() {
    PremiumTerminalUI.showHeader(
        '👁️  File Watcher', 'Monitoring for changes...');

    print(
        '${TerminalColors.brightGreen}✓ Watching files:${TerminalColors.reset}');
    print('  📁 lib/**/*.dart');
    print('  📁 test/**/*.dart');
    print('  📁 integration_test/**/*.dart');
    print('');

    // Simulate file changes
    final files = [
      'lib/main.dart',
      'lib/models/user.dart',
      'lib/services/api.dart'
    ];

    for (var i = 0; i < 3; i++) {
      final file = files[i % files.length];
      print(
          '${TerminalColors.brightCyan}📝 File changed: $file${TerminalColors.reset}');
      print(
          '${TerminalColors.dim}   Running analysis...${TerminalColors.reset}');

      // Show progress
      for (var j = 0; j <= 10; j++) {
        PremiumTerminalUI.showProgress('Analyzing', j / 10,
            color: TerminalColors.brightBlue);
        sleep(const Duration(milliseconds: 100));
      }

      print('');
      print(
          '${TerminalColors.brightGreen}✅ Analysis complete - No issues found${TerminalColors.reset}');
      print('');

      if (i < 2) sleep(const Duration(seconds: 2));
    }
  }

  static void showLiveAnalysis() {
    final issues = [
      const CodeIssue(
        file: 'lib/models/transaction.dart',
        line: 45,
        column: 12,
        rule: 'no_double_for_money',
        message:
            'Use BigInt or Decimal for monetary amounts, never double/float',
        severity: IssueSeverity.error,
        suggestion: 'Replace double amount with BigInt amountInCents',
        industry: 'fintech',
      ),
      const CodeIssue(
        file: 'lib/services/patient_service.dart',
        line: 23,
        column: 8,
        rule: 'pii_encryption_required',
        message: 'Patient PII must be encrypted before storage',
        severity: IssueSeverity.error,
        suggestion: 'Use encryption service to encrypt patient data',
        industry: 'healthcare',
      ),
      const CodeIssue(
        file: 'lib/widgets/cart_item.dart',
        line: 67,
        column: 20,
        rule: 'performance_optimization',
        message: 'Consider using const constructor for better performance',
        severity: IssueSeverity.suggestion,
        suggestion: 'Add const keyword to constructor',
        industry: 'ecommerce',
      ),
    ];

    for (final issue in issues) {
      PremiumIssueDisplay.showIssue(issue);
      sleep(const Duration(seconds: 1));
    }

    PremiumIssueDisplay.showSummary(issues);
  }
}

// ============================================================================
// INTERACTIVE FEATURES DEMO
// ============================================================================

class InteractiveDemo {
  static void showIndustrySelection() {
    PremiumTerminalUI.showHeader(
        '🏭 Industry Selection', 'Choose your development domain');

    final industries = [
      {
        'name': 'Fintech/Banking',
        'icon': TerminalIcons.fintech,
        'desc': 'Financial services with security focus'
      },
      {
        'name': 'Healthcare',
        'icon': TerminalIcons.healthcare,
        'desc': 'HIPAA compliance and privacy'
      },
      {
        'name': 'E-commerce',
        'icon': TerminalIcons.ecommerce,
        'desc': 'Scalability and performance'
      },
      {
        'name': 'Gaming',
        'icon': TerminalIcons.gaming,
        'desc': 'Real-time and performance critical'
      },
      {
        'name': 'Enterprise',
        'icon': TerminalIcons.enterprise,
        'desc': 'Compliance and audit requirements'
      },
    ];

    for (var i = 0; i < industries.length; i++) {
      final industry = industries[i];
      print(
          '${TerminalColors.brightBlue}${i + 1}.${TerminalColors.reset} ${industry['icon']} ${TerminalColors.bold}${industry['name']}${TerminalColors.reset}');
      print(
          '   ${TerminalColors.dim}${industry['desc']}${TerminalColors.reset}');
      print('');
    }

    print(
        '${TerminalColors.brightGreen}Select your industry (1-5):${TerminalColors.reset}');
  }

  static void showConfigurationPreview() {
    PremiumTerminalUI.showHeader(
        '⚙️  Configuration Preview', 'Industry-specific rules loaded');

    final configLines = [
      '${TerminalColors.brightGreen}✓${TerminalColors.reset} Industry: ${TerminalColors.brightCyan}Fintech${TerminalColors.reset}',
      '${TerminalColors.brightGreen}✓${TerminalColors.reset} Rules: ${TerminalColors.brightYellow}8 mandatory, 12 recommended${TerminalColors.reset}',
      '${TerminalColors.brightGreen}✓${TerminalColors.reset} UI Theme: ${TerminalColors.brightMagenta}Premium Dark${TerminalColors.reset}',
      '${TerminalColors.brightGreen}✓${TerminalColors.reset} Notifications: ${TerminalColors.brightBlue}Real-time enabled${TerminalColors.reset}',
    ];

    PremiumTerminalUI.showBox('Configuration Status', configLines);
  }
}

// ============================================================================
// MAIN DEMO APPLICATION
// ============================================================================

void main() async {
  // Initialize terminal UI
  PremiumTerminalUI.init();
  PremiumTerminalUI.clearScreen();
  PremiumTerminalUI.hideCursor();

  try {
    // Welcome screen
    PremiumTerminalUI.showHeader('🛡️ Flutter Code Guard Premium UI Demo',
        'Industry-Standard Code Analysis with Beautiful Terminal Experience');

    sleep(const Duration(seconds: 2));

    // Industry selection demo
    InteractiveDemo.showIndustrySelection();
    sleep(const Duration(seconds: 3));

    // Configuration preview
    InteractiveDemo.showConfigurationPreview();
    sleep(const Duration(seconds: 2));

    // Live analysis demo
    PremiumTerminalUI.clearScreen();
    RealtimeMonitor.showLiveAnalysis();

    sleep(const Duration(seconds: 2));

    // File watcher demo
    PremiumTerminalUI.clearScreen();
    RealtimeMonitor.showFileWatcher();

    // Final message
    PremiumTerminalUI.clearScreen();
    PremiumTerminalUI.showHeader('🎉 Demo Complete!',
        'Flutter Code Guard - Premium Developer Experience');

    PremiumTerminalUI.showBox(
        'Features Demonstrated',
        [
          '✨ Beautiful terminal UI with colors and animations',
          '🏭 Industry-specific coding standards',
          '📊 Real-time code quality monitoring',
          '🔧 Interactive error fixing suggestions',
          '📈 Quality scoring and metrics',
          '👁️  Live file watching and analysis',
          '🎨 Premium themes and customization',
        ],
        color: TerminalColors.brightGreen);

    print(
        '\n${TerminalColors.brightCyan}Ready to guard your code! 🛡️${TerminalColors.reset}\n');
  } finally {
    PremiumTerminalUI.showCursor();
  }
}

/// Utility function for demo delays
void sleep(Duration duration) {
  final stopwatch = Stopwatch()..start();
  while (stopwatch.elapsed < duration) {
    // Busy wait for demo purposes
  }
}
