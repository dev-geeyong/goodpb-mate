# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application (goodpb_mate) using Flutter 3.35.3+ and Dart 3.9.2+. The project is a standard Flutter multi-platform application with support for Android, iOS, macOS, Windows, Linux, and Web.

## Essential Commands

### Dependency Management
- `flutter pub get` - Sync dependencies after editing pubspec.yaml
- `flutter pub upgrade --major-versions` - Update all dependencies to latest versions
- `flutter pub outdated` - Check for newer versions of dependencies

### Development
- `flutter run -d chrome` - Run on Chrome (web)
- `flutter run -d ios` - Run on iOS simulator
- `flutter run -d android` - Run on Android emulator
- `flutter run` - Run on default device with hot reload enabled

### Code Quality
- `flutter analyze` - Run static analysis using rules from analysis_options.yaml
- `dart format lib test` or `flutter format lib test` - Format code to Dart style (2-space indentation, 100 column limit)

### Testing
- `flutter test` - Run all unit and widget tests
- `flutter test --coverage` - Run tests and generate lcov coverage data in coverage/
- `flutter test test/path/to/specific_test.dart` - Run a single test file

### Building
- `flutter build apk --release` - Build Android release APK
- `flutter build ios --release` - Build iOS release (requires macOS and Xcode)
- `flutter build web --release` - Build web release
- `flutter build macos --release` - Build macOS release

## Project Structure

```
lib/
  main.dart          # App entry point, bootstraps MaterialApp
  src/               # Feature code and modules (as app grows)
test/                # Unit and widget tests, mirrors lib/ hierarchy
  widget_test.dart   # Example: lib/widgets/foo.dart → test/widgets/foo_test.dart
android/             # Android platform runner
ios/                 # iOS platform runner
macos/               # macOS platform runner
windows/             # Windows platform runner
linux/               # Linux platform runner
web/                 # Web platform runner
assets/              # Reusable assets (fonts, images, L10N files)
pubspec.yaml         # Dependencies and asset registration
analysis_options.yaml # Dart linter configuration (flutter_lints)
```

## Coding Conventions

### Naming
- **Files and directories**: snake_case (e.g., `account_summary_card.dart`)
- **Classes and widgets**: PascalCase (e.g., `AccountSummaryCard`)
- **Variables and functions**: camelCase
- Prefer `final` or `const` for immutable values

### Style
- Use 2-space indentation (Dart default)
- Keep lines under 100 columns
- Extract widgets for readability rather than deeply nested build methods
- Run `dart format lib test` before committing

### Linting
- Project uses `package:flutter_lints/flutter.yaml` as baseline
- Run `flutter analyze` to catch issues before committing
- Address all analyzer warnings and errors before pushing

## Testing Requirements

- Every new widget or business logic feature requires a matching `*_test.dart` file
- Tests should mirror the lib/ directory structure
- Use descriptive `group` and `test` names (e.g., `group('LoginForm', () { ... })`)
- Use `pumpWidget` and `pumpAndSettle` for widget testing flows
- Critical UI paths should include golden tests or integration tests when feasible
- Run `flutter test --coverage` locally to ensure coverage doesn't drop

## Native Platform Modifications

- Platform runners (android/, ios/, macos/, windows/, linux/, web/) should only be modified when adding native integrations or platform-specific features
- Most development happens in lib/ using Flutter's cross-platform APIs

## Asset Management

- Place assets (fonts, images, localization files) in an assets/ directory
- Register all assets in pubspec.yaml under the `flutter:` section
- Example:
  ```yaml
  flutter:
    assets:
      - assets/images/
      - assets/fonts/
  ```

## Commit Guidelines

- Use small, imperative, scoped commits (e.g., "Add onboarding flow skeleton")
- Reference issue/ticket numbers in commit footer when applicable
- Ensure `flutter analyze` and `flutter test` pass before committing
- Pull requests should include:
  - Description of the change
  - Test evidence (analyzer and test results)
  - Screenshots or recordings for UI changes
