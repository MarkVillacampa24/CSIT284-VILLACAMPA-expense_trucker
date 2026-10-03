import 'package:flutter/material.dart';
import 'expense.dart';
import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];

  void _openAddExpense() async {
    final newExpense = await showModalBottomSheet<Expense>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const NewExpense(),
    );

    if (newExpense == null) return;

    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(
                expenseIndex,
                expense,
              );
            });
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.food:
        return Icons.restaurant;
      case Category.travel:
        return Icons.directions_car;
      case Category.shopping:
        return Icons.shopping_bag;
      case Category.bills:
        return Icons.receipt_long;
      case Category.other:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _registeredExpenses.isEmpty
          ? Center(
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 70,
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'No expenses yet',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Start tracking your expenses '
                        'by adding your first expense.',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: _openAddExpense,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Expense'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 90,
              ),
              itemCount: _registeredExpenses.length,
              itemBuilder: (context, index) {
                final expense = _registeredExpenses[index];

                return Dismissible(
                  key: ValueKey(expense),
                  onDismissed: (_) {
                    _removeExpense(expense);
                  },
                  background: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),

                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      leading: CircleAvatar(
                        child: Icon(
                          _getCategoryIcon(
                            expense.category,
                          ),
                        ),
                      ),

                      title: Text(
                        expense.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        '${expense.category.name.toUpperCase()} • '
                        '${expense.date.day}/'
                        '${expense.date.month}/'
                        '${expense.date.year}',
                      ),

                      trailing: Text(
                        '₱${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpense,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}