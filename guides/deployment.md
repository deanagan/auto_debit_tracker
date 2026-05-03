# Flutter App Store Deployment Guide (macOS)

## 1. MVP Strategy: The 25% Rule
* **Goal:** By the time 25% of your features are done, you should have a "Hello World" version successfully uploaded to TestFlight or Google Play Internal Testing.
* **Why:** Validates your Bundle IDs, App IDs, and Signing Certificates early.
* **Physical Testing:** Always test on a physical device. Simulators do not accurately represent performance, camera, or GPS behavior.

## 2. Deployment Workflow
### Recommended Daily Cycle
1.  **Feature Work:** Code on a `feature/` branch.
2.  **Staging:** Merge to `develop` and run on a physical device.
3.  **Release Candidate:** Merge to `main` and increment the version in `pubspec.yaml`.
4.  **Distribution:** Run build commands and upload to testing tracks.

---

## 3. iOS Checklist (App Store)
1.  **Preparation:**
    * Join Apple Developer Program ($99/year).
    * Create App Record in [App Store Connect](https://appstoreconnect.apple.com/).
2.  **Configuration:**
    * Set App Icon (use `flutter_launcher_icons` package).
    * Open `ios/Runner.xcworkspace` in Xcode.
    * Set **Signing & Capabilities** to "Automatically manage signing".
3.  **Build & Upload:**
    * Command: `flutter build ipa`
    * Open the **Transporter** app (free on Mac App Store).
    * Drag the `.ipa` from `build/ios/archive/` into Transporter and click "Deliver".

---

## 4. Android Checklist (Google Play)
1.  **Preparation:**
    * Join Google Play Console ($25 one-time fee).
2.  **Signing (Crucial):**
    * Generate a keystore: `keytool -genkey -v -keystore ~/upload-keystore.jks ...`
    * Create `android/key.properties` (do NOT commit this to Git).
    * Configure `android/app/build.gradle` to reference the keys.
3.  **Build & Upload:**
    * Command: `flutter build appbundle`
    * Upload the `.aab` file from `build/app/outputs/bundle/release/` to the **Internal Testing** track in the Play Console.

---

## 5. Critical Tools
* **Environment Secrets:** Use `--dart-define` for API keys so they aren't hardcoded.
* **Fastlane:** Once you've done 2-3 manual deploys, look into [Fastlane](https://docs.fastlane.tools/) to automate the entire process.
* **Privacy Policy:** Use a simple site (like GitHub Pages) to host a basic privacy policy; both stores require this for review.
