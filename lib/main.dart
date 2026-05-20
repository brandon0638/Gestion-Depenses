import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/transaction_store.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionStore(),
      child: MaterialApp(
        title: 'Mon Budget',
        locale: const Locale('fr', 'FR'),
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.accent,
          scaffoldBackgroundColor: AppColors.bg,
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.dark(
            primary: AppColors.accent,
            secondary: AppColors.accentLight,
            surface: AppColors.card,
            background: AppColors.bg,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.bg,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          cardTheme: CardThemeData(
            color: AppColors.card,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: AppColors.textMuted,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
          ),
        ),
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppColors {
  static const bg = Color(0xFF0F1117);
  static const surface = Color(0xFF1A1D27);
  static const card = Color(0xFF1E2130);
  static const cardAlt = Color(0xFF242838);

  static const accent = Color(0xFF00D4AA);
  static const accentLight = Color(0xFF00F0C0);
  static const accentDark = Color(0xFF00A882);

  static const income = Color(0xFF00D4AA);
  static const expense = Color(0xFFFF6B6B);
  static const incomeLight = Color(0x1A00D4AA);
  static const expenseLight = Color(0x1AFF6B6B);

  static const textPrimary = Color(0xFFE8EAF0);
  static const textSecondary = Color(0xFF9EA3B8);
  static const textMuted = Color(0xFF5A5F7A);

  static const divider = Color(0xFF252840);
}