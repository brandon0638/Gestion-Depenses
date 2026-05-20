import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction_store.dart';
import '../main.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  String formatMoney(double amount) {
    return '${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} Ar';
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<TransactionStore>(context);
    final expensesByCategory = store.getExpensesByCategory();
    final totalExpense = store.totalExpense;
    
    final List<MapEntry<String, double>> sortedEntries = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final List<Color> colors = [
      const Color(0xFF00D4AA), const Color(0xFFFF6B6B), const Color(0xFFF59E0B),
      const Color(0xFF3B82F6), const Color(0xFF8B5CF6), const Color(0xFFEC4899),
      const Color(0xFF14B8A6), const Color(0xFFF97316), const Color(0xFF6366F1),
    ];
    
    final pieSections = <PieChartSectionData>[];
    for (int i = 0; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      final percentage = totalExpense > 0 ? (entry.value / totalExpense * 100) : 0;
      pieSections.add(
        PieChartSectionData(
          value: entry.value,
          title: '${percentage.toStringAsFixed(1)}%',
          color: colors[i % colors.length],
          radius: 100,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Statistiques'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  const Text('Répartition des dépenses',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: pieSections.isEmpty
                        ? Center(child: Text('Aucune dépense enregistrée', style: TextStyle(color: AppColors.textMuted)))
                        : PieChart(PieChartData(sections: pieSections)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total des dépenses',
                            style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                        Text(formatMoney(totalExpense),
                            style: TextStyle(color: AppColors.expense, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Détail par catégorie',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  ...sortedEntries.map((entry) {
                    final percentage = totalExpense > 0 ? (entry.value / totalExpense * 100) : 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 100, child: Text(entry.key,
                                  style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500))),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: percentage / 100,
                                    backgroundColor: AppColors.divider,
                                    color: AppColors.expense,
                                    minHeight: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(width: 100,
                                  child: Text(formatMoney(entry.value),
                                      style: TextStyle(color: AppColors.textPrimary),
                                      textAlign: TextAlign.right)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}