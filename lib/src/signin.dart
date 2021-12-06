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
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // final List<Widget> _widgetOptions = <Widget>[
  //   Column(
  //     children: <Widget>[
  //       Image.asset(
  //         'assets/logo.png',
  //         height: 200,
  //         fit: BoxFit.fitWidth,
  //       ),
  //       const Text(
  //         '',
  //         style: optionStyle,
  //       ),
  //     ],
  //   ),
  //   const Text(
  //     'Index 1: Sth',
  //     style: optionStyle,
  //   ),
  //   const Text(
  //     'Index 2: Sth 2.0',
  //     style: optionStyle,
  //   ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          // Center(
          //   child: _widgetOptions.elementAt(_selectedIndex),
          // ),
          const SizedBox(height: 8),
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
          // Consumer<ApplicationState>(
          //   builder: (context, appState, _) => Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       if (appState.loginState == ApplicationLoginState.loggedIn) ...[
          //         BottomNavigationBar(
          //           items: const <BottomNavigationBarItem>[
          //             BottomNavigationBarItem(
          //               icon: Icon(Icons.home),
          //               label: 'Home',
          //             ),
          //             BottomNavigationBarItem(
          //               icon: Icon(Icons.list_alt),
          //               label: 'Orders',
          //             ),
          //             BottomNavigationBarItem(
          //               icon: Icon(Icons.person),
          //               label: 'User',
          //             ),
          //           ],
          //           currentIndex: _selectedIndex,
          //           selectedItemColor: Colors.amber[800],
          //           onTap: _onItemTapped
          //         ),
          //       ],
          //     ],
          //   ),
          // ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.list_alt),
      //       label: 'Orders',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'User',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
