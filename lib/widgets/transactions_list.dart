import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> currentTransactions;
  final Function deleteTransactionHandler;

  const TransactionsList(this.currentTransactions, this.deleteTransactionHandler);

  @override
  Widget build(BuildContext context) {
    return currentTransactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Container(
              width: double.infinity,
              child: Column(
                // Column: width & lenght fit content of child only
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No Expenses added yet !',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    // SizedBox: used as a seperator can used without child
                    height: 15,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    margin: EdgeInsets.only(left: 28.0),
                    child: Image.asset(
                      'assets/images/no_money.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            );
          })
        : ListView.builder(
            // render only Visible items, definte to have infinite height so must wrap it in a containner with specific height
            itemBuilder: (BuildContext context, int index) {
              // called by flutter
              return TransactionItem(currentTransactions[index], deleteTransactionHandler);
            },
            itemCount: currentTransactions.length,
          );
  }
}
