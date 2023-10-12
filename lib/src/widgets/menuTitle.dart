import 'package:flutter/material.dart';

class MenuTitle extends StatelessWidget {

  final String title;

  MenuTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.subtitle1
    );
  }
}