part of '../../max.dart';

void _showHelp() {
  print('');
  print('╔════════════════════════════════════════════════════════════════════════════════╗');
  print('║                              🔥 SG CLI - Max Version 🔥                        ║');
  print('╚════════════════════════════════════════════════════════════════════════════════╝');
  print('');
  print('${ConsoleSymbols.books}Available Commands:');
  print('');
  print('${ConsoleSymbols.rocket}sg init                              Initialize max architecture in your project');
  print(' 🎨  sg setup_flavors                     Setup dev/stage/prod flavors (Android/iOS)');
  print(' 🔗  sg setup_deeplink                    Configure deep-linking per flavor');
  print(' 🔥  sg setup_firebase_manual             Generate Firebase configs per flavor');
  print(' 🔥  sg setup_firebase                    Automated Firebase setup with real configs');
  print('${ConsoleSymbols.mobile}sg create screen <name>              Create a new screen with BLoC pattern');
  print('${ConsoleSymbols.document}sg create sub_screen <name> in <parent>  Create a sub-screen under parent screen');
  print('${ConsoleSymbols.clipboard}sg create bs <name>                  Create a new bottom sheet');
  print('${ConsoleSymbols.dialog}sg create dialog <name>              Create a new dialog');
  print(' ⚡  sg create event <name> in <page>     Create a new BLoC event in specific page');
  print('${ConsoleSymbols.question}sg help                              Show this help message');
  print('');
  print('${ConsoleSymbols.bulb}Examples:');
  print('');
  print('    sg init                               # Setup max architecture');
  print('    sg setup_flavors                      # Add dev/stage/prod flavors');
  print('    sg setup_deeplink                     # Configure deep-linking per flavor');
  print('    sg setup_firebase_manual              # Add Firebase placeholder configs');
  print('    sg setup_firebase                     # Automated Firebase setup with FlutterFire CLI');
  print('    sg create screen login                # Create login screen');
  print('    sg create sub_screen profile in home  # Create profile sub-screen in home');
  print('    sg create bs select_country           # Create select_country bottom sheet');
  print('    sg create dialog confirm_logout       # Create confirm_logout dialog');
  print('    sg create event submit_form in login  # Create submit_form event in login page');
  print('');
  print('${ConsoleSymbols.document}Need more help? Check: https://github.com/vikaspsolguruz/sg_cli');
  print('');
}
