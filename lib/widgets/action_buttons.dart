import 'package:flutter/material.dart';
import 'add_transaction_modal.dart';
import '../main.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  void _openModal(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionModal(type: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionBtn(
            label: 'Revenu',
            icon: Icons.add_rounded,
            color: AppColors.income,
            bgColor: AppColors.incomeLight,
            onTap: () => _openModal(context, 'revenue'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionBtn(
            label: 'Dépense',
            icon: Icons.remove_rounded,
            color: AppColors.expense,
            bgColor: AppColors.expenseLight,
            onTap: () => _openModal(context, 'expense'),
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                    color: color, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}