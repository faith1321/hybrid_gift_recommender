import 'package:flutter/material.dart';
import 'package:hybrid_gift/src/application_state.dart';
import 'package:hybrid_gift/src/pages.dart';
import 'package:hybrid_gift/src/widgets.dart';
import 'package:provider/provider.dart';

class UserPage extends Pages {
  const UserPage({Key? key, required this.anotherSignOut})
      : super(key: key, signOut: anotherSignOut);

  final void Function() anotherSignOut;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    Future<dynamic> _user = _loadUser(context);
    return Center(
        child: FutureBuilder<dynamic>(
            future: _user,
            builder: (context, snapshot) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.account_circle_rounded),
                          //   iconSize: 100,
                          //   color: Theme.of(context).hintColor,
                          // ),
                          context.select(
                            (ApplicationState _state) =>
                                _state.getProfileImage(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(20.0),
                                right: Radius.circular(20.0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                    "Hi ${snapshot.data}, nice to see you here."),
                              ],
                            ),
                          ),
                        ],
                      ),
                      StyledButton(
                        onPressed: () {
                          widget.signOut();
                        },
                        child: const Text('Logout'),
                      ),
                    ])));
  }

  Future<dynamic> _loadUser(BuildContext context) async {
    final dynamic _user = await context
        .select((ApplicationState _state) => _state.getCurrentDisplayName());
    return _user;
  }
}
