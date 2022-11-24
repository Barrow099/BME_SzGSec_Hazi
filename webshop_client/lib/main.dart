import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webshop_client/Pages/root_page.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  //=========================================
  // THIS IS STRICTLY FOR DEV PURPOSES ONLY!!
  // fixes issue an issue where android does
  // not trusts self signed certificate
  HttpOverrides.global = MyHttpOverrides();
  //=========================================

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
              textStyle: const TextStyle(fontSize: 24),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              disabledBackgroundColor: const Color.fromARGB(255, 117, 191, 245)
          )
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(128),
            ),

          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            gapPadding: 4,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

        )
      );
  }


}


