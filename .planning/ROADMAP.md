# Sentinel MVP — Roadmap

## Milestone: v1.0 — Sentinel MVP

### Phase 1: Project Scaffold & Authentication
- **Goal:** Bootstrap Flutter project with clean architecture, set up Firebase, implement user registration and OTP-based login flow
- **Requirements:** AUTH-01, AUTH-02, AUTH-03, AUTH-04, AUTH-05
- **Status:** Not Started
- **Success Criteria:**
  1. Flutter project runs on Android/Chrome with no errors
  2. User can register with mobile number + password
  3. User can log in with mobile number, enter static OTP (123456), and reach home screen
  4. Session persists across app restart
  5. User can log out and is returned to login screen

### Phase 2: GPS Location Service
- **Goal:** Implement location permissions handling and GPS coordinate display
- **Requirements:** LOC-01, LOC-02, LOC-03, LOC-04
- **Depends on:** Phase 1
- **Status:** Not Started
- **Success Criteria:**
  1. App requests location permission with clear rationale
  2. Current lat/lng displayed on screen
  3. Permission denied shows friendly message with settings link
  4. Location fetch errors handled gracefully

### Phase 3: SOS Emergency Alert
- **Goal:** Implement one-tap SOS with alert popup, Firestore persistence, and event history
- **Requirements:** SOS-01, SOS-02, SOS-03, SOS-04, SOS-05
- **Depends on:** Phase 1, Phase 2
- **Status:** Not Started
- **Success Criteria:**
  1. Big SOS button visible on home screen
  2. Tapping SOS shows confirmation alert with timestamp
  3. SOS event saved to Firestore with timestamp + GPS
  4. SOS history screen shows past events
  5. Works even if location unavailable (saves without coords)

### Phase 4: Incident Reporting
- **Goal:** Build incident report form with type selection, description, optional image upload, and auto-location
- **Requirements:** INC-01, INC-02, INC-03, INC-04, INC-05, INC-06
- **Depends on:** Phase 1, Phase 2
- **Status:** Not Started
- **Success Criteria:**
  1. User can select incident type from dropdown/chips
  2. User can write multi-line description
  3. Image picker works (camera + gallery)
  4. Location auto-captured on form open
  5. Report saved to Firestore
  6. Incident list shows past reports

### Phase 5: UI Polish & Edge Cases
- **Goal:** Polish UI/UX, handle edge cases, add loading/error/empty states, create README
- **Requirements:** UX-01, UX-02, UX-03, UX-04, UX-05
- **Depends on:** Phase 1, Phase 2, Phase 3, Phase 4
- **Status:** Not Started
- **Success Criteria:**
  1. All screens use consistent Material 3 theme
  2. Loading indicators on all async operations
  3. Error messages are user-friendly with retry options
  4. Empty states for SOS history and incident list
  5. README with setup instructions exists
