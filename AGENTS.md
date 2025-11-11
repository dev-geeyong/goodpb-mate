# Repository Guidelines

## Project Structure & Module Organization
`lib/main.dart` boots the Flutter experience and delegates features into `lib/src`, which is split into `models/` (domain objects), `services/` (API and calculation helpers), `widgets/` (reusable UI), and `screens/` (top-level flows such as the securities selector). Assets that need bundling belong in `assets/` and must be whitelisted in `pubspec.yaml`. Platform-specific runners live in `android/`, `ios/`, `macos/`, `linux/`, `windows/`, and `web/`; avoid touching them unless you are wiring native plugins. Tests mirror the library layout under `test/` so every Dart file has an obvious test counterpart.

## Build, Test, and Development Commands
- `flutter pub get` — sync Dart dependencies after editing `pubspec.yaml`.
- `flutter analyze` — enforce the rules defined in `analysis_options.yaml`.
- `flutter test --coverage` — run unit and widget suites; produces `coverage/lcov.info`.
- `flutter run -d chrome` (web) / `flutter run -d ios` (simulator) — launch the app with hot reload.
- `flutter build apk --release` and `flutter build ios --release` — create store-ready bundles.

## Coding Style & Naming Conventions
Use Dart’s two-space indentation, keep lines ≤ 100 chars, and prefer `final`/`const` for immutable state. Classes, enums, and widgets use PascalCase (`BondListScreen`), while files and directories stay snake_case (`bond_list_screen.dart`). Format changes with `dart format lib test` before committing, and address all analyzer warnings so CI stays green.

## Testing Guidelines
Co-locate tests with their feature area (`lib/src/widgets/foo.dart` → `test/widgets/foo_test.dart`). Name files `*_test.dart`, use descriptive `group` labels, and rely on `pumpWidget`/`pumpAndSettle` helpers for UI flows. Maintain coverage parity for any new business rule, and regenerate `coverage/lcov.info` when updating snapshots or adding golden tests.

## Commit & Pull Request Guidelines
History shows concise, imperative messages (`Add bond list screen`). Follow that style, keep commits scoped, and reference ticket IDs in the footer when relevant. Pull requests must summarize intent, list verification steps (`flutter analyze`, `flutter test --coverage`), and attach screenshots for UI changes. Request at least one reviewer, respond to feedback with follow-up commits, and avoid force-pushing once reviews begin.
