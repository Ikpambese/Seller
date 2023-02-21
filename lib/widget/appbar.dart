// ignore_for_file: empty_constructor_bodies

import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  String? title;
  MyAppBar({this.bottom, this.title});

  @override
  Size get preferredSize {
    return bottom == null
        ? Size(56, AppBar().preferredSize.height)
        : Size(56, 80 + AppBar().preferredSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.amber[900]),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        title!,
        style: const TextStyle(
            fontSize: 45, fontFamily: 'Signatra', letterSpacing: 3),
      ),

      // automaticallyImplyLeading: false,
    );
  }
}
