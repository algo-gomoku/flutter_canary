import 'package:flutter/material.dart';
import 'package:flutter_canary/routes.dart';

class NewLinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Spacer(),
          ListTile(
            title: Center(child: Text("Camera")),
            onTap: () => Navigator.of(context).pushNamed(CAMERA_PAGE),
          )
        ],
      ),
    );
  }
}
