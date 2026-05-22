import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (final file in files) {
    if (file.path.contains('app_theme.dart')) continue; // Skip app_theme.dart for now
    var content = file.readAsStringSync();
    content = content.replaceAll('', '');
    file.writeAsStringSync(content);
  }
  print('Done removing from files');
}
