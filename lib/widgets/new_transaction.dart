import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransactionHandler;

  NewTransaction(this.addTransactionHandler);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  //String titleInput;
  //String amountInput;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTransactionHandler(
      // widget. access properties of the widget class, available only on Stateful classes
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    Navigator.of(context).pop(); // close BottomSheet when clicking done
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // Trigger to tell Flutter that stateful widget updated
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(2), //Card contain Margin not Padding
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  10), //Containner used because Card not contain Padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                //onChanged: (String value) => titleInput = value, //One line function
                controller: _titleController,
                onSubmitted: (_) =>
                    _submitData(), // _ mean i'll not use it, it's annonyomus function, On Pressing done from keyboard
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                //onChanged: (String value) => amountInput = value, //One line function
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    _submitData(), // _ mean i'll not use it, it's annonyomus function
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Text(
                      _selectedDate == null
                          ? 'No Date Added yet !'
                          : DateFormat.yMd().format(_selectedDate),
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    FlatButton(
                      child: Text('Choose Date'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _datePicker,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
