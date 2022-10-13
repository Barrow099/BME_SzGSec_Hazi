import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/Pages/root_page.dart';


final counterStateProvider = StateProvider<int>((ref) {
  return 0;
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: buildThemeData,
        home: const RootPage(),
    );
  }

  ThemeData get buildThemeData {
    return ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w300)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(128)),
              textStyle: TextStyle(fontSize: 24),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              disabledBackgroundColor: Color.fromARGB(255, 117, 191, 245)
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        )
      );
  }


}


