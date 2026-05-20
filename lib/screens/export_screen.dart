import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/transaction_store.dart';
import '../main.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  String formatMoney(double amount) {
    final isNeg = amount < 0;
    final abs = amount.abs().toInt();
    final formatted = abs.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]} ',
    );
    return '${isNeg ? '-' : ''}$formatted Ar';
  }

  String _generateReportText(TransactionStore store, DateTime selectedDate) {
    final date = DateTime.now();
    final dateStr = '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    
    // Filtrer les transactions du mois sélectionné
    final List<Transaction> monthTransactions = store.transactions.where((t) {
      return t.date.year == selectedDate.year && t.date.month == selectedDate.month;
    }).toList();
    
    // Totaux du mois
    final double totalMonthRevenue = monthTransactions.where((t) => t.type == 'revenue').fold(0.0, (sum, t) => sum + t.amount);
    final double totalMonthExpense = monthTransactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    final double totalMonthBalance = totalMonthRevenue - totalMonthExpense;
    
    // Grouper par jour
    final Map<DateTime, List<Transaction>> groupedByDay = {};
    for (var t in monthTransactions) {
      final DateTime day = DateTime(t.date.year, t.date.month, t.date.day);
      groupedByDay.putIfAbsent(day, () => []).add(t);
    }
    
    final List<DateTime> sortedDays = groupedByDay.keys.toList()..sort((a, b) => b.compareTo(a));
    
    // Calcul des dépenses par catégorie (pour le mois)
    final Map<String, double> expensesByCategory = {};
    for (var t in monthTransactions) {
      if (t.type == 'expense') {
        expensesByCategory[t.category] = (expensesByCategory[t.category] ?? 0) + t.amount;
      }
    }
    final List<MapEntry<String, double>> sortedTop = expensesByCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    
    const List<String> monthsNames = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    final String monthName = '${monthsNames[selectedDate.month - 1]} ${selectedDate.year}';
    
    String report = '═══════════════════════════════════════════\n';
    report += '           RAPPORT FINANCIER                   \n';
    report += '═══════════════════════════════════════════\n\n';
    report += 'Généré le $dateStr\n';
    report += 'Période : $monthName\n\n';
    report += '───────────── RÉSUMÉ DU MOIS ─────────────\n';
    report += 'Revenus du mois  : ${formatMoney(totalMonthRevenue)}\n';
    report += 'Dépenses du mois : ${formatMoney(totalMonthExpense)}\n';
    report += 'Solde du mois    : ${formatMoney(totalMonthBalance)}\n\n';
    report += '────── DÉTAIL PAR JOUR ──────\n\n';
    
    for (var day in sortedDays) {
      final List<Transaction> dayTransactions = groupedByDay[day]!;
      final double dayRevenue = dayTransactions.where((t) => t.type == 'revenue').fold(0.0, (sum, t) => sum + t.amount);
      final double dayExpense = dayTransactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
      final double dayBalance = dayRevenue - dayExpense;
      
      final DateFormat formatter = DateFormat('EEEE d MMMM yyyy', 'fr');
      final String dayStr = formatter.format(day);
      report += '📅 $dayStr\n';
      report += '   Revenus  : +${formatMoney(dayRevenue)}\n';
      report += '   Dépenses : -${formatMoney(dayExpense)}\n';
      report += '   Solde    : ${dayBalance >= 0 ? '+' : '-'}${formatMoney(dayBalance.abs())}\n';
      
      if (dayTransactions.isNotEmpty) {
        report += '   Transactions :\n';
        for (var t in dayTransactions) {
          final String sign = t.type == 'revenue' ? '+' : '-';
          report += '      • ${t.description} (${t.category}) : ${sign} ${formatMoney(t.amount)}\n';
        }
      }
      report += '\n';
    }
    
    report += '────── TOP DÉPENSES DU MOIS ──────\n';
    for (var entry in sortedTop.take(5)) {
      final double percentage = totalMonthExpense > 0 ? (entry.value / totalMonthExpense * 100) : 0;
      report += '${entry.key}: ${formatMoney(entry.value)} (${percentage.toStringAsFixed(1)}%)\n';
    }
    
    report += '\n═══════════════════════════════════════════\n';
    report += 'Rapport généré par Budget App\n';
    report += '═══════════════════════════════════════════\n';
    
    return report;
  }

  Future<void> _shareReport(BuildContext context, TransactionStore store) async {
    final DateTime selectedDate = DateTime.now();
    final String report = _generateReportText(store, selectedDate);
    final DateFormat formatter = DateFormat('MMMM yyyy', 'fr');
    await Share.share(report, subject: 'Rapport financier - ${formatter.format(selectedDate)}');
  }

  @override
  Widget build(BuildContext context) {
    final TransactionStore store = Provider.of<TransactionStore>(context);
    final List<Transaction> stats = store.transactions;
    final DateTime currentMonth = DateTime.now();
    
    // Filtrer les transactions du mois courant pour l'aperçu
    final List<Transaction> monthTransactions = stats.where((t) {
      return t.date.year == currentMonth.year && t.date.month == currentMonth.month;
    }).toList();
    
    final double totalMonthRevenue = monthTransactions.where((t) => t.type == 'revenue').fold(0.0, (sum, t) => sum + t.amount);
    final double totalMonthExpense = monthTransactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    final double totalMonthBalance = totalMonthRevenue - totalMonthExpense;
    
    final DateFormat formatter = DateFormat('MMMM yyyy', 'fr');
    
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Export Rapport'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accent, Color(0xFF00F0C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.share, size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text('Rapport financier',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(formatter.format(currentMonth),
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  _buildStatRow('Transactions du mois', monthTransactions.length.toString()),
                  _buildStatRow('Revenus du mois', formatMoney(totalMonthRevenue)),
                  _buildStatRow('Dépenses du mois', formatMoney(totalMonthExpense)),
                  _buildStatRow('Solde du mois', formatMoney(totalMonthBalance)),
                  const Divider(color: AppColors.divider, height: 24),
                  _buildStatRow('Total général', stats.length.toString()),
                  _buildStatRow('Revenus totaux', formatMoney(store.totalRevenue)),
                  _buildStatRow('Dépenses totales', formatMoney(store.totalExpense)),
                  _buildStatRow('Solde général', formatMoney(store.balance)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareReport(context, store),
                icon: const Icon(Icons.share),
                label: const Text('Partager le rapport du mois'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}