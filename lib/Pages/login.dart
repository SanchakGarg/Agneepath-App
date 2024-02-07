import 'package:agneepath_app/Pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:agneepath_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_in_button/sign_in_button.dart';

String Authorisation_person ='';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  Stream<QuerySnapshot>? usersStream;
  bool isAuthorized = false;
  String status ='';
  String? email ='';


  void handlegooglesignin() async {
    if(kIsWeb){setState(() {
      status='';
      email=null;
    });
    try {
      auth.signOut();
      final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential = await auth.signInWithPopup(googleAuthProvider);
      final User? user = userCredential.user;
      if (user != null) {
        // final String? displayName = user.displayName;// Do something with the user's email, display name, and photo URL
      }
    } catch (error) {
      print(error);
    }
    if(user !=null){
      if(isAuthorized){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Navigate()));}}}
    else {
      setState(() {
        status='';
        email=null;
      });
      try {
        auth.signOut();
        // GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleSignIn.signOut();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth =await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await auth.signInWithCredential(credential);
        }
      } catch (error) {
        print(error);
      }
      if(user !=null){
        if(isAuthorized){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Navigate()));}}
    }
  }

  @override
  void initState()  {
    super.initState();
    email=auth.currentUser?.email;
    auth.authStateChanges().listen((User? user) {
      setState(() {user = user;Authorize(auth.currentUser?.uid);email=auth.currentUser?.email;});});}



  @override
  Widget build(BuildContext context) {
    // GoogleSignInAccount? user = googleSignIn.currentUser;
    return Scaffold(
      body:isAuthorized ? const Navigate():LoginPage(),);}



  Widget LoginPage(){
    return Scaffold(appBar: AppBar(title: const Text('Login'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Authentication'),
            const SizedBox(height: 50),
            SignInButton(
              Buttons.google,
              text: 'Log in with google',
              onPressed: handlegooglesignin,
            ),
            Text(status),
            if(auth.currentUser?.email!=null)Text("Email id: $email" )],),),);
  }




  void Authorize(id) async {
    if(id!=null){

      final DocumentReference documentReference = FirebaseFirestore.instance.collection('Users').doc(id);
      try {
        DocumentSnapshot documentSnapshot = await documentReference.get();
        if (documentSnapshot.exists) {
          Authorisation_person = '${documentSnapshot.get('name')}';

          print('Document data: ${documentSnapshot.data()}');
          setState(() {
            isAuthorized = true;
            status = 'Login Successfull!';
          });
        } else {
          print('Document does not exist on the database');
          setState(() {
            isAuthorized = false;
            status='Unauthorized';
          });
        }
      } catch (e) {
        status='Error getting document: $e';
        setState(() {
          isAuthorized = false;
        });
      }
    }
    else{
      setState(() {
        isAuthorized=false;
        status='login to the application';
      });
    }
  }
}