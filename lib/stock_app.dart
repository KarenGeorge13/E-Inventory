import 'package:flutter/material.dart';
import 'package:stock/router.dart';
import 'package:stock/ui/default_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'E-Inventory',
      theme: defaultTheme,
      routes: routes,
    );
  }
}