# SG CLI - Flutter Architecture Generator

A powerful CLI tool for generating scalable Flutter applications with BLoC pattern, clean architecture, and production-ready features.

[![Version](https://img.shields.io/badge/version-cyan-blue)](https://github.com/vikaspsolguruz/sg_cli)
[![Flutter](https://img.shields.io/badge/Flutter-3.5.0+-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Commands](#-commands)
- [Architecture](#-architecture)
- [Examples](#-examples)
- [Troubleshooting](#-troubleshooting)
- [About Us](#-about-us)

---

## Features

### Complete Architecture Setup
- **Cyan Architecture** - Production-ready folder structure
- **BLoC Pattern** - State management with bloc pattern
- **Clean Architecture** - Separation of concerns (presentation, core, data)
- **Route Management** - Automatic route generation and management

### Code Generation
- **Screens** - Full-featured screens with BLoC
- **Sub-Screens** - Nested screens with parent-child routing
- **Bottom Sheets** - Reusable bottom sheet components
- **Dialogs** - Custom dialog components
- **Events** - BLoC events with proper structure

### Production Features
- **Product Flavors** - Dev, Stage, Prod configurations (Android + iOS)
- **Deep Linking** - Per-flavor deep link configuration
- **Firebase Integration** - Automated Firebase setup with FlutterFire CLI
- **Multi-platform** - Android, iOS, Web ready

### Developer Experience
- **Automated Dependency Management** - Auto-runs `flutter pub get`
- **Smart Path Resolution** - Works with local and git activation
- **Consistent Naming** - Enforces snake_case conventions
- **Auto-imports** - Manages route imports automatically

---

## Installation

### Option 1: Git Activation (Recommended)

```bash
dart pub global activate --source git https://github.com/vikaspsolguruz/sg_cli.git
```

### Option 2: Local Activation (For Development)

```bash
# Clone the repository
git clone https://github.com/vikaspsolguruz/sg_cli.git
cd sg_cli

# Activate locally
dart pub global activate --source path .
```

### Verify Installation

```bash
sg help
# or
sg --help
# or
sg -h
```

---

## Quick Start

### 1. Initialize Cyan Architecture

```bash
cd your-flutter-project
sg init
```

This will:
- Generate complete folder structure
- Create core utilities and theme files
- Set up routing system
- Install dependencies
- Create configuration files

### 2. Setup Product Flavors

```bash
sg setup_flavors
```

Creates dev, stage, and prod flavors for Android and iOS.

### 3. Create Your First Screen

```bash
sg create screen login
```

Generates:
```
lib/presentation/screens/login/
├── logic/
│   ├── login_bloc.dart
│   ├── login_event.dart
│   └── login_state.dart
└── view/
    ├── login_page.dart
    └── widgets/
```

---

## Commands

### Project Setup Commands

#### `sg init`
Initialize Cyan architecture in your Flutter project.

```bash
sg init
```

**What it does:**
- Generates complete folder structure (presentation, core, data)
- Creates app foundation (routing, state management, theme)
- Sets up BLoC pattern infrastructure
- Installs required dependencies
- Creates configuration files

---

#### `sg setup_flavors`
Setup product flavors (dev, stage, prod) for Android and iOS.

```bash
sg setup_flavors
```

**What it does:**
- Creates flavor-specific configurations
- Generates Android build types
- Configures iOS schemes
- Sets up Android Studio run configurations

---

#### `sg setup_deeplink`
Configure deep-linking per flavor with native + Flutter integration.

```bash
sg setup_deeplink
```

**Interactive prompts:**
- Dev domain (e.g., `dev-app.com`)
- Stage domain (e.g., `stage.app.com`)
- Prod domain (e.g., `app.com`)

**What it does:**
- Creates Android manifests per flavor
- Generates iOS entitlements per flavor
- Creates `deep_link_manager.dart` for Flutter
- Injects deep link initialization into `app.dart`
- Adds `app_links` dependency

---

#### `sg setup_firebase`
Generate Firebase placeholder configs per flavor.

```bash
sg setup_firebase
```

**What it does:**
- Creates placeholder `google-services.json` (Android)
- Creates placeholder `GoogleService-Info.plist` (iOS)
- Generates `firebase_options.dart` template
- Adds Firebase initialization code

---

#### `sg setup_firebase_auto`
Automated Firebase setup using FlutterFire CLI (real configs).

```bash
sg setup_firebase_auto
```

**Prerequisites:**
- Firebase CLI installed
- FlutterFire CLI installed
- Firebase project created

**What it does:**
- Downloads real Firebase configs per flavor
- Runs FlutterFire configure automatically
- Adds `firebase_core` dependency
- Injects Firebase initialization into `app.dart`

---

### Code Generation Commands

#### `sg create screen <name>`
Create a new screen with BLoC pattern.

```bash
sg create screen profile
```

**Generates:**
```
lib/presentation/screens/profile/
├── logic/
│   ├── profile_bloc.dart       # BLoC with BaseBloc
│   ├── profile_event.dart      # Events
│   └── profile_state.dart      # States
└── view/
    ├── profile_page.dart       # Main UI
    └── widgets/                # Screen-specific widgets
```

**Auto-updates:**
- `app/app_routes/screen_routes.dart` - Adds route
- `app/app_routes/_route_names.dart` - Adds route name

---

#### `sg create sub_screen <name> in <parent>`
Create a sub-screen under a parent screen.

```bash
sg create sub_screen edit_profile in profile
```

**Generates:**
```
lib/presentation/screens/profile/edit_profile/
├── logic/
│   ├── edit_profile_bloc.dart
│   ├── edit_profile_event.dart
│   └── edit_profile_state.dart
└── view/
    ├── edit_profile_page.dart
    └── widgets/
```

**Route:** `/profile/edit_profile`

---

#### `sg create bs <name>`
Create a bottom sheet component.

```bash
sg create bs select_country
```

**Generates:**
```
lib/presentation/bottom_sheets/select_country/
├── logic/
│   ├── select_country_bloc.dart
│   ├── select_country_event.dart
│   └── select_country_state.dart
└── view/
    ├── select_country_bs.dart
    └── widgets/
```

**Auto-updates:**
- `app/app_routes/bottom_sheet_routes.dart`

---

#### `sg create dialog <name>`
Create a dialog component.

```bash
sg create dialog confirm_logout
```

**Generates:**
```
lib/presentation/dialogs/confirm_logout/
├── logic/
│   ├── confirm_logout_bloc.dart
│   ├── confirm_logout_event.dart
│   └── confirm_logout_state.dart
└── view/
    ├── confirm_logout_dialog.dart
    └── widgets/
```

**Auto-updates:**
- `app/app_routes/dialog_routes.dart`

---

#### `sg create event <name> in <page>`
Create a new BLoC event in an existing screen/bottom sheet/dialog.

```bash
sg create event submit_form in login
```

**Adds to:** `lib/presentation/screens/login/logic/login_event.dart`

```dart
class SubmitFormEvent extends LoginEvent {
  // TODO: Add event parameters
}
```

---

#### `sg help`
Show all available commands with examples.

```bash
sg help
# or
sg --help
# or
sg -h
```

---

## Architecture

### Folder Structure

```
lib/
├── app/
│   ├── app.dart                    # Main app widget
│   ├── app_routes/                 # Route definitions
│   │   ├── screen_routes.dart
│   │   ├── bottom_sheet_routes.dart
│   │   ├── dialog_routes.dart
│   │   └── _route_names.dart
│   ├── app_state.dart              # Global app state
│   └── navigation/                 # Navigation utilities
│
├── core/
│   ├── constants/                  # App-wide constants
│   ├── data/                       # Data models
│   ├── enums/                      # Enumerations
│   ├── network/                    # API client, interceptors
│   ├── theme/                      # Theme data, colors, text styles
│   └── utils/                      # Utilities (bloc, localization, etc.)
│       ├── bloc/                   # BaseBloc and helpers
│       ├── localization/           # i18n support
│       └── deep_link_manager.dart  # Deep link handling
│
├── data/
│   ├── global_vars.dart            # Global variables
│   └── repositories/               # Data repositories
│
└── presentation/
    ├── screens/                    # All screens
    │   └── [screen_name]/
    │       ├── logic/              # BLoC, Events, States
    │       └── view/               # UI and widgets
    ├── bottom_sheets/              # Bottom sheets
    └── dialogs/                    # Dialogs

assets/
└── images/                         # Image assets

android/
└── app/src/
    ├── dev/                        # Dev flavor configs
    ├── stage/                      # Stage flavor configs
    └── prod/                       # Prod flavor configs

ios/
└── Runner/
    ├── Runner-dev.entitlements     # Dev deep link config
    ├── Runner-stage.entitlements   # Stage deep link config
    └── Runner-prod.entitlements    # Prod deep link config
```

### BLoC Pattern

All screens, bottom sheets, and dialogs follow the BLoC pattern:

```dart
// Event
abstract class LoginEvent {}
class SubmitLoginEvent extends LoginEvent {}

// State
class LoginState {
  final bool isLoading;
  final String? error;
  LoginState({this.isLoading = false, this.error});
}

// BLoC
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<SubmitLoginEvent>(_onSubmitLogin);
  }

  Future<void> _onSubmitLogin(
    SubmitLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    // Handle event
  }
}
```

---

## Examples

### Complete Workflow Example

```bash
# 1. Initialize project
cd my_flutter_app
sg init

# 2. Setup flavors
sg setup_flavors

# 3. Setup deep linking
sg setup_deeplink
# Enter domains:
#   Dev: dev-myapp.com
#   Stage: stage-myapp.com
#   Prod: myapp.com

# 4. Setup Firebase (automated)
sg setup_firebase_auto

# 5. Create authentication flow
sg create screen login
sg create screen register
sg create screen forgot_password

# 6. Create profile with sub-screens
sg create screen profile
sg create sub_screen edit_profile in profile
sg create sub_screen settings in profile

# 7. Create reusable components
sg create bs select_language
sg create bs select_theme
sg create dialog confirm_action

# 8. Add events to screens
sg create event submit_login in login
sg create event validate_email in register
sg create event update_profile in edit_profile
```

### Using Generated Code

**Navigate to a screen:**
```dart
Go.toNamed(Routes.profile);

// With arguments (use RouteArguments class)
Go.toNamed(
  Routes.profile,
  arguments: {
    RouteArguments.userId: '123',
    RouteArguments.userName: 'John',
  },
);
```

**Show a bottom sheet:**
```dart
Go.openBottomSheet(Routes.selectLanguage);

// With custom options
Go.openBottomSheet(
  Routes.selectLanguage,
  arguments: {RouteArguments.currentLanguage: 'en'},
  enableDrag: true,
  showDragHandle: true,
  isDismissible: true,
);
```

**Show a dialog:**
```dart
Go.openDialog(Routes.confirmAction);

// With arguments and custom alignment
Go.openDialog(
  Routes.confirmAction,
  arguments: {
    RouteArguments.title: 'Confirm',
    RouteArguments.message: 'Are you sure?',
  },
  alignment: Alignment.center,
  isDismissible: true,
);
```

**Navigate back:**
```dart
Go.back();

// Back with result
Go.back(result: {RouteArguments.confirmed: true});
```

**Replace current screen:**
```dart
Go.replaceToNamed(Routes.newScreen);
```

**Clear stack and navigate:**
```dart
Go.replaceAllToNamed(Routes.login);
```

**Access route arguments in your screen:**
```dart
// In your screen/bottom sheet/dialog
final userId = AppState.currentRouteArguments[RouteArguments.userId];
final userName = AppState.currentRouteArguments[RouteArguments.userName];
```

---

## Troubleshooting

### Command not found

If `sg` command is not recognized:

```bash
# Add Dart pub global bin to PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"

# For permanent setup, add to ~/.zshrc or ~/.bashrc
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Git activation lib/ directory issue

If you encounter template errors with git activation:

**Solution:** Use local activation for `sg init`:
```bash
# Clone and activate locally
git clone https://github.com/vikaspsolguruz/sg_cli.git
cd sg_cli
dart pub global activate --source path .

# Run init
cd your-flutter-project
sg init
```

Other commands work fine with git activation.

### Deep link setup fails

**Error:** `PathNotFoundException: Cannot open file, path = 'templates/android_manifest.xml'`

**Solution:** This was a bug in older versions. Update to the latest version:
```bash
dart pub global activate --source git https://github.com/vikaspsolguruz/sg_cli.git
```

### Firebase setup fails

**Prerequisites for `setup_firebase_auto`:**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login
```

---

## Requirements

- **Flutter SDK:** >= 3.32.8
- **Dart SDK:** >= 3.8.1
- **Firebase CLI** (for setup_firebase_auto)
- **FlutterFire CLI** (for setup_firebase_auto)

---

## About Us

Engineering Quality Solutions by employing technologies with Passion and Love | Web and Mobile App Development Company in India and Canada.

## Links

<div align="left">

<a href="https://solguruz.com/" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/solguruz.svg" alt="Solguruz" style="margin-bottom: 5px;" />
</a>

<a href="https://www.facebook.com/SolGuruzHQ" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/facebook.svg" alt="Solguruz on Facebook" style="margin-bottom: 5px;" />
</a>

<a href="https://www.linkedin.com/company/solguruz/" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/linkedin.svg" alt="Solguruz on Linkedin" style="margin-bottom: 5px;" />
</a>

<a href="https://www.instagram.com/solguruz/" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/instagram.svg" alt="Solguruz on Instagram" style="margin-bottom: 5px;" />
</a>

<a href="https://twitter.com/SolGuruz" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/twitter.svg" alt="Solguruz on Twitter" style="margin-bottom: 5px;" />
</a>

<a href="https://www.behance.net/solguruz" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/behance.svg" alt="Solguruz on Behance" style="margin-bottom: 5px;" />
</a>

<a href="https://dribbble.com/SolGuruz" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/dribbble.svg" alt="Solguruz on Dribble" style="margin-bottom: 5px;" />
</a>

<a href="https://solguruz.com/hire-flutter-developers/" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/hire_flutter_developer.svg" alt="Hire Flutter Developers" style="margin-bottom: 5px;" />
</a>

<a href="https://solguruz.com/services/flutter-app-development" target="_blank">
    <img src="https://raw.githubusercontent.com/solguruz/multi_selection_filter/main/.github/explore_our_flutter_service.svg" alt="Flutter App Development" style="margin-bottom: 5px;" />
</a>

</div>

---

## License

```text
MIT License

Copyright (c) 2025 SolGuruz LLP

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Star Us!

If you find this CLI tool helpful, please give us a star on GitHub! 

**Repository:** [github.com/vikaspsolguruz/sg_cli](https://github.com/vikaspsolguruz/sg_cli)

---

**Made with by [SolGuruz](https://solguruz.com/)**