import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction currentTransaction;
  final Function deleteTransactionHandler;

  TransactionItem(this.currentTransaction, this.deleteTransactionHandler);


  @override
  Widget build(BuildContext context) {
    return Card(
      // Can alternatevly use ListTile: Leading,Title,SubTitle,Trailing
      elevation: 5,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                width: 1.5,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Text(
              // Child of the Container
              '\$ ${currentTransaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  currentTransaction.title,
                  style: Theme.of(context).textTheme.body1,
                ),
                Text(
                  DateFormat.yMMMEd()
                      .add_jm()
                      .format(currentTransaction.date),
                  style: Theme.of(context).textTheme.body2,
                ),
              ],
            ),
          ),
          MediaQuery.of(context).size.width > 240
              ? Container(
                  margin: EdgeInsets.all(10),
                  child: IconButton(
                    icon: Icon(Icons.delete_forever),
                    color: Theme.of(context).errorColor,
                    onPressed: () =>
                        deleteTransactionHandler(currentTransaction.id),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(10),
                  child: FlatButton.icon(
                    icon: Icon(Icons.delete_forever),
                    label: Text('Delete'),
                    textColor: Theme.of(context).errorColor,
                    onPressed: () =>
                        deleteTransactionHandler(currentTransaction.id),
                  ),
                ),
        ],
      ),
    );
  }
}
