// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:hybrid_gift/bottom_nav_bar.dart';
import 'package:hybrid_gift/screens/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => bottom_nav_bar(context, 0)),
      ],
      child: MaterialApp(
        title: _title,
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHome(),
        },
      ),
    );
  }
}