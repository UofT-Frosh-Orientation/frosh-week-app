# Frosh Week 2T1 App
This app is intended to be used by the Frosh and the Frosh orientation committee to aid in the sign-in process for in person activities. This app contains a QR code for each Frosh with their UUID embedded to ensure their account gets tagged with a sign-in entry in the database when a Leader account scans the QR code. This app also contains useful information such as a schedule, resources, and sending push notification abilities.

## Release
iOS Release: https://apps.apple.com/ca/app/f-rosh-week/id1581524056

Android Release: Not available. (However an APK is, located on the Frosh website repo: https://github.com/UofT-Frosh-Orientation/froshweek3.0/blob/dev/client/src/assets/virtualkit/app-release.apk)

## Getting Started
Install Flutter, Java SDK, Android SDK, Swift dependencies etc. and ensure ```flutter doctor``` runs without errors

Install dependencies located in ```pubspec.yaml```

Run app in debug mode

Warning: Web App mode does not work with log in - this is because the backend request system works differently in web app mode

## Future Enhancements
* Some pages and components should be rewritten for better modularity 
* Schedule: if there's no location for an event it should remove the entire text widget for location to resize container, not show blank space
* Use safe area (especially for iOS, navbar is too low)
* Enhancement: schedule notifications automatically from the time in the schedule for events
* Enhancement: settings page for dark mode and notifications
* Enhancement: map of locations of events
* Hopefully, in the future, with in person kit pickup, this app can be used by Kits to also pass on information for shirt sizes and to confirm they have picked up their kit
* This can also be used to sign people in for Scunt and other activities (with the dynamic location selection)
* Enhancement: Web app mode (backend needs to be rewritten)
* The app can be used for different activities: e.g. interactive Matriculation activities? 