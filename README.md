# Smart Incident App

## Flutter Version
- **SDK**: `^3.10.1` (Ensure you have Flutter 3.10.1 or higher installed).

## Firebase Setup
This project uses Firebase for backend services. To set it up:

1. **Install Firebase CLI**:
   ```bash
   npm install -g firebase-tools
   ```
2. **Login to Firebase**:
   ```bash
   firebase login
   ```
3. **Activate FlutterFire CLI**:
   ```bash
   dart pub global activate flutterfire_cli
   ```
4. **Configure Firebase**:
   Run the following command in the project root to connect your Flutter app to your Firebase project:
   ```bash
   flutterfire configure
   ```
   Follow the prompts to select your project and platforms (Android, iOS, etc.).

## Incident Type API Source
The incident types are fetched from the following MockAPI endpoint:
- **Base URL**: `https://694a90bb26e870772065e847.mockapi.io/smartIncident/api/v1`
- **Endpoint**: `/incidentTypes`
- **Full URL**: `https://694a90bb26e870772065e847.mockapi.io/smartIncident/api/v1/incidentTypes`
