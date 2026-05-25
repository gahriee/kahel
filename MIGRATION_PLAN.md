# Kahel — Flutter → Swift Migration Plan

> Migrate the **Kahel** gamified personal-finance RPG from Flutter/Dart to a **native iOS Swift** app.

## Environment Constraints (HARD CEILING)

| Requirement | Locked Value |
|---|---|
| Xcode | **15** (15.0 – 15.2) |
| Swift | **5.9** |
| Simulator | **iPhone 15 Pro** |
| macOS | **Ventura 13.6.1** |
| Minimum iOS Target | **17.0** |

## Architecture

- **Pattern**: MVVM + Combine + UIKit
- **State**: Combine `@Published` + `ObservableObject` ViewModels
- **Firebase**: `firebase-ios-sdk ~> 10.25` via SPM
- **Auth**: `GoogleSignIn-iOS ~> 7.1` via SPM
- **Avatar**: DiceBear HTTP API + SVGKit ~> 3.0

## Project Structure

```
Kahel/
├── App/           — AppDelegate, SceneDelegate, GoogleService-Info.plist
├── Core/
│   ├── Constants/ — Banks, Categories, QuestPool
│   ├── Theme/     — AppColors, AppFonts, AppTheme
│   └── Utils/     — RpgEngine
├── Models/        — 9 data structs (UserProfile, BankAccount, etc.)
├── Services/      — AuthService, FirestoreService, RealtimeDatabaseService, AvatarService
├── ViewModels/    — 8 view models (Auth, Dashboard, Savings, Profile, etc.)
├── Views/         — 11 UIViewControllers
├── Widgets/       — 7 custom UIView components (PixelButton, StarField, etc.)
└── Resources/     — Fonts, Assets.xcassets, Info.plist
```

## Phases

1. **Foundation & Core** — Project setup, models, theme, services, auth
2. **ViewModels** — Combine-powered view models
3. **UI Layer** — Custom widgets + all view controllers
4. **Polish & Testing** — Animations, transitions, unit tests, simulator validation
