import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frivia/pages/game_page.dart';
import 'package:frivia/pages/home_page.dart';
import 'package:frivia/services/WebService.dart';
import 'package:get_it/get_it.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await _configForWindows();
  }
  GetIt.instance.registerSingleton<WebService>(WebService());
  runApp(const MyApp());
}

_configForWindows() async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: Size(400, 700),
    maximumSize: Size(400, 700),
    center: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setResizable(false); // Disable resizing
    await windowManager.setMinimizable(true); // Allow minimizing
    await windowManager.setMaximizable(false); // Disable maximize
    await windowManager.show();
    await windowManager.focus();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frivia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: "AJ-Kunheing-13",
      ),
      home: HomePage(),
    );
  }
}
