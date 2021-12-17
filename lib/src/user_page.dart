import 'package:flutter/material.dart';
import 'package:hybrid_gift/src/pages.dart';
import 'package:hybrid_gift/src/widgets.dart';

class UserPage extends Pages {
  const UserPage({Key? key, required this.anotherSignOut}) : super(key: key, signOut: anotherSignOut);

  final void Function() anotherSignOut;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StyledButton(
        onPressed: () {
          widget.signOut();
        },
        child: const Text('Logout'),
      ),
    );
  }
}
