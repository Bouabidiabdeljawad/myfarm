import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_farm/app/app_routes.dart';
import 'package:my_farm/app/app_providers.dart';
import 'package:my_farm/core/localization/app_localizations.dart';
import 'package:my_farm/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root application widget.
///
/// Wraps everything in a [ProviderScope] so Riverpod is available
/// across the whole feature tree.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'myFarm',
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // fallback
        Locale('fr'),
        Locale('ar'),
      ],
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
    );
  }
}
