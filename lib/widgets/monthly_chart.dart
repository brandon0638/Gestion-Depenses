import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction_store.dart';
import '../main.dart';

class MonthlyChart extends StatefulWidget {
  const MonthlyChart({super.key});

  @override
  State<MonthlyChart> createState() => _MonthlyChartState();
}

class _MonthlyChartState extends State<MonthlyChart> {
  int _touchedIndex = -1;

  String _monthLabel(DateTime date) {
    const abbr = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
                   'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return abbr[date.month - 1];
  }

  String formatMoney(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}k';
    return amount.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<TransactionStore>(context);

    final now = DateTime.now();
    final months = <DateTime>[];
    final revenues = <double>[];
    final expenses = <double>[];

    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      months.add(date);

      double rev = 0, exp = 0;
      for (var t in store.transactions) {
        if (t.date.year == date.year && t.date.month == date.month) {
          if (t.type == 'revenue') rev += t.amount;
          else exp += t.amount;
        }
      }
      revenues.add(rev);
      expenses.add(exp);
    }

    double maxVal = 0;
    for (var v in [...revenues, ...expenses]) if (v > maxVal) maxVal = v;
    if (maxVal == 0) maxVal = 100;

    final barGroups = List.generate(months.length, (i) {
      final isTouched = i == _touchedIndex;
      return BarChartGroupData(
        x: i,
        groupVertically: false,
        barRods: [
          BarChartRodData(
            toY: revenues[i],
            color: isTouched ? AppColors.accentLight : AppColors.income,
            width: 10,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxVal,
              color: AppColors.divider,
            ),
          ),
          BarChartRodData(
            toY: expenses[i],
            color: isTouched ? const Color(0xFFFF9999) : AppColors.expense,
            width: 10,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxVal,
              color: AppColors.divider,
            ),
          ),
        ],
        barsSpace: 4,
      );
    });

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
              const Text('Aperçu mensuel',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              Row(
                children: [
                  _Legend(color: AppColors.income, label: 'Revenus'),
                  const SizedBox(width: 16),
                  _Legend(color: AppColors.expense, label: 'Dépenses'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: maxVal * 1.2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => AppColors.surface,
                    tooltipRoundedRadius: 12,
                    tooltipPadding: const EdgeInsets.all(10),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = rodIndex == 0 ? 'Revenus' : 'Dépenses';
                      final color = rodIndex == 0 ? AppColors.income : AppColors.expense;
                      return BarTooltipItem(
                        '$label\n',
                        TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                            text: '${formatMoney(rod.toY)} Ar',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.spot == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = response.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        return Text(
                          formatMoney(value),
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 10),
                        );
                      },
                      interval: maxVal / 4,
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= months.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _monthLabel(months[idx]),
                            style: TextStyle(
                              color: idx == months.length - 1
                                  ? AppColors.accent
                                  : AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: idx == months.length - 1
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVal / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
                groupsSpace: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}