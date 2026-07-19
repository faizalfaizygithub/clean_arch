// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:io';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  final currentDir = Directory.current.path;

  final pubspecFile = File(path.join(currentDir, 'pubspec.yaml'));
  if (!await pubspecFile.exists()) {
    print(
      '❌ Error: pubspec.yaml not found. Please run this script from your Flutter project root directory.',
    );
    exit(1);
  }

  final assetGenerator = AssetGenerator(currentDir);
  await assetGenerator.generate();
}

class AssetGenerator {
  final String projectRoot;
  late final String assetsDir;
  late final String outputFile;

  AssetGenerator(this.projectRoot) {
    assetsDir = path.join(projectRoot, 'assets');
    outputFile =
        path.join(projectRoot, 'lib', 'core', 'constants', 'assets.dart');
  }

  Future<void> generate() async {
    print("Generating Asset Folder ⚙️");

    final assetDirs = await _getAssetDirectories();
    final StringBuffer buffer = StringBuffer();

    buffer.writeln("// Generated file. Do not edit.");

    buffer.writeln("\nclass Assets {");

    for (var dir in assetDirs) {
      final className = _formatClassName(dir);
      buffer.writeln("  static final ${dir.toLowerCase()} = _$className._();");
    }

    buffer.writeln("}\n");
    for (var dir in assetDirs) {
      await _generateAssetClass(dir, buffer);
    }

    await _saveToFile(buffer.toString());
    print(
      '✅ Assets file generated successfully at ${path.relative(outputFile, from: projectRoot)}',
    );
  }

  Future<List<String>> _getAssetDirectories() async {
    final dir = Directory(assetsDir);
    if (!await dir.exists()) {
      print(
        '❌ Error: Assets directory not found at ${path.relative(assetsDir, from: projectRoot)}',
      );
      print(
        'Please create an assets directory in your project root and organize your assets into subdirectories.',
      );
      exit(1);
    }

    final List<String> assetDirs = [];
    await for (var entity in dir.list()) {
      if (entity is Directory) {
        if (path.basename(entity.path) == "fonts") {
          print("fonts directory found");
          continue;
        }

        assetDirs.add(path.basename(entity.path));
      }
    }

    if (assetDirs.isEmpty) {
      print('⚠  Warning: No subdirectories found in assets folder.');
      print(
        'Create subdirectories like images/, svg/, etc. to organize your assets.',
      );
    }

    return assetDirs;
  }

  Future<void> _generateAssetClass(String dirName, StringBuffer buffer) async {
    final className = _formatClassName(dirName);
    final dir = Directory(path.join(assetsDir, dirName));
    final assets = await _getAssetFiles(dir);

    buffer.writeln("class _$className {");
    buffer.writeln("  _$className._();");
    buffer.writeln();

    for (var asset in assets) {
      final constName = _formatConstName(asset);
      final assetPath = 'assets/$dirName/$asset';
      buffer.writeln('  final String $constName = \'$assetPath\';');
    }

    buffer.writeln("}\n");
  }

  Future<List<String>> _getAssetFiles(Directory dir) async {
    final List<String> files = [];
    await for (var entity in dir.list(recursive: true)) {
      if (entity is File) {
        final filename = path.basename(entity.path);
        if (!filename.startsWith('.')) {
          files.add(filename);
        }
      }
    }
    return files;
  }

  String _formatClassName(String name) {
    return '${name[0].toUpperCase()}${name.substring(1)}Assets';
  }

  String _formatConstName(String filename) {
    final name = filename.split('.').first;
    final words = name.split(RegExp(r'[_\- ]'));

    return words.map((word) {
      if (words.indexOf(word) == 0) {
        return word.toLowerCase();
      }

      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join();
  }

  Future<void> _saveToFile(String content) async {
    final file = File(outputFile);
    await file.create(recursive: true);
    await file.writeAsString(content);
    print('📝 Generated assets class with:');
    print(
      '   - ${path.relative(assetsDir, from: projectRoot)} directory scanned',
    );
    print('   - File saved to ${path.relative(outputFile, from: projectRoot)}');
  }
}
