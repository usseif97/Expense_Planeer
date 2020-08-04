import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionsValues {
    // get: function without given parameter just return value
    return List.generate(7, (index) {
      // Annonyomus Function
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSumforAWeekDay = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSumforAWeekDay += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSumforAWeekDay,
      };
    });
  }

  double get totalSpendinginAWeek {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      // fold: convert List to AnotherType(fold)
      // Annonymous function
      return sum + item['amount']; // return 0.0 after adding
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
          children: groupedTransactionsValues.map((eachDay) {
            return Flexible(
              // Flexible: like FlexBox in JS
              fit: FlexFit.tight,
              child: ChartBar(
                //Statelless Widget, have no logic only show the ChartBar
                label: eachDay['day'],
                amount: eachDay['amount'],
                amountPercentage: totalSpendinginAWeek == 0.0
                    ? 0.0
                    : (eachDay['amount'] as double) / totalSpendinginAWeek,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
