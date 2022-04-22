import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/src/screens/order/order_book.dart';
import 'package:hybrid_gift/authentication.dart';

class ApplicationState extends ChangeNotifier {
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot>? _userBookSubscription;
  List<UserOrder> _userOrders = [];
  List<UserOrder> get userOrders => _userOrders;

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
        _userBookSubscription = FirebaseFirestore.instance
            .collection('users')
            .where("displayName", isEqualTo: _auth.currentUser?.displayName)
            .snapshots()
            .listen((snapshot) {
          _userOrders = [];
          for (final document in snapshot.docs) {
            _userOrders.add(
              UserOrder(
                orderedProduct: document.data()['order'] as String,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loginState = ApplicationLoginState.loggedOut;
        _userOrders = [];
        _userBookSubscription?.cancel();
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
      // var credential = await _auth.createUserWithEmailAndPassword(
      //     email: email, password: password);
      // await credential.user!.updateDisplayName(displayName);
      await createUserWithEmail(email, password, displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> createUserWithEmail(
      String email, String password, String displayName) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await updateDisplayName(displayName, result.user);
    await result.user!.updateDisplayName(displayName);
  }

  Future updateDisplayName(String displayName, User? user) async {
    await user?.updateDisplayName(displayName);
    await user?.reload();
  }

  // GET UID
  String? getCurrentUID() {
    return _auth.currentUser?.uid;
  }

  String? getCurrentDisplayName() {
    return _auth.currentUser?.displayName;
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

  Future<CameraDescription> loadCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    return firstCamera;
  }

  /// Appends a new order to Firebase Firestore and
  /// updates the changes to the local list.
  Future<void> addOrderToUser(String order) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('users').add(
      <String, dynamic>{
        'displayName': _auth.currentUser?.displayName,
        'order': order,
      },
      //   .collection('users')
      //   .doc(_auth.currentUser?.displayName)
      //   .set(
      // <String, dynamic>{
      //   'order': order,
      // },
      // SetOptions(merge: true),
    );
  }

  void clearUserOrders() {
    _userOrders = [];
    FirebaseFirestore.instance
        .collection("users")
        .where("displayName", isEqualTo: _auth.currentUser?.displayName)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
