# Sentinel MVP

Sentinel is a personal safety mobile application built with Flutter and Firebase. It provides rapid response capabilities during emergencies by offering one-tap SOS alerts, real-time location tracking, and an incident reporting system.

## 🚀 Features

*   **One-Tap SOS Alert:** Instantly trigger an emergency alert to capture your precise location and timestamp.
*   **Real-time GPS Tracking:** View your current latitude and longitude dynamically.
*   **Incident Reporting:** Log specific incidents (e.g., Medical, Security, Fire) with detailed descriptions and automated location capture.
*   **Authentication Flow:** Secure login and registration using phone number and static OTP simulation.
*   **Modern State Management:** Powered by Riverpod 3.x (`Notifier` pattern) for reliable, scalable application state.

## 🛠️ Technology Stack

*   **Framework:** [Flutter](https://flutter.dev/) (Dart)
*   **State Management:** [Riverpod 3.x](https://riverpod.dev/) (`riverpod_annotation`)
*   **Backend & DB:** Firebase Authentication & Cloud Firestore
*   **Routing:** [GoRouter](https://pub.dev/packages/go_router)
*   **Location Services:** [Geolocator](https://pub.dev/packages/geolocator)

## 📦 Setup Instructions

### Prerequisites
1.  **Flutter SDK:** Make sure you have Flutter installed. [Installation Guide](https://docs.flutter.dev/get-started/install).
2.  **Firebase CLI:** For generating/updating the Firebase options. [Firebase CLI Guide](https://firebase.google.com/docs/cli).

### Installation
1.  Clone this repository or download the source code.
2.  Navigate to the project root and install dependencies:
    ```bash
    flutter pub get
    ```
3.  Set up Firebase:
    *   Create a project on the [Firebase Console](https://console.firebase.google.com/).
    *   Enable **Authentication** (Email/Password provider used to simulate Phone auth for the MVP).
    *   Enable **Cloud Firestore**.
    *   Run `flutterfire configure` to connect the project and generate `firebase_options.dart`.
4.  Run the application:
    ```bash
    flutter run
    ```

### MVP Notes & Limitations
*   **OTP Simulation:** The MVP simulates Phone Authentication using a static OTP (`123456`) and provisions users via Firebase Email/Password underneath. Use any phone number and `123456` as the OTP during registration and login.
*   **Location:** Requires device location permissions. Ensure location services are enabled on the test device.

## 📱 Deliverables
*   **Source Code:** Available in this repository.
*   **APK Build:** Can be generated via `flutter build apk` (or `flutter build apk --debug`).
