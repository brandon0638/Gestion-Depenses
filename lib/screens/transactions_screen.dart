import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/transaction_store.dart';
import '../widgets/transaction_item.dart';
import '../main.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  DateTime _currentDate = DateTime.now();
  Map<DateTime, List<Transaction>> _groupedTransactions = {};
  Set<DateTime> _expandedDays = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _groupTransactions();
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + delta, 1);
      _expandedDays.clear();
      _groupTransactions();
    });
  }

  void _groupTransactions() {
    final store = Provider.of<TransactionStore>(context, listen: false);
    final monthTransactions = store.transactions.where((t) {
      return t.date.year == _currentDate.year && t.date.month == _currentDate.month;
    }).toList();

    _groupedTransactions = {};
    for (var t in monthTransactions) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      _groupedTransactions.putIfAbsent(day, () => []).add(t);
    }
  }

  String _getMonthName(DateTime date) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String formatMoney(double amount) {
    final isNeg = amount < 0;
    final abs = amount.abs().toInt();
    final formatted = abs.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]} ',
    );
    return '${isNeg ? '-' : ''}$formatted Ar';
  }

  String _formatDayHeader(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return "Aujourd'hui • ${DateFormat('EEEE d MMMM', 'fr').format(date)}";
    }
    return DateFormat('EEEE d MMMM', 'fr').format(date);
  }

  double _getDayRevenue(List<Transaction> transactions) {
    return transactions.where((t) => t.type == 'revenue').fold(0.0, (sum, t) => sum + t.amount);
  }

  double _getDayExpense(List<Transaction> transactions) {
    return transactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
  }

  double _getDayBalance(List<Transaction> transactions) {
    return _getDayRevenue(transactions) - _getDayExpense(transactions);
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<TransactionStore>(context);
    
    final monthTransactions = store.transactions.where((t) {
      return t.date.year == _currentDate.year && t.date.month == _currentDate.month;
    }).toList();
    
    // Totaux du mois (pas cumulés depuis le début)
    final totalMonthRevenue = monthTransactions.where((t) => t.type == 'revenue').fold(0.0, (sum, t) => sum + t.amount);
    final totalMonthExpense = monthTransactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    final totalMonthBalance = totalMonthRevenue - totalMonthExpense;
    
    final daysCount = _groupedTransactions.keys.length;
    final double avgPerDay = daysCount > 0 ? totalMonthExpense / daysCount : 0.0;
    
    final sortedDays = _groupedTransactions.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Transactions'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Sélecteur de mois
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  _getMonthName(_currentDate),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
          ),
          
          // Stats mensuelles (totaux du mois uniquement)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent.withOpacity(0.15), AppColors.card],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildMonthStat('Revenus du mois', totalMonthRevenue, AppColors.income, Icons.trending_up),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMonthStat('Dépenses du mois', totalMonthExpense, AppColors.expense, Icons.trending_down),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMonthStat('Solde du mois', totalMonthBalance, 
                        totalMonthBalance >= 0 ? AppColors.income : AppColors.expense, 
                        Icons.account_balance_wallet),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMonthStat('Moy/jour', avgPerDay, AppColors.textSecondary, Icons.calendar_today),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Liste des jours avec solde quotidien
          Expanded(
            child: _groupedTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: AppColors.textMuted),
                        const SizedBox(height: 16),
                        Text('Aucune transaction pour ce mois',
                            style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: sortedDays.length,
                    itemBuilder: (context, index) {
                      final day = sortedDays[index];
                      final dayTransactions = _groupedTransactions[day]!;
                      final dayRevenue = _getDayRevenue(dayTransactions);
                      final dayExpense = _getDayExpense(dayTransactions);
                      final dayBalance = _getDayBalance(dayTransactions);
                      final isExpanded = _expandedDays.contains(day);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            // En-tête du jour (cliquable)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isExpanded) {
                                      _expandedDays.remove(day);
                                    } else {
                                      _expandedDays.add(day);
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppColors.accent.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style: const TextStyle(
                                              color: AppColors.accent,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _formatDayHeader(day),
                                              style: const TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${dayTransactions.length} transaction${dayTransactions.length > 1 ? 's' : ''}',
                                              style: const TextStyle(
                                                color: AppColors.textMuted,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          if (dayRevenue > 0)
                                            Text(
                                              '+${formatMoney(dayRevenue)}',
                                              style: const TextStyle(
                                                color: AppColors.income,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          if (dayExpense > 0)
                                            Text(
                                              '-${formatMoney(dayExpense)}',
                                              style: const TextStyle(
                                                color: AppColors.expense,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          const SizedBox(height: 2),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: dayBalance >= 0 
                                                  ? AppColors.income.withOpacity(0.15) 
                                                  : AppColors.expense.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Solde: ${formatMoney(dayBalance)}',
                                              style: TextStyle(
                                                color: dayBalance >= 0 ? AppColors.income : AppColors.expense,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        isExpanded ? Icons.expand_less : Icons.expand_more,
                                        color: AppColors.textMuted,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            // Transactions du jour (expandable)
                            if (isExpanded)
                              Column(
                                children: [
                                  const Divider(color: AppColors.divider, height: 1),
                                  ...dayTransactions.map((t) => TransactionItem(
                                    transaction: t,
                                    onDelete: () {
                                      store.deleteTransaction(t.id);
                                      _groupTransactions();
                                      setState(() {});
                                    },
                                  )),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMonthStat(String label, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: color.withOpacity(0.8), fontSize: 11)),
                Text(formatMoney(amount),
                    style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}