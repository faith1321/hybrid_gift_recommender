import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/src/authentication.dart';

class ApplicationState extends ChangeNotifier {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    _auth.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  // GET UID
  String? getCurrentUID() {
    return _auth.currentUser?.uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return _auth.currentUser;
  }

  Widget getProfileImage() {
    String? img = _auth.currentUser?.photoURL;

    if (img != null) {
      return Image.network(img, height: 100, width: 100);
    } else {
      return const Icon(Icons.account_circle, size: 100);
    }
  }

  void signOut() {
    _auth.signOut();
  }
}
