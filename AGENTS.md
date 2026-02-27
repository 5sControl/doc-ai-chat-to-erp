# Summify

Cross-platform Flutter mobile AI summarizer app (iOS, Android, Web).

## Cursor Cloud specific instructions

### Tech Stack

- **Language:** Dart (SDK >=3.7.0 <4.0.0)
- **Framework:** Flutter (installed at `/opt/flutter`)
- **State management:** flutter_bloc / HydratedBloc
- **Auth:** Firebase Auth (email, Google, Apple sign-in)

### Running the app

Flutter is installed at `/opt/flutter` and added to `PATH` via `~/.bashrc`. Standard commands:

- **Install deps:** `flutter pub get`
- **Lint:** `flutter analyze`
- **Build web:** `flutter build web`
- **Run web dev server:** `flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0`

The only viable target in the cloud VM is **web** (no iOS/Android emulators available). Use `flutter run -d web-server` to serve the app, then open Chrome at `http://localhost:8080`.

### Known issues

- **Firebase web runtime error:** The app shows a red error screen on web with `TypeError: Instance of 'FirebaseException': type 'FirebaseException' is not a subtype of type 'JavaScriptObject'`. This is because `firebase_core: ^3.13.0` / `firebase_core_web: 2.22.0` use the deprecated `dart:js` interop which is incompatible with Dart 3.11+. The Firebase packages need to be upgraded to v4+ to fix this. The app compiles, builds, and the Flutter framework renders — the error occurs at Firebase initialization time.
- **No automated tests:** The repository has no `*_test.dart` files. Testing is limited to `flutter analyze` for static analysis.
- The app has a `kIsFreeApp = true` flag that bypasses RevenueCat subscriptions, simplifying local development.

### External services

All AI features (summarization, Q&A, translation, quizzes) depend on the remote backend at `employees-training.com`. There is no local backend or database in this repository.
