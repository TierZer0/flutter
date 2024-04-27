import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileMain extends ConsumerStatefulWidget {
  @override
  _UserProfileMainState createState() => _UserProfileMainState();
}

class _UserProfileMainState extends ConsumerState<UserProfileMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Profile Page'),
          ],
        ),
      ),
    );
  }
}
