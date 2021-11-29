import 'package:flutter/material.dart';
import 'package:hybrid_gift/src/application_state.dart';
import 'package:hybrid_gift/src/authentication.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _StatefulWidgetState();
}

class _StatefulWidgetState extends State<SignIn> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: (MediaQuery.of(context).size.height)/5),
          Image.asset(
            'assets/logo.png',
            height: 200,
            // fit: BoxFit.fitWidth,
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Authentication(
              email: appState.email,
              loginState: appState.loginState,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
            ),
          ),
        ],
      ),
    );
  }
}