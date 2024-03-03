import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:starttech_qr/helpers/dialog.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? aktifKullaniciId;

  //sign up with email and password
  Future<bool?> signUpWithEmailandPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseAuth.instance.currentUser!;
      User? user = FirebaseAuth.instance.currentUser;
      await FirestoreService().addUserToFirestore(
        uid: user!.uid,
        email: user.email.toString(),
        name: name,
        phoneNumber: user.phoneNumber.toString(),
        photoUrl: user.photoURL.toString() == 'null'
            ? 'https://api.dicebear.com/7.x/adventurer-neutral/png?seed=${user.uid}'
            : user.photoURL.toString(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      DialogHelper.getCustomErrorDialog(
        subtitle: e.message.toString(),
      );
      return false;
    }
  }

  //sign in with email and password
  Future<bool?> signInWithEmailandPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      DialogHelper.getCustomErrorDialog(
        subtitle: e.message.toString(),
      );
      return false;
    }
  }

  Future<bool?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
    await FirebaseAuth.instance.currentUser!.reload();

    User? user = FirebaseAuth.instance.currentUser;
    await FirestoreService().addUserToFirestore(
      uid: user!.uid,
      email: user.email.toString(),
      name: user.displayName.toString(),
      phoneNumber: user.phoneNumber.toString(),
      photoUrl: user.photoURL.toString(),
    );

    return authResult.user != null;
  }

  //appleIleGiris
  Future<bool?> signInWithApple() async {
    final appleResult = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oAuthCredential = OAuthProvider("apple.com").credential(
      idToken: appleResult.identityToken,
      accessToken: appleResult.authorizationCode,
    );

    final authResult =
        await _firebaseAuth.signInWithCredential(oAuthCredential);

    User? user = FirebaseAuth.instance.currentUser;

    await FirestoreService().addUserToFirestore(
      uid: user!.uid,
      email: user.email.toString(),
      name: user.displayName.toString(),
      phoneNumber: user.phoneNumber.toString(),
      photoUrl: user.photoURL.toString(),
    );

    return authResult.user != null;
  }

  // sign in with github
  Future<bool?> signInWithGithub() async {
    // Create a new provider
    GithubAuthProvider githubProvider = GithubAuthProvider();

    await _firebaseAuth.signInWithPopup(githubProvider);

    await FirebaseAuth.instance.currentUser!.reload();

    User? user = FirebaseAuth.instance.currentUser;
    await FirestoreService().addUserToFirestore(
      uid: user!.uid,
      email: user.email.toString(),
      name: user.displayName.toString(),
      phoneNumber: user.phoneNumber.toString(),
      photoUrl: user.photoURL.toString(),
    );

    return _firebaseAuth.currentUser != null;
  }

  Future<void> sendVerifyEmail() async {
    debugPrint(_firebaseAuth.currentUser!.email);
    try {
      await _firebaseAuth.currentUser!.sendEmailVerification();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> resetEmail(String eposta) async {
    await _firebaseAuth.sendPasswordResetEmail(email: eposta);
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
