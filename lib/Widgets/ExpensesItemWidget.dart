import 'package:expense_tracker_app/Models/ExpensesModel.dart';
import 'package:flutter/material.dart';

class ExpensesItemWidget extends StatelessWidget
{
  const ExpensesItemWidget(this.expensesModel, {super.key});

  final ExpensesModel expensesModel;

  @override
  Widget build(BuildContext context)
  {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20,
          vertical: 16
        ),
        child: Column(
          children: [
            Text(expensesModel.title),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('\$${expensesModel.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expensesModel.category]),
                    const SizedBox(width: 8),
                    Text(expensesModel.formattedDate)
                  ],
                )
              ],
            )
          ],
        )
    ),
    );
  }
}
