import 'package:flutter/material.dart';
import 'package:hybrid_gift/src/widgets.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StyledButton(
        onPressed: () {
          // widget.signOut();
        },
        child: const Text('Logout'),
      ),
    );
  }
}