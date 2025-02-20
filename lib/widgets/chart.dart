// include flutter package: material dart
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

import './bar_chart.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get transactionChartData {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    }).reversed.toList();
  }

  double get totalExpenditure {
    return transactionChartData.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: transactionChartData.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: BarChart(
                  data['day'],
                  data['amount'],
                  totalExpenditure == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalExpenditure),
            );
          }).toList(),
        ),
      ),
    );
  }
}
