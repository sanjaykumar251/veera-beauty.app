# Render Deployment Guide

This project can be deployed to Render as a Node web service using `render.yaml`.

## 1. Push the project to GitHub

Render needs a Git repository.

## 2. Create the Render service

1. Open Render dashboard.
2. Click `New +`.
3. Choose `Blueprint`.
4. Connect your GitHub repository.
5. Render will detect `render.yaml`.

## 3. Set environment variables

In Render, fill these values:

- `MONGODB_URI`
- `JWT_SECRET`
- `JWT_EXPIRES_IN`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_PRIVATE_KEY_ID`
- `FIREBASE_PRIVATE_KEY`
- `FIREBASE_CLIENT_EMAIL`
- `FIREBASE_CLIENT_ID`
- `GPAY_UPI_ID`
- `ALLOWED_ORIGINS`

Recommended `ALLOWED_ORIGINS`:

- `http://localhost:3000,http://localhost:8080`
- Add your final frontend origin later if needed

For mobile apps, CORS is usually not the blocker, but keeping this set is still cleaner.

## 4. Verify deployment

After deploy, open:

`https://YOUR-RENDER-URL.onrender.com/health`

It should return success JSON.

## 5. Connect Flutter app to Render backend

Run Flutter using your public API URL:

```powershell
cd D:\veera\flutter_app
flutter run --dart-define=API_BASE_URL=https://YOUR-RENDER-URL.onrender.com/api
```

For APK build:

```powershell
cd D:\veera\flutter_app
flutter build apk --release --dart-define=API_BASE_URL=https://YOUR-RENDER-URL.onrender.com/api
```

## 6. Important note about free Render

On the free plan, the backend may sleep after inactivity.
The first request after sleep can take some extra time.
