import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/themes/app_theme.dart';
import 'core/widgets/main_navigation.dart';
import 'features/steps/providers/step_provider.dart';

/// Main App widget for Kingdom of Steps
/// Configures theming, localization, providers, and the app structure
class KingdomOfStepsApp extends StatelessWidget {
  const KingdomOfStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Step provider for direct sensor step tracking (simple, one permission)
        ChangeNotifierProvider(create: (_) => StepProvider()),
      ],
      child: MaterialApp(
        // App title
        title: 'Kingdom of Steps',

        // Disable debug banner
        debugShowCheckedModeBanner: false,

        // Theme configuration (dark theme)
        theme: AppTheme.darkTheme,

        // Localization configuration
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // Supported locales (Arabic primary, English secondary)
        supportedLocales: const [
          Locale('ar'), // Arabic
          Locale('en'), // English
        ],

        // Default locale (Arabic)
        locale: const Locale('ar'),

        // Home screen with navigation
        home: const MainNavigation(),
      ),
    );
  }
}
