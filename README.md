# 🛡️ Sentinel MVP

> **Personal Safety Companion App** — Built with Flutter & Firebase

A mobile MVP covering emergency SOS alerts, real-time GPS tracking, and incident reporting, submitted as part of a Flutter developer assignment.

---

## 📱 Features

| Module | Description |
|---|---|
| 👤 **User Creation** | Register with mobile number + password. Credentials stored securely in Firebase Auth & Firestore. |
| 🔐 **Login + OTP** | Login with phone number → OTP verification screen (static OTP simulation). |
| 🆘 **SOS Alert** | One-tap SOS button → confirmation popup → saves event with timestamp + GPS coords to Firestore. |
| 📍 **GPS Location** | Fetches current latitude/longitude via Geolocator. Displayed on dashboard with refresh. |
| 📋 **Incident Reporting** | Report incidents by type (Medical, Security, Fire, etc.) with description, optional photo upload, and auto-captured location. |

---

## 🎬 Demo Credentials

> The app uses a **static OTP simulation** for the MVP.

| Field | Value |
|---|---|
| Mobile Number | Any valid 10-digit number (e.g. `9876543210`) |
| Password | Any password ≥ 6 characters |
| OTP | **`123456`** (static — shown as a hint on the OTP screen) |

**Flow:**
1. Register → enter phone + password → account created
2. Login → enter same phone + password → OTP screen
3. Enter `123456` → lands on home dashboard

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.x (Dart) |
| **State Management** | Riverpod 3.x (`Notifier` pattern) |
| **Backend / Auth** | Firebase Authentication (Email/Password, simulating Phone Auth) |
| **Database** | Cloud Firestore |
| **File Storage** | Firebase Storage (incident image uploads) |
| **Routing** | GoRouter 17.x with auth redirect guards |
| **Location** | Geolocator 14.x |
| **Image Picker** | image_picker 1.x |

---

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/       # AppConstants (OTP, collection names, etc.)
│   ├── router/          # GoRouter config with auth guards
│   └── theme/           # AppTheme, colors, typography
├── features/
│   ├── auth/
│   │   ├── data/repositories/   # AuthRepository (Firebase Auth + Firestore)
│   │   └── presentation/
│   │       ├── providers/       # AuthNotifier (Riverpod)
│   │       └── screens/         # LoginScreen, RegisterScreen, OtpScreen
│   ├── home/
│   │   └── presentation/
│   │       ├── screens/         # HomeScreen (tab shell)
│   │       └── widgets/         # DashboardTab, HistoryTab, ProfileTab
│   ├── sos/
│   │   ├── data/                # SosEvent model, SosRepository
│   │   └── presentation/        # SosNotifier, sosHistoryProvider
│   ├── location/
│   │   ├── data/                # LocationRepository (Geolocator)
│   │   └── presentation/        # LocationNotifier
│   └── incidents/
│       ├── data/                # IncidentReport model, IncidentRepository
│       └── presentation/        # IncidentNotifier, ReportIncidentScreen
├── firebase_options.dart        # ⚠️ NOT committed (generated per machine)
└── main.dart
```

---

## ⚙️ Setup Instructions

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.10
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) (`dart pub global activate flutterfire_cli`)
- Android Studio / Xcode (for running on a device/emulator)

### 1. Clone & Install Dependencies

```bash
git clone https://github.com/TheJenilDGohel/sentinel_mvp.git
cd sentinel_mvp
flutter pub get
```

### 2. Firebase Setup

> **Note:** `firebase_options.dart` and `google-services.json` are excluded from the repo for security. You must generate them for your own Firebase project.

1. Create a project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Authentication** → Sign-in method → **Email/Password**
3. Enable **Cloud Firestore** (start in test mode for development)
4. Enable **Firebase Storage**
5. Run FlutterFire configure:

```bash
flutterfire configure
```

This generates `lib/firebase_options.dart` and `android/app/google-services.json` automatically.

### 3. Firestore Security Rules (Development)

Deploy the included rules for development:

```bash
firebase deploy --only firestore:rules
```

> ⚠️ The default rules (`allow read, write: if true`) are for **development only**. Tighten before production.

### 4. Run the App

```bash
# On a connected Android device or emulator
flutter run

# Or specify a device
flutter run -d <device-id>
```

---

## 📦 Build APK

```bash
# Debug APK (for testing/submission)
flutter build apk --debug

# Release APK (requires signing config)
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

---

## 🗄️ Firestore Collections

| Collection | Fields | Purpose |
|---|---|---|
| `users` | `phoneNumber`, `createdAt`, `updatedAt` | User profiles |
| `sos_events` | `userId`, `timestamp`, `latitude?`, `longitude?` | SOS alerts |
| `incident_reports` | `userId`, `incidentType`, `description`, `imageUrl?`, `latitude?`, `longitude?`, `timestamp` | Incident records |

---

## 🧪 Running Tests

```bash
flutter test
```

Unit tests cover:
- `SosNotifier` — trigger, error, and history state transitions
- `IncidentNotifier` — submit, validation, and error handling

---

## 📋 Assignment Checklist

- [x] User Creation — mobile number + password
- [x] Login Flow — mobile number + OTP simulation (static `123456`)
- [x] Login success flow → home dashboard
- [x] SOS — alert popup + save event to Firebase + display timestamp
- [x] GPS Location — fetch current position, display lat/lng
- [x] Incident Reporting — type, description, optional image upload, auto location
- [x] Flutter + Firebase stack
- [x] Clean `dart analyze` output (no issues)
- [x] Proper README

---

## ⚠️ Known MVP Limitations

- **OTP is simulated** — uses static `123456`. Production would use Firebase Phone Authentication with real SMS delivery.
- **Firestore rules are open** (`allow read, write: if true`) — production requires user-scoped rules.
- **No push notifications** — SOS alert is local only (saved to Firestore).

---

## 👨‍💻 Author

**Jenil Gohel**
- GitHub: [@TheJenilDGohel](https://github.com/TheJenilDGohel)

---

*Estimated development time: ~10 hours | Stack: Flutter + Firebase + Riverpod*
