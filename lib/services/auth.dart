import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:recycle_app/services/database.dart';
import 'package:recycle_app/services/shared_pref.dart';
import '../pages/home.dart';


class AuthMethods {
  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: '237401968119-pc997bdocqh80srmsgbrglijl61t9jeg.apps.googleusercontent.com',
    );

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleAuth =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential result =
      await firebaseAuth.signInWithCredential(credential);
      User? userDetails = result.user;

      if (userDetails != null) {
        await SharedPreferenceHelper().saveUseEmail(userDetails.email!);
        await SharedPreferenceHelper().saveUserId(userDetails.uid);
        await SharedPreferenceHelper().saveUserImage(userDetails.photoURL!);
        await SharedPreferenceHelper().saveUserName(userDetails.displayName!);

        Map<String, dynamic> userInMap = {
          "email": userDetails.email,
          "name": userDetails.displayName,
          "images": userDetails.photoURL,
          "Id": userDetails.uid,
          "Points": "0",
        };

        await DatabaseMethods().addUserInfo(userInMap, userDetails.uid);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    }
  }
}
