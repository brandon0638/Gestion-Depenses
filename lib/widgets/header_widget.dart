import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_store.dart';
import '../main.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  String formatMoney(double amount) {
    final isNeg = amount < 0;
    final abs = amount.abs().toInt();
    final formatted = abs.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]} ',
    );
    return '${isNeg ? '-' : ''}$formatted Ar';
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<TransactionStore>(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance_wallet_outlined,
                        color: AppColors.accent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mon Budget',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      const Text('Tableau de bord',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: store.balance >= 0
                      ? AppColors.incomeLight
                      : AppColors.expenseLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  store.balance >= 0 ? 'Positif ↑' : 'Négatif ↓',
                  style: TextStyle(
                    color: store.balance >= 0 ? AppColors.income : AppColors.expense,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Solde total
          Text('Solde total',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(
            formatMoney(store.balance),
            style: TextStyle(
              color: store.balance >= 0 ? AppColors.textPrimary : AppColors.expense,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 24),

          // Barres income/expense
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Revenus',
                  amount: store.totalRevenue,
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.income,
                  bgColor: AppColors.incomeLight,
                  formatMoney: formatMoney,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'Dépenses',
                  amount: store.totalExpense,
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.expense,
                  bgColor: AppColors.expenseLight,
                  formatMoney: formatMoney,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String Function(double) formatMoney;

  const _StatTile({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: color.withOpacity(0.8), fontSize: 11)),
                const SizedBox(height: 2),
                Text(formatMoney(amount),
                    style: TextStyle(
                        color: color, fontSize: 13, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}