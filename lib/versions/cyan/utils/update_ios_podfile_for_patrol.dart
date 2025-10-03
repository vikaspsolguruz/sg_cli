part of '../cyan.dart';

void _updateIOSPodfileForPatrol() {
  final podfile = File('ios/Podfile');
  if (!podfile.existsSync()) {
    print('${ConsoleSymbols.warning}  Podfile not found, skipping Podfile update');
    return;
  }
  
  print('${ConsoleSymbols.loading}  Updating Podfile for Patrol...');
  
  final content = podfile.readAsStringSync();
  
  // Check if RunnerUITests target already exists
  if (content.contains("target 'RunnerUITests'")) {
    print('${ConsoleSymbols.info}  Podfile already contains RunnerUITests target');
    return;
  }
  
  // Create backup
  final backupFile = File('${podfile.path}.backup');
  backupFile.writeAsStringSync(content);
  
  try {
    final updatedContent = _insertRunnerUITestsTarget(content);
    
    if (updatedContent == content) {
      print('${ConsoleSymbols.warning}  Could not find suitable location to insert RunnerUITests target');
      print('${ConsoleSymbols.info}  Please add it manually inside the Runner target in Podfile');
      return;
    }
    
    podfile.writeAsStringSync(updatedContent);
    print('${ConsoleSymbols.success}  Updated Podfile with RunnerUITests target');
    
    // Clean up backup if successful
    if (backupFile.existsSync()) {
      backupFile.deleteSync();
    }
  } catch (e) {
    print('${ConsoleSymbols.error}  Failed to update Podfile: $e');
    print('${ConsoleSymbols.info}  Restoring from backup...');
    
    // Restore from backup
    if (backupFile.existsSync()) {
      podfile.writeAsStringSync(backupFile.readAsStringSync());
      backupFile.deleteSync();
      print('${ConsoleSymbols.success}  Restored original Podfile');
    }
    
    print('${ConsoleSymbols.info}  Please add RunnerUITests target manually to Podfile');
  }
}

String _insertRunnerUITestsTarget(String content) {
  final lines = content.split('\n');
  
  // Strategy: Find the Runner target and its closing 'end'
  // Insert RunnerUITests target just before that closing 'end'
  
  int runnerTargetStart = -1;
  int runnerTargetEnd = -1;
  int indentLevel = 0;
  int targetIndentLevel = -1;
  
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trim();
    
    // Find Runner target start
    if (trimmed.startsWith("target 'Runner'") || trimmed.startsWith('target "Runner"')) {
      runnerTargetStart = i;
      targetIndentLevel = _getIndentLevel(line);
      indentLevel = 1;
      continue;
    }
    
    // If we're inside Runner target, track brace depth
    if (runnerTargetStart != -1 && indentLevel > 0) {
      // Count 'do' blocks or nested targets
      if (trimmed.contains('do') && trimmed.contains('|')) {
        indentLevel++;
      }
      if (trimmed.startsWith('target ')) {
        indentLevel++;
      }
      
      // Check for 'end' keyword
      if (trimmed == 'end') {
        indentLevel--;
        if (indentLevel == 0) {
          runnerTargetEnd = i;
          break;
        }
      }
    }
  }
  
  if (runnerTargetStart == -1 || runnerTargetEnd == -1) {
    // Fallback: Try to find any 'end' that looks like it closes Runner target
    return _insertRunnerUITestsTargetFallback(content, lines);
  }
  
  // Get the indent of the Runner target
  final indent = _getIndent(lines[runnerTargetStart]);
  
  // Prepare RunnerUITests target with proper indentation
  final runnerUITestsTarget = [
    '',
    '${indent}  target \'RunnerUITests\' do',
    '${indent}    inherit! :complete',
    '${indent}  end',
  ];
  
  // Insert before the Runner's closing 'end'
  lines.insertAll(runnerTargetEnd, runnerUITestsTarget);
  
  return lines.join('\n');
}

String _insertRunnerUITestsTargetFallback(String content, List<String> lines) {
  // Fallback strategy: Look for the pattern more carefully
  // Find "target 'Runner'" and count blocks until we find its matching end
  
  int runnerIndex = -1;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains("target 'Runner'") || lines[i].contains('target "Runner"')) {
      runnerIndex = i;
      break;
    }
  }
  
  if (runnerIndex == -1) {
    return content; // Can't find Runner target
  }
  
  // Count all 'do' and 'end' keywords to find matching end
  int blockCount = 0;
  int endIndex = -1;
  
  for (int i = runnerIndex; i < lines.length; i++) {
    final line = lines[i].trim();
    
    // Increment for target declarations or do blocks
    if (i == runnerIndex || line.startsWith('target ') || 
        (line.contains(' do') && (line.contains('|') || line.endsWith('do')))) {
      blockCount++;
    }
    
    // Decrement for end keywords
    if (line == 'end') {
      blockCount--;
      if (blockCount == 0) {
        endIndex = i;
        break;
      }
    }
  }
  
  if (endIndex == -1) {
    return content; // Couldn't find matching end
  }
  
  // Get indent from Runner line
  final indent = _getIndent(lines[runnerIndex]);
  
  // Insert RunnerUITests target
  final runnerUITestsTarget = [
    '',
    '${indent}  target \'RunnerUITests\' do',
    '${indent}    inherit! :complete',
    '${indent}  end',
  ];
  
  lines.insertAll(endIndex, runnerUITestsTarget);
  
  return lines.join('\n');
}

int _getIndentLevel(String line) {
  int count = 0;
  for (int i = 0; i < line.length; i++) {
    if (line[i] == ' ') {
      count++;
    } else if (line[i] == '\t') {
      count += 2; // Count tab as 2 spaces
    } else {
      break;
    }
  }
  return count;
}

String _getIndent(String line) {
  final match = RegExp(r'^(\s*)').firstMatch(line);
  return match?.group(1) ?? '';
}

void _printIOSManualSteps() {
  print('');
  print('${ConsoleSymbols.info}  ========================================');
  print('${ConsoleSymbols.info}  iOS MANUAL STEPS REQUIRED:');
  print('${ConsoleSymbols.info}  ========================================');
  print('');
  print('${ConsoleSymbols.info}  1. Open ios/Runner.xcworkspace in Xcode');
  print('${ConsoleSymbols.info}  2. File > New > Target... > UI Testing Bundle');
  print('${ConsoleSymbols.info}  3. Product Name: RunnerUITests');
  print('${ConsoleSymbols.info}  4. Target to be Tested: Runner');
  print('${ConsoleSymbols.info}  5. Language: Objective-C');
  print('${ConsoleSymbols.info}  6. Delete RunnerUITestsLaunchTests.m (Move to Trash)');
  print('${ConsoleSymbols.info}  7. Set iOS Deployment Target same as Runner (11.0+)');
  print('${ConsoleSymbols.info}  8. Add Build Phases: xcode_backend build & embed_and_thin');
  print('${ConsoleSymbols.info}  9. Disable "Parallel execution" in scheme settings');
  print('${ConsoleSymbols.info}  10. Set "User Script Sandboxing" to "No"');
  print('');
  print('${ConsoleSymbols.info}  For detailed instructions, see:');
  print('${ConsoleSymbols.info}  https://patrol.leancode.co/getting-started');
  print('${ConsoleSymbols.info}  ========================================');
  print('');
}
