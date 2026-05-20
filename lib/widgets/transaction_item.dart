import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../main.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  String formatMoney(double amount) {
    return '${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} Ar';
  }

  static const _catIcons = {
    'Nourriture': Icons.restaurant_rounded,
    'Transport': Icons.directions_car_rounded,
    'Loyer': Icons.home_rounded,
    'Factures': Icons.receipt_long_rounded,
    'Shopping': Icons.shopping_bag_rounded,
    'Loisirs': Icons.sports_esports_rounded,
    'Santé': Icons.favorite_rounded,
    'Salaire': Icons.work_rounded,
    'Freelance': Icons.laptop_rounded,
    'Cadeau': Icons.card_giftcard_rounded,
    'Remboursement': Icons.refresh_rounded,
    'Autre': Icons.more_horiz_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final isRevenue = transaction.type == 'revenue';
    final color = isRevenue ? AppColors.income : AppColors.expense;
    final icon = _catIcons[transaction.category] ?? Icons.category_rounded;

    return Dismissible(
      key: Key(transaction.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.expenseLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: AppColors.expense),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onLongPress: () => _confirmDelete(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.description,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          transaction.category,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isRevenue ? '+' : '-'} ${formatMoney(transaction.amount)}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Supprimer ?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('Cette transaction sera supprimée définitivement.',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            child: const Text('Supprimer',
                style: TextStyle(color: AppColors.expense)),
          ),
        ],
      ),
    );
  }
}