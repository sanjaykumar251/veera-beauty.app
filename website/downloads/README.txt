Place the final release APK in this folder with this exact filename:

veeras-beauty.apk

Then the website buttons will download it directly.

Recommended build command:

flutter build apk --release --dart-define=API_BASE_URL=https://veeras-beauty-backend.onrender.com/api

After build, copy:

build\app\outputs\flutter-apk\app-release.apk

to:

website\downloads\veeras-beauty.apk
