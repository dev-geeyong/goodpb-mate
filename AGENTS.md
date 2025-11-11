# Repository Guidelines

## Project Structure & Module Organization
The Flutter app lives in `lib/`, with `lib/main.dart` bootstrapping widgets and feature code organized under `lib/src` as the app grows. Platform runners are kept in `android/`, `ios/`, `macos/`, `windows/`, `linux/`, and `web/`; update them only when modifying native integrations. Reusable assets (fonts, images, L10N files) should be placed in an `assets/` subtree and registered inside `pubspec.yaml`. Unit and widget tests reside in `test/`, mirroring the `lib/` hierarchy (e.g., `lib/widgets/foo.dart` → `test/widgets/foo_test.dart`).

## Build, Test, and Development Commands
- `flutter pub get`: syncs dependencies; run after editing `pubspec.yaml`.
- `flutter analyze`: enforces Dart lints from `analysis_options.yaml`.
- `flutter test --coverage`: runs all unit/widget tests and produces lcov data in `coverage/`.
- `flutter run -d chrome` or `flutter run -d ios`: hot-reloads the app on the chosen device/emulator.
- `flutter build apk --release`: produces Android release artifacts; mirror with `flutter build ios --release` when needed.

## Coding Style & Naming Conventions
Use Dart's default 2-space indentation and keep lines under 100 columns. Prefer `final`/`const` for immutable values, extract widgets for readability, and name classes/widgets using PascalCase (`AccountSummaryCard`). Files and directories use snake_case (`account_summary_card.dart`). Before committing, format with `dart format lib test` (or `flutter format`) and fix issues flagged by `flutter analyze`.

## Testing Guidelines
Every new widget or business rule needs a matching `*_test.dart`. Favor descriptive `group` and `test` names (`group('LoginForm', ...)`) and use `pumpWidget`/`pumpAndSettle` helpers for UI flows. Critical logic should include golden tests or integration coverage when feasible. Keep coverage steady by ensuring new code paths have assertions; run `flutter test --coverage` locally before pushing.

## Commit & Pull Request Guidelines
Commits should be small, imperative, and scoped (e.g., `Add onboarding flow skeleton`). Reference tickets in the footer when available. Pull requests must describe the change, outline test evidence (`flutter analyze`, `flutter test`), and attach screenshots or screen recordings for UI updates. Request at least one reviewer, and respond to feedback with follow-up commits rather than force-pushes to preserve context.
