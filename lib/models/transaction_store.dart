import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'transaction.dart';

class TransactionStore extends ChangeNotifier {
  List<Transaction> _transactions = [];
  
  List<Transaction> get transactions => _transactions;
  
  double get balance {
    double total = 0;
    for (var t in _transactions) {
      if (t.type == 'revenue') {
        total += t.amount;
      } else {
        total -= t.amount;
      }
    }
    return total;
  }
  
  double get totalRevenue {
    double total = 0;
    for (var t in _transactions) {
      if (t.type == 'revenue') total += t.amount;
    }
    return total;
  }
  
  double get totalExpense {
    double total = 0;
    for (var t in _transactions) {
      if (t.type == 'expense') total += t.amount;
    }
    return total;
  }
  
  List<Transaction> getTransactionsByMonth(int year, int month) {
    return _transactions.where((t) {
      return t.date.year == year && t.date.month == month;
    }).toList();
  }
  
  Map<String, double> getExpensesByCategory() {
    Map<String, double> map = {};
    for (var t in _transactions) {
      if (t.type == 'expense') {
        map[t.category] = (map[t.category] ?? 0) + t.amount;
      }
    }
    return map;
  }
  
  TransactionStore() {
    loadTransactions();
  }
  
  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    saveTransactions();
    notifyListeners();
  }
  
  void deleteTransaction(int id) {
    _transactions.removeWhere((t) => t.id == id);
    saveTransactions();
    notifyListeners();
  }
  
  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('transactions');
    if (data != null) {
      List<dynamic> list = json.decode(data);
      _transactions = list.map((item) => Transaction.fromJson(item)).toList();
      notifyListeners();
    }
  }
  
  Future<void> saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(_transactions.map((t) => t.toJson()).toList());
    await prefs.setString('transactions', data);
  }
}