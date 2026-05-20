import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_store.dart';
import '../main.dart';

class CategoryStats extends StatelessWidget {
  const CategoryStats({super.key});

  String formatMoney(double amount) {
    return '${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} Ar';
  }

  static const _catColors = [
    Color(0xFF00D4AA),
    Color(0xFFFF6B6B),
    Color(0xFFF59E0B),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
  ];

  static const _catIcons = {
    'Nourriture': Icons.restaurant_rounded,
    'Transport': Icons.directions_car_rounded,
    'Loyer': Icons.home_rounded,
    'Factures': Icons.receipt_long_rounded,
    'Shopping': Icons.shopping_bag_rounded,
    'Loisirs': Icons.sports_esports_rounded,
    'Santé': Icons.favorite_rounded,
    'Autre': Icons.more_horiz_rounded,
    'Salaire': Icons.work_rounded,
    'Freelance': Icons.laptop_rounded,
    'Cadeau': Icons.card_giftcard_rounded,
    'Remboursement': Icons.refresh_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<TransactionStore>(context);
    final now = DateTime.now();

    final Map<String, double> catMap = {};
    for (var t in store.transactions) {
      if (t.type == 'expense' && t.date.year == now.year && t.date.month == now.month) {
        catMap[t.category] = (catMap[t.category] ?? 0) + t.amount;
      }
    }

    final entries = catMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top = entries.take(5).toList();
    final total = catMap.values.fold(0.0, (s, v) => s + v);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top catégories',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              Text('Ce mois',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          if (top.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Aucune dépense ce mois-ci',
                    style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            ...top.asMap().entries.map((e) {
              final idx = e.key;
              final entry = e.value;
              final pct = total > 0 ? entry.value / total : 0.0;
              final color = _catColors[idx % _catColors.length];
              final icon = _catIcons[entry.key] ?? Icons.category_rounded;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key,
                                  style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              Text(formatMoney(entry.value),
                                  style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    backgroundColor: AppColors.divider,
                                    valueColor: AlwaysStoppedAnimation<Color>(color),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${(pct * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                      color: AppColors.textMuted, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}