import 'package:abctimer/stop_watch.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ABCTimer());
}

class ABCTimer extends StatelessWidget {
  const ABCTimer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ABC Timer",
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        primaryColor: Colors.grey.shade500,
        textTheme: Typography.blackCupertino,
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(),
      ),
      home: const StopWatch(),
    );
  }
}
