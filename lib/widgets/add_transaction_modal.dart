import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../models/transaction_store.dart';
import '../main.dart';

class AddTransactionModal extends StatefulWidget {
  final String type;
  const AddTransactionModal({super.key, required this.type});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedCategory = '';

  final _revenueCategories = ['Salaire', 'Freelance', 'Cadeau', 'Remboursement', 'Autre'];
  final _expenseCategories = ['Nourriture', 'Transport', 'Loyer', 'Factures', 'Shopping', 'Loisirs', 'Santé', 'Autre'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.type == 'revenue' ? _revenueCategories[0] : _expenseCategories[0];
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  bool get _isRevenue => widget.type == 'revenue';
  Color get _color => _isRevenue ? AppColors.income : AppColors.expense;

  @override
  Widget build(BuildContext context) {
    final categories = _isRevenue ? _revenueCategories : _expenseCategories;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 8,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _isRevenue ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      color: _color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Ajouter ${_isRevenue ? 'un revenu' : 'une dépense'}',
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Amount
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _color.withOpacity(0.3)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                  color: _color, fontSize: 28, fontWeight: FontWeight.w800),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Montant (Ar)',
                labelStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                prefixIcon: Icon(Icons.attach_money_rounded, color: _color, size: 22),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text('Catégorie',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3)),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _color.withOpacity(0.2) : AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? _color : AppColors.divider,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? _color : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _descCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Description (optionnel)',
                labelStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                hintText: 'ex: Courses du mois',
                hintStyle: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountCtrl.text);
                if (amount != null && amount > 0) {
                  final store = Provider.of<TransactionStore>(context, listen: false);
                  store.addTransaction(Transaction(
                    id: DateTime.now().millisecondsSinceEpoch,
                    type: widget.type,
                    amount: amount,
                    category: _selectedCategory,
                    description: _descCtrl.text.isNotEmpty
                        ? _descCtrl.text
                        : '$_selectedCategory ${_isRevenue ? '(revenu)' : '(dépense)'}',
                    date: DateTime.now(),
                  ));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Ajouter',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}