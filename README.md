# Pawneo

Pawneo is a Flutter prototype for turning idle physical objects into instant collateral. The current build focuses on a viral mobile experience: camera-based valuation, Pawneo Score, object pawning, profile trust/rewards and a navigable collateral-pool map.

## What is included

- Login/register flow with animated transitions.
- Bottom navigation with Home, Items, Scan, Pools and Profile.
- Real camera/gallery access through `image_picker`.
- Scan-to-value flow with synthetic AI valuation, Pawneo Score, credit line and system bottom sheets.
- Pools tab with an interactive map-style view of regions and loan portfolios available for collateralization.
- Profile tab with Overview, Trust and Rewards sections.
- Reusable Pawneo system modal sheets for product messages and confirmations.

## Run in Android Studio

1. Open this repository in Android Studio.
2. Make sure Flutter and Dart plugins are installed.
3. Select an Android emulator or a connected Android device.
4. Run:

```bash
flutter pub get
flutter run
```

For web quick testing:

```bash
flutter pub get
flutter run -d chrome
```

## Android permissions

The Android manifest already includes camera and gallery/image permissions for the valuation flow. When the emulator asks for camera/gallery access, allow it.

## Notes

This is a product prototype. Valuations, risk scores, pool matching, custody and insurance logic are mocked in-app and ready to be replaced by backend services.
