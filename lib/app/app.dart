import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_game/routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LF Brawler',
      getPages: AppPages.pages,
      initialRoute: AppPages.initial,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
    );
  }
}
