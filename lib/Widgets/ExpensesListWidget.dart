import 'package:expense_tracker_app/Widgets/ExpensesItemWidget.dart';
import 'package:flutter/material.dart';

import '../Models/ExpensesModel.dart';

class ExpensesListWidget extends StatelessWidget
{
  const ExpensesListWidget({super.key, required this.expenses, required this.onRemoveExpenseFunc});

  final List<ExpensesModel> expenses;
  final void Function(ExpensesModel expensesModel) onRemoveExpenseFunc;

  @override
  Widget build(BuildContext context)
  {
    return ListView.builder(itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        onDismissed: (direction)
          {
            onRemoveExpenseFunc(expenses[index]);
          },
          key: ValueKey(expenses[index]),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.66),
            margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal,
            ),
          ),
          child: ExpensesItemWidget(expenses[index])
      )
    );
  }
}
