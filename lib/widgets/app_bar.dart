import 'package:flutter/material.dart';

AppBar appBarWidget(BuildContext context) {
  double deviceHeight = MediaQuery.of(context).size.height;
  return AppBar(
    leading: SizedBox(),
    toolbarHeight: deviceHeight * 0.15,
    backgroundColor: ColorScheme.of(context).primary,
    centerTitle: true,
    title: Text(
      "Frivia",
      style: TextStyle(color: ColorScheme.of(context).onPrimary, fontSize: 40),
    ),
  );
}
