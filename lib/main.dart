import 'package:agneepath_security/Pages/Home.dart';
import 'package:agneepath_security/Pages/login.dart';
import 'package:agneepath_security/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

void signout() {
  FirebaseAuth.instance.signOut();
  googleSignIn.signOut();
}

// bool isAuthorised = false;
// final DocumentReference documentReference =
// FirebaseFirestore.instance.collection('Users').doc(
//     FirebaseAuth.instance.currentUser?.uid);
//
// void Authorize()async {
//   try {
//     DocumentSnapshot documentSnapshot = await documentReference.get();
//     if (documentSnapshot.exists) {
//       print('Document data: ${documentSnapshot.data()}');
//       isAuthorised = true;
//     } else {
//       print('Document does not exist on the database');
//       isAuthorised = false;
//     }
//   } catch (e) {
//     print('Error getting document: $e');
//     isAuthorised = false;
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Authorize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}
