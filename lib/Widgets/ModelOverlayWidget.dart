import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/Models/ExpensesModel.dart';

class ModelOverlayWidget extends StatefulWidget
{
  const ModelOverlayWidget({required this.onAddExpenseFunc, super.key});

  final void Function(ExpensesModel expensesModel) onAddExpenseFunc;

  @override
  State<ModelOverlayWidget> createState()
  {
    return _ModelOverlayWidget();
  }
}

class _ModelOverlayWidget extends State<ModelOverlayWidget>
{
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  void _presentDatePicker() async
  {
    final dateNow = DateTime.now();
    final firstDate = DateTime(dateNow.year - 2, dateNow.month, dateNow.day);
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate: dateNow
    );
    setState(()
    {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData()
  {
    final checkAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = (checkAmount == null || checkAmount <= 0);
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null)
    {

      if (Platform.isIOS)
      {
        showCupertinoDialog(context: context, builder: (ctx) =>
            CupertinoAlertDialog(
              title: const Text("Invalid Input!"),
              content: const Text("Please make sure a valid title, amount, "
                  "date and category was entered!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text("Okay")
                )
              ],
            ));
      }

      else
      {
        showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: const Text("Invalid Input!"),
                  content: const Text("Please make sure a valid title, amount, "
                      "date and category was entered!"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text("Okay")
                    )
                  ],
                ));
        return;
      }
    }
    widget.onAddExpenseFunc(ExpensesModel(title: _titleController.text, amount: checkAmount!, date: _selectedDate!, category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose()
  {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context)
  {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints)
      {
        // final minWidth = constraints.minWidth;
        // final maxWidth = constraints.maxWidth;
        // final minHeight = constraints.minHeight;
        // final maxHeight = constraints.maxHeight;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                        label: Text("Enter the Title")
                    ),
                    keyboardType: TextInputType.name,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          maxLength: 10,
                          decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text("Enter the Amount")
                          ),
                          keyboardType: TextInputType.number,

                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null ? 'No Date Selected' :
                            formatter.format(_selectedDate!)
                            ),
                            IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month)
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values.map((categoryItem) =>
                              DropdownMenuItem(value: categoryItem,
                                  child: Text(categoryItem.name.toUpperCase()))).toList(),
                          onChanged: (value)
                          {
                            if(value == null) return;
                            setState(()
                            {
                              _selectedCategory = value;
                            });
                          }
                      ),

                      const Spacer(),

                      TextButton(
                          onPressed: ()
                          {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")
                      ),

                      ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text("Save Expenses")
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
