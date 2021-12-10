if (typeof firebase === 'undefined')
  throw new Error(
    'hosting/init-error: Firebase SDK not detected. You must include it before /__/firebase/init.js'
  );
const firebaseConfig = {
  apiKey: 'AIzaSyDhxf3DBtiKC_Z30py9-hdDlSKcyv6jCGg',
  authDomain: 'vgv-groupbooth.firebaseapp.com',
  projectId: 'vgv-groupbooth',
  storageBucket: 'vgv-groupbooth.appspot.com',
  messagingSenderId: '918484579319',
  appId: '1:918484579319:web:00f5db4fa5edd76d1fb4f2',
  measurementId: '${config.measurementId}',
};

if (firebaseConfig) {
  console.log('Initializing Firebase');
  firebase.initializeApp(firebaseConfig);
  console.log('Done');

  var firebaseEmulators = undefined;
  if (firebaseEmulators) {
    console.log('Automatically connecting Firebase SDKs to running emulators:');
    Object.keys(firebaseEmulators).forEach(function (key) {
      console.log(
        '\t' +
          key +
          ': http://' +
          firebaseEmulators[key].host +
          ':' +
          firebaseEmulators[key].port
      );
    });

    if (firebaseEmulators.database && typeof firebase.database === 'function') {
      firebase
        .database()
        .useEmulator(
          firebaseEmulators.database.host,
          firebaseEmulators.database.port
        );
    }

    if (
      firebaseEmulators.firestore &&
      typeof firebase.firestore === 'function'
    ) {
      firebase
        .firestore()
        .useEmulator(
          firebaseEmulators.firestore.host,
          firebaseEmulators.firestore.port
        );
    }

    if (
      firebaseEmulators.functions &&
      typeof firebase.functions === 'function'
    ) {
      firebase
        .functions()
        .useEmulator(
          firebaseEmulators.functions.host,
          firebaseEmulators.functions.port
        );
    }

    if (firebaseEmulators.auth && typeof firebase.auth === 'function') {
      firebase
        .auth()
        .useEmulator(
          'http://' +
            firebaseEmulators.auth.host +
            ':' +
            firebaseEmulators.auth.port
        );
    }
  } else {
    console.log(
      "To automatically connect the Firebase SDKs to running emulators, replace '/__/firebase/init.js' with '/__/firebase/init.js?useEmulator=true' in your index.html"
    );
  }
}
