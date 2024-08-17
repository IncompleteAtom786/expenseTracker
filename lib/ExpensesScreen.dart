import 'package:expense_tracker_app/Widgets/Chart.dart';
import 'package:expense_tracker_app/Widgets/ExpensesListWidget.dart';
import 'package:expense_tracker_app/Widgets/ModelOverlayWidget.dart';
import 'package:flutter/material.dart';

import 'Models/ExpensesModel.dart';

class ExpensesScreen extends StatefulWidget
{
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState()
  {
    return _ExpensesScreenState();
  }
}

class _ExpensesScreenState extends State<ExpensesScreen>
{
  final List<ExpensesModel> _registeredExpenses = [
    ExpensesModel(
        title: "Flutter Course",
        amount: 19.34,
        date: DateTime.now(),
        category: Category.work),

    ExpensesModel(
        title: "Cinema",
        amount: 10.4,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  void _openAddExpenseOverlay()
  {
    showModalBottomSheet(
      useSafeArea: true,
        context: context,
        builder: (ctx) => ModelOverlayWidget(onAddExpenseFunc: _addExpense),
      isScrollControlled: true
    );
  }

  void _addExpense(ExpensesModel expensesModel)
  {
    setState(()
    {
      _registeredExpenses.add(expensesModel);
    });
  }

  void _removeExpense(ExpensesModel expensesModel)
  {
    final expenseModelIndex = _registeredExpenses.indexOf(expensesModel);
    setState(()
    {
      _registeredExpenses.remove(expensesModel);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Expense Deleted"),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
  label: "Undo ?",
  onPressed: ()
      {
        setState(()
        {
          _registeredExpenses.insert(expenseModelIndex, expensesModel);
        });
      }
    ),
    ),);
  }

  @override
  Widget build(BuildContext context)
  {
    final width = MediaQuery.of(context).size.width;
    MediaQuery.of(context).size.height;

    Widget mainContent = const Center(
      child: Text("No expenses found! Start adding some...."),
    );

    if(_registeredExpenses.isNotEmpty)
      {
        mainContent = ExpensesListWidget(expenses: _registeredExpenses, onRemoveExpenseFunc: _removeExpense);
      }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add)
          )
        ],
      ),
      body: width < 600 ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent)
        ],
      ) : Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(child: mainContent)
        ],
      )
    );
  }
}
