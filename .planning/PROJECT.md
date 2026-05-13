# Sentinel MVP — Project Context

## What This Is

**Sentinel** is a personal safety mobile application MVP built with Flutter and Firebase. It provides core safety features: user authentication with OTP-based login, SOS emergency alerts, GPS location tracking, and incident reporting with image uploads.

## Core Value

**One-tap SOS emergency alert** — the ability to instantly raise an alert with timestamp and GPS location is the #1 must-work feature. Everything else supports this.

## Context

- **Type:** Mobile MVP / Assignment submission
- **Timeline:** 1-2 days (8-16 hours development)
- **Stack:** Flutter + Riverpod (state management) + Firebase (Auth, Firestore, Storage)
- **Target:** Android APK build + source code
- **Evaluation criteria:** Code quality, UI/UX, Architecture, Product thinking, Edge cases, Documentation

## Technical Decisions

| Decision | Rationale | Status |
|----------|-----------|--------|
| Flutter + Riverpod | Required by assignment | Confirmed |
| Firebase (Auth/Firestore/Storage) | Required by assignment | Confirmed |
| Static OTP simulation | Assignment explicitly allows static OTP | Confirmed |
| Geolocator package for GPS | Best Flutter GPS package, well-maintained | Confirmed |
| image_picker for uploads | Standard Flutter image selection | Confirmed |
| Clean Architecture (simplified) | Show architecture competence without over-engineering | Confirmed |
| Material 3 design system | Modern, polished look with minimal effort | Confirmed |

## Constraints

- **No over-engineering** — practical, clean execution
- **Static OTP allowed** — don't need actual SMS gateway
- **Must produce an APK** — needs to run on Android
- **Must include README** — setup instructions required

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] User creation with mobile number + password
- [ ] Login with mobile number + OTP (static OTP)
- [ ] SOS alert popup with timestamp
- [ ] SOS event persistence to Firestore
- [ ] GPS location fetch (lat/lng)
- [ ] GPS location display on screen
- [ ] Incident reporting (type, description, optional image, auto-location)
- [ ] Clean, polished UI/UX
- [ ] Proper state management with Riverpod
- [ ] Edge case handling (permissions, connectivity, empty states)

### Out of Scope

- Real SMS OTP — assignment allows static OTP
- Push notifications — not in requirements
- Real-time location tracking — only current location fetch needed
- Admin dashboard — user-facing only
- iOS build — Android APK is the deliverable

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Feature-first folder structure | Clean separation without over-engineering | Pending |
| Riverpod for all state | Assignment requirement + testable | Pending |
| Firebase Firestore for persistence | Required stack, handles SOS events + incidents | Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

---
*Last updated: 2026-05-13 after initialization*
