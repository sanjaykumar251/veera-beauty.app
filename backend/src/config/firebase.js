const admin = require('firebase-admin');

let firebaseInitialized = false;

if (!admin.apps.length) {
  const projectId = process.env.FIREBASE_PROJECT_ID;
  const privateKey = process.env.FIREBASE_PRIVATE_KEY;
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;

  // Only init if real credentials are provided
  const hasRealCredentials =
    projectId && projectId !== 'your-firebase-project-id' &&
    privateKey && privateKey.includes('BEGIN PRIVATE KEY') && !privateKey.includes('YOUR_PRIVATE_KEY') &&
    clientEmail && clientEmail !== 'firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com';

  if (hasRealCredentials) {
    try {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId,
          privateKeyId: process.env.FIREBASE_PRIVATE_KEY_ID,
          privateKey: privateKey.replace(/\\n/g, '\n'),
          clientEmail,
          clientId: process.env.FIREBASE_CLIENT_ID,
        }),
      });
      firebaseInitialized = true;
      console.log('✅ Firebase Admin SDK initialized');
    } catch (err) {
      console.warn('⚠️  Firebase init failed:', err.message);
    }
  } else {
    console.warn('⚠️  Firebase: placeholder credentials detected — running without Firebase Auth.');
    console.warn('   → Update FIREBASE_* values in .env to enable Firebase features.');
  }
}

module.exports = admin;
module.exports.isInitialized = () => firebaseInitialized;

