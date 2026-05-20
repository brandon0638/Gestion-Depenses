import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/action_buttons.dart';
import '../widgets/monthly_chart.dart';
import '../widgets/category_stats.dart';
import '../main.dart';
import 'transactions_screen.dart';
import 'statistics_screen.dart';
import 'export_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardContent(),
    TransactionsScreen(),
    StatisticsScreen(),
    ExportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            selectedItemColor: AppColors.accent,
            unselectedItemColor: AppColors.textMuted,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                activeIcon: Icon(Icons.dashboard_rounded),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.swap_vert_rounded),
                activeIcon: Icon(Icons.swap_vert_rounded),
                label: 'Transactions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.donut_large_rounded),
                activeIcon: Icon(Icons.donut_large_rounded),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.ios_share_rounded),
                activeIcon: Icon(Icons.ios_share_rounded),
                label: 'Export',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const HeaderWidget(),
                  const SizedBox(height: 16),
                  const ActionButtons(),
                  const SizedBox(height: 20),
                  const MonthlyChart(),
                  const SizedBox(height: 16),
                  const CategoryStats(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}