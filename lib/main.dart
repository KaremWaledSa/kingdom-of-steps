import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

/// Entry point for Kingdom of Steps app
/// Initializes the app and sets up system UI
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for now)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF12121F),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Run the app
  runApp(const KingdomOfStepsApp());
}
