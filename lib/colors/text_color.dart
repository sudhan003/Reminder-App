extension StringColors on String {
// Text colors
  String get black => '\x1B [30m$this\x1B [0m';

  String get red => '\x1B [31m$this\x1B [0m';

  String get green => '\x1B [32m$this\x1B [0m';

  String get yellow => '\x1B [33m$this \x1B [0m';

  String get blue => '\x1B[34m$this\x1B [0m';

  String get magenta => '\x1B [35m$this\x1B [0m';

  String get cyan => '\x1B[36m$this\x1B [0m';

  String get white => '\x1B[37m$this\x1B[0m';

// Background colors
  String get bgBlack => '\x1B [40m$this\x1B [0m';

  String get bgRed => '\x1B [41m$this\x1B [0m';

  String get bgGreen => '\x1B [42m$this\x1B [0m';

  String get bgYellow => '\x1B [43m$this\x1B [0m';

  String get bgBlue => '\x1B[44m$this\x1B [0m';

  String get bgMagenta => '\x1B [45m$this\x1B[0m';

  String get bgCyan => '\x1B [46m$this\x1B[0m';

  String get bgWhite => '\x1B[47m$this\x1B [0m';

// Text styles
  String get bold => '\x1B[1m$this\x1B [0m';

  String get italic => '\x1B[3m$this\x1B[0m';

  String get underline => '\x1B[4m$this\x1B [0m';

  String get blink => '\x1B[5m$this\x1B[0m';

// Custom RGB (for terminals that support it)
  String rgb(int r, int g, int b) => '\x1B[38;2; $r; $g;${b}m$this\x1B[0m';

  String bgRgb(int r, int g, int b) => '\x1B[48;2; $r;$g;${b}m$this\x1B[0m';
}
