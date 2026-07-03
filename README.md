# Grade AI

Cross-platform (**iOS / Android / Windows**) **exam-grading assistant for teachers**.
Scan handwritten exam papers, upload model answer keys, and grade them against
curriculum rubrics using the **Higgs Field AI** backend.

- **UI:** Flutter (Material 3) — "Aurora Academia" theme, dark by default
- **State / DI:** Riverpod 2.0
- **Architecture:** Clean Architecture — `presentation / application / domain / data`
- **Backend for auth/data/files:** Firebase (Auth, Firestore, Storage)
- **AI grading:** **Higgs Field AI** — your own REST backend on a private server,
  called over Dio (Bearer auth, exponential-backoff retry, offline queue).
  Pluggable behind the `GradingService` interface (`HiggsFieldGradingService`).
- **Languages:** English, French, Turkish, Spanish

---

## Architecture

```
lib/
├─ main.dart                     # loads .env, inits Firebase, ProviderScope
├─ firebase_options.dart         # TEMPLATE — regenerate with flutterfire configure
├─ l10n/                         # app_en/fr/tr/es.arb  (gen_l10n → AppLocalizations)
└─ src/
   ├─ app.dart                   # MaterialApp.router, dark theme, i18n
   ├─ core/
   │  ├─ config/env.dart         # typed .env (Higgs URL/key, mock flag)
   │  ├─ error/                  # Failure / Exception types
   │  ├─ network/
   │  │  ├─ dio_client.dart      # base URL + Bearer + retry
   │  │  ├─ retry_interceptor.dart   # exponential backoff + jitter
   │  │  └─ offline_queue.dart   # persist + auto-flush pending uploads
   │  ├─ router/app_router.dart  # go_router
   │  ├─ theme/app_theme.dart    # Aurora Academia (indigo/teal/amber)
   │  └─ utils/result.dart       # Result<T> = Success | Err
   └─ features/
      ├─ grading/
      │  ├─ domain/              # entities + GradingService / *Repository interfaces
      │  ├─ data/
      │  │  ├─ datasources/higgs_field_grading_service.dart
      │  │  └─ repositories/     # Firebase repo impls (stubbed)
      │  ├─ application/providers.dart   # Riverpod wiring
      │  └─ presentation/        # screens + widgets
      ├─ dashboard/              # Teacher Dashboard (Exams/Students/Results/Settings)
      │  ├─ domain/entities/     # Exam, Student, ClassAnalytics
      │  ├─ application/          # mock-data Riverpod providers
      │  └─ presentation/        # dashboard shell + sections + charts
      ├─ ads/                    # AdMob: banner / interstitial / rewarded
      │  ├─ ad_config.dart        # unit IDs (env override → test-ID fallback)
      │  ├─ application/          # AdsService + credits/upload-counter providers
      │  └─ presentation/widgets/banner_ad_widget.dart
      ├─ auth/                   # (stub) teacher sign-in
      └─ scan/                   # (stub) paper capture
```

Dependency rule points inward: `presentation → application → domain ← data`.
`domain` defines contracts (`GradingService`, `PaperRepository`,
`CurriculumRepository`); `data` implements them; `application` wires them via Riverpod.

---

## Higgs Field AI backend contract

The Flutter app calls **your** REST service (base URL from `HIGGS_BASE_URL`):

| Endpoint | Body | Response |
|---|---|---|
| `POST /grade` | multipart: `paper_image` (File), `model_answer` (JSON), `rubric_json`, `language` (`en`/`fr`/`tr`/`es`), `curriculum_tags` | JSON: `questions[]` (`score`, `max_points`, `ocr_text`, `feedback`, `confidence`), `total_score`, `max_score`, `overall_feedback`, `graded_pdf_url`, `ocr_raw_text` |
| `POST /rubric/generate` | JSON: `model_answer`, `language`, `curriculum_tags` | JSON rubric: `id`, `title`, `curriculum`, `criteria[]` |

Auth: `Authorization: Bearer <HIGGS_API_KEY>`.
`HiggsFieldGradingService` handles retry (via the Dio interceptor) and, when
offline, parks the request in `OfflineGradingQueue` for automatic retry on reconnect.

While `USE_MOCK_GRADING=true` (default) it returns canned JSON so the app runs
before your server is deployed.

---

## Prerequisites — Windows setup

Nothing is installed yet. Do these in order.

### 1. Flutter SDK
1. Download: <https://docs.flutter.dev/get-started/install/windows>
2. Extract to e.g. `C:\src\flutter` (no spaces, not under `C:\Program Files`).
3. Add `C:\src\flutter\bin` to your **Path**.
4. New terminal → `flutter --version`.

### 2. Android Studio (Android SDK + emulator)
1. Install: <https://developer.android.com/studio>
2. Install the **Android SDK**, **SDK Command-line Tools**, and an **emulator** image.
3. `flutter doctor --android-licenses`

### 3. Windows desktop support
Install **Visual Studio 2022** with the **"Desktop development with C++"** workload.

### 4. Firebase CLI + FlutterFire CLI
```powershell
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
```
Ensure `%LOCALAPPDATA%\Pub\Cache\bin` is on your Path so `flutterfire` resolves.

### 5. Verify
```powershell
flutter doctor
```

---

## Configure the app

### Higgs Field AI server URL
```powershell
copy .env.example .env
```
Edit `.env`:
```
HIGGS_BASE_URL=http://YOUR_SERVER_IP:8080/v1   # or https://higgs-field.yourdomain.com/v1
HIGGS_API_KEY=hf-xxxxxxxx
USE_MOCK_GRADING=true                          # false once your server is live
```

### Firebase project
1. Create a project at <https://console.firebase.google.com>.
2. Enable **Authentication** (Email/Password), **Firestore**, **Storage**.
3. From the project root:
   ```powershell
   flutterfire configure
   ```
   Select the project and the **android, ios, windows** platforms. This
   overwrites `lib/firebase_options.dart` with real (non-secret) identifiers and
   drops native config files (`google-services.json`, `GoogleService-Info.plist`)
   — those are git-ignored.

---

## Run & build

```powershell
flutter pub get
flutter gen-l10n                # generate AppLocalizations from lib/l10n/*.arb

flutter run -d windows          # or -d chrome / an Android emulator / a device
```

Codegen (freezed / json_serializable / riverpod_generator), when you add
generated models/providers:
```powershell
dart run build_runner build --delete-conflicting-outputs
```

### Release builds
```powershell
# Android APK
flutter build apk --release
#   → build\app\outputs\flutter-apk\app-release.apk

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (must run on macOS with Xcode — not buildable on Windows)
flutter build ios --release

# Windows EXE
flutter build windows --release
#   → build\windows\x64\runner\Release\grade_ai.exe
```

> **iOS note:** compiling/signing an iOS build requires a Mac (real, cloud, or
> network-paired). All iOS source lives in this repo; only the binary needs macOS.

---

## GitHub

1. Create an empty repo on GitHub (free/hobby account is fine).
2. From the project root:
   ```powershell
   git init
   git add .
   git commit -m "Initial scaffold: grade_ai"
   git branch -M main
   git remote add origin https://github.com/<you>/grade_ai.git
   git push -u origin main
   ```
3. **CI:** `.github/workflows/ci.yml` runs on every push/PR to `main` on GitHub's
   free tier — it fetches deps, generates l10n, checks formatting, runs
   `flutter analyze`, and `flutter test`. It creates a placeholder `.env` from
   `.env.example` so config loads during analysis/tests.

**Never commit real secrets.** `.env`, `google-services.json`, and
`GoogleService-Info.plist` are git-ignored. `lib/firebase_options.dart` is
committed as a placeholder template (Firebase client identifiers are not secret;
uncomment the line in `.gitignore` if you'd rather keep even those out).

---

## Monetization

The app uses **Google AdMob** (`google_mobile_ads`):

- **Banner ads** — pinned above the bottom nav on non-grading screens (dashboard
  Exams/Students/Results/Settings). Never shown during grading.
- **Interstitial ads** — shown after **every 3rd paper upload**
  (`AdConfig.uploadsPerInterstitial`), via `maybeShowInterstitialAfterUpload()` —
  called after an upload completes, never mid-grading.
- **Rewarded ads** — "Watch a short ad to get free grading credits" in Settings
  (`AdsService.showRewarded` → `creditsProvider`).

### ⚠️ Developer action required (AdMob account)

The AdMob account and payout email for this app must be
**`ali.utku.ismihan@gmail.com`**. Before release you must:

1. Create an AdMob account at <https://admob.google.com> signed in as
   **ali.utku.ismihan@gmail.com**, and complete payment/payout setup with that email.
2. **Add the app** in AdMob (one entry per platform: Android, iOS) and create ad
   units: one **Banner**, one **Interstitial**, one **Rewarded**.
3. Copy the App ID and the three ad-unit IDs into `.env`:
   ```
   ADMOB_APP_ID=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
   ADMOB_BANNER_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
   ADMOB_INTERSTITIAL_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
   ADMOB_REWARDED_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
   ```
   While these are **blank**, the app automatically uses Google's official **test**
   ad units (`AdConfig`) — safe for development. Do **not** ship test IDs, and do
   **not** click your own live ads.
4. Register the **App ID** in the native manifests (the `.env` `ADMOB_APP_ID` is
   for reference — the SDK reads the App ID from the platform manifest):
   - **Android** → `android/app/src/main/AndroidManifest.xml`, inside `<application>`:
     ```xml
     <meta-data
         android:name="com.google.android.gms.ads.APPLICATION_ID"
         android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
     ```
   - **iOS** → `ios/Runner/Info.plist`:
     ```xml
     <key>GADApplicationIdentifier</key>
     <string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
     ```
   - AdMob does not target Windows; ads are simply absent there.

---

## Status

Scaffold only. **Implemented:** project structure, Aurora Academia theme, i18n
(en/fr/tr/es) with a working language switcher, domain contracts,
`HiggsFieldGradingService` (mock + live REST + retry + offline queue), Riverpod
wiring, Firebase bootstrap, Teacher Dashboard (Exams/Students/Results/Settings
with mock data + charts), AdMob module (banner/interstitial/rewarded + credits),
CI. **Stubbed:** Firebase repository implementations, auth, scan/capture,
CSV import, Excel export, create-exam flow.
