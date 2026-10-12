# Kingdom of Steps

A bilingual Flutter pedometer that turns daily activity into a lightweight game. The project combines sensor integration, local persistence, progress visualization, challenges, clans, and leaderboard concepts in one mobile codebase.

## Features

- Direct step-sensor tracking with permission handling
- Optional Health Connect synchronization for historical data
- Daily goals, streaks, challenges, and progress indicators
- Gamified kingdom/clan and leaderboard concepts
- Arabic and English localization
- Local persistence with Hive and Shared Preferences
- Charts and animated progress UI

## Architecture

```text
Device step sensor / Health Connect
              ↓
        activity services
              ↓
       Provider state layer
              ↓
 goals · streaks · challenges · bilingual UI
```

## Technical stack

Flutter, Dart, Provider, Pedometer, Health Connect, Hive, Shared Preferences, `fl_chart`, and Flutter localization.

## Run locally

```bash
flutter pub get
flutter test
flutter run
```

Step tracking is best validated on a physical Android device. Health Connect availability and permissions vary by Android version.

## My role

Mobile application development, sensor integration, gamification workflow, localization, and iterative R&D under the Entropia Studio development account.

## Project status

Functional prototype. Cloud-backed social competition is represented as a product direction; the current repository focuses on the local mobile experience.
