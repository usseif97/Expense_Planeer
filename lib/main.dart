import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transactions_list.dart';
import './widgets/chart.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); // prevent LandScape mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp(
            title: 'Expenses Planner',
            theme: CupertinoThemeData(
              primaryColor: Colors.green,
              primaryContrastingColor: Colors.white,
            ),
            home: MyHomePage(),
          )
        : MaterialApp(
            title: 'Expenses Planner',
            theme: ThemeData(
              primarySwatch: Colors.green,
              errorColor: Colors.red,
              appBarTheme: AppBarTheme(
                // AppBar Theme
                textTheme: TextTheme(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              textTheme: TextTheme(
                headline: TextStyle(
                  fontSize: 72.0,
                  fontWeight: FontWeight.bold,
                ),
                title: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ),
                body1: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
                body2: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
                  color: Colors.grey,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactionsList = [
    Transaction(
      id: 'A1',
      title: 'New Shoes',
      amount: 99.9,
      date: DateTime.now(),
    ),
    Transaction(
      id: 'B2',
      title: 'New Shirts',
      amount: 58.9,
      date: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeLifeCycleState(AppLifecycleState state) {} //"For App LifeCycle"

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _transactionsList.where((eachTransaction) {
      // iterate on all list till condition verfied
      // Annonyomus function
      return eachTransaction.date.isAfter(
        // like if Statment
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(
      String transactionTitle, double transactionAmount, DateTime chosenTime) {
    final newTrans = Transaction(
      title: transactionTitle,
      amount: transactionAmount,
      date: chosenTime,
      id: DateTime.now().toString(),
    );
    setState(() {
      // TO Rebuild
      _transactionsList.add(newTrans);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionsList.removeWhere((eachTransaction) {
        // iterate on all list till condition verfied
        // Annonyomus function
        return eachTransaction.id == id;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addTransaction), // NewTransaction Widget
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expenses Planner'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Expenses Planner'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
  }

  List<Widget> _buildBody(AppBar appbar) {
    // WidgetBuilder
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize
                    .height - // height of appBar, // height of StatusBar
                MediaQuery.of(context).padding.top) *
            0.3,
        child: Chart(
          _recentTransactions,
        ),
      ),
      Container(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize
                    .height - // height of appBar, // height of StatusBar
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionsList(
          _transactionsList,
          _deleteTransaction,
        ), //Statelless Widget, have no logic only show the current List of Transactions
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // re-build is called on SetState & MediaQuery
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appbar = _buildAppBar();
    final pageBody = SafeArea(
      // Safe Area: postion widgets on Available Postions away from reserved areas
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ..._buildBody(appbar), //... Spread Operator
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
          )
        : Scaffold(
            //AppBar Stored in variable
            appBar: appbar,
            //Body
            body: pageBody,
            //FloatingActionButton
            //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.attach_money),
                    splashColor: Theme.of(context).primaryColorLight,
                    elevation: 10,
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}

// ...[] 'Spread Operator' return elements of the list and arrange them next to each others
// Key used to keep the keey of the state of Stateful Widget