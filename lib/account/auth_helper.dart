import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static GoogleSignInAccount? _account;

  GoogleSignInAccount get account => _account!;

  Future signIn() async {
    final currentAccount = await _googleSignIn.signIn();
    if (currentAccount == null) {
      return;
    }
    _account = currentAccount;

    final googleAuth = await currentAccount.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();
  }

  Future signOut() async {
    await _googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}