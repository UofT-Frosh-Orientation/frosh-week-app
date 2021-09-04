importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

const firebaseConfig = {
      apiKey: "AIzaSyCc0JgrS_bGmtnGXg4pOmPAnEcBROYXLtI",
      authDomain: "frosh-week-2t1.firebaseapp.com",
      projectId: "frosh-week-2t1",
      storageBucket: "frosh-week-2t1.appspot.com",
      messagingSenderId: "286799515361",
      appId: "1:286799515361:web:17449fb5924dc20b3371a0",
      measurementId: "G-SCZYLMCQQM"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
messaging.onBackgroundMessage((m) => {
    console.log("onBackgroundMessage", m);
})

