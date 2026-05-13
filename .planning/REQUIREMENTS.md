# Sentinel MVP — Requirements

## v1 Requirements

### Authentication
- [ ] **AUTH-01**: User can create account with mobile number and password
- [ ] **AUTH-02**: User can log in with mobile number and receive OTP (static OTP: 123456)
- [ ] **AUTH-03**: User can verify OTP and access the app
- [ ] **AUTH-04**: User session persists across app restarts (Firebase Auth state)
- [ ] **AUTH-05**: User can log out from any screen

### SOS
- [ ] **SOS-01**: User can trigger SOS alert with a single tap from the home screen
- [ ] **SOS-02**: SOS shows an alert popup/dialog confirming the emergency
- [ ] **SOS-03**: SOS event is saved to Firestore with timestamp
- [ ] **SOS-04**: SOS event includes user's current GPS coordinates
- [ ] **SOS-05**: User can view history of past SOS events with timestamps

### Location
- [ ] **LOC-01**: App requests and handles location permissions gracefully
- [ ] **LOC-02**: App fetches current GPS coordinates (latitude/longitude)
- [ ] **LOC-03**: Current location is displayed on screen with lat/lng values
- [ ] **LOC-04**: Location errors are handled with user-friendly messages

### Incident Reporting
- [ ] **INC-01**: User can select an incident type from predefined list
- [ ] **INC-02**: User can write a description of the incident
- [ ] **INC-03**: User can optionally upload an image from camera/gallery
- [ ] **INC-04**: Location is auto-captured when reporting an incident
- [ ] **INC-05**: Incident report is saved to Firestore
- [ ] **INC-06**: User can view list of past incident reports

### UI/UX
- [ ] **UX-01**: Clean, modern Material 3 design
- [ ] **UX-02**: Loading states for async operations
- [ ] **UX-03**: Error states with retry options
- [ ] **UX-04**: Empty states for lists (no SOS history, no incidents)
- [ ] **UX-05**: Responsive layout that works on different screen sizes

## v2 Requirements (Deferred)
- Real SMS OTP integration
- Emergency contact notifications
- Map view for location display
- Push notifications for SOS
- Incident report sharing
- Dark mode

## Out of Scope
- Admin dashboard — user-facing MVP only
- iOS build — Android APK is the deliverable
- Real-time location tracking — only current location fetch
- Multi-language support — English only for MVP
- Offline-first sync — requires online connectivity

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTH-01..05 | Phase 1 | Pending |
| SOS-01..05 | Phase 3 | Pending |
| LOC-01..04 | Phase 2 | Pending |
| INC-01..06 | Phase 4 | Pending |
| UX-01..05 | Phase 5 | Pending |

---
*Last updated: 2026-05-13 after initialization*
