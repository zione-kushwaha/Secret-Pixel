import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:v/view/about.dart';
import 'package:v/view/hide_message.dart';
import 'package:v/view/home_view.dart';
import 'package:v/view/setting.dart';

import 'view/hide_file.dart';
import 'view/reveal_message.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.transparent.withOpacity(0.5),
      overlayWidgetBuilder: (_) {
        return Center(
          child: SpinKitCubeGrid(
            color: Colors.white,
            size: 50.0,
          ),
        );
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Secret Pixel',
          theme: ThemeData(
            brightness: Brightness.dark,
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              labelStyle: TextStyle(color: Colors.white),
            ),
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: HomeView(),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return createRoute(HomeView());

              case '/hideMsg':
                return createRoute(HideMessage());
              case '/revealMsg':
                return createRoute(RevealMessage());

              case '/about':
                return createRoute(About());
              case '/setting':
                return createRoute(Setting());

              default:
                return createRoute(HomeView());
            }
          }),
    );
  }
}

// Routing Animation
PageRouteBuilder createRoute(Widget destination) {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return destination;
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      );
    },
  );
}
