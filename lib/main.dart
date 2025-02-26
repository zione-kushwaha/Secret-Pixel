import 'dart:io';
import '/core/local_database.dart';
import '/entry_point.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import '/theme/theme_color.dart';
import '/view/decode/decode_message.dart';
import '/view/encode/encode_message.dart';
import '/view/information_detail/about_page.dart';
import '/view/information_detail/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'providers/theme_provider.dart' as custom_theme;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase().initializeData();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(custom_theme.themeProvider);
    return ThemeProvider(
        initTheme: theme!,
        builder: (_, theme) {
          return GlobalLoaderOverlay(
            useDefaultLoading: false,
            overlayColor: Colors.transparent.withOpacity(0.5),
            overlayWidgetBuilder: (_) {
              return Center(
                child: SpinKitCubeGrid(
                  color: GetColor.backgroundColor(context),
                  size: 50.0,
                ),
              );
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              home: EntryPoint(),
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/':
                    return createRoute(EntryPoint());
                  case '/settings':
                    return createRoute(Setting());
                  case '/about':
                    return createRoute(About());
                  case '/encode':
                    final selectedImage = settings.arguments as File;
                    return createRoute(
                        EncodeMessage(selectedImage: selectedImage));
                  case '/decode':
                    final selectedImage = settings.arguments as File;
                    return createRoute(
                        DecodeMessage(selectedImage: selectedImage));
                  default:
                    return createRoute(Scaffold(
                      body: Center(
                        child: Text('No route defined for ${settings.name}'),
                      ),
                    ));
                }
              },
            ),
          );
        });
  }
}

// Routing Animation like IOS
PageRouteBuilder createRoute(Widget destination) {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return destination;
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
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
