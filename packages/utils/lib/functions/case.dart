String properCase(String s) => s[0].toUpperCase() + s.substring(1);

String properCaseWithSpace(String s) =>
    s[0].toUpperCase() +
    s.substring(1).replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}');
