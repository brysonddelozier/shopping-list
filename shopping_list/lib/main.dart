// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:shopping_list/objects/grocery.dart';
import 'package:shopping_list/objects/wallet.dart';
import 'package:shopping_list/widgets/shopping_list_groceries.dart';
import 'package:shopping_list/widgets/shopping_list_dialog.dart';
import 'package:shopping_list/widgets/shopping_list_wallet.dart';


class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<Grocery> groceries = [];
  final _grocerySet = <Grocery>{};
  final Wallet wallet = Wallet(cash: 100.00);

  void _handleListChanged(Grocery grocery, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _grocerySet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      groceries.remove(grocery);
      if (!completed) {
        //print("Completing");
        _grocerySet.add(grocery);
        groceries.add(grocery);
      } else {
        //print("Making Undone");
        _grocerySet.remove(grocery);
        groceries.insert(0, grocery);
      }
    });
  }

  void _handleDeleteGrocery(Grocery grocery) {
    setState(() {
      //print("Deleting grocery");
      groceries.remove(grocery);
      _grocerySet.remove(grocery);
      wallet.cash += grocery.price;
    });
  }

  void _handleCashOutGrocery() {
    setState(() {
      groceries.clear();
      _grocerySet.clear();
    });
  }

  void _handleNewGrocery(String groceryText, double groceryPrice) {
    if (groceryPrice > wallet.cash) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You don't have enough cash in your wallet."),
        ),
      );
      return;
    }

    if (groceryText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid grocery name."),
        ),
      );
      return;
    }

    setState(() {
      final Grocery grocery = Grocery(
        name: groceryText,
        price: groceryPrice,
      );

      groceries.insert(0, grocery);
      wallet.cash -= grocery.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Column(
        children: [
          ShoppingListWallet(
            wallet: wallet,
            onDeleteGrocery: _handleDeleteGrocery,
            onListAdded: _handleNewGrocery,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: groceries.map((Grocery grocery) {
                return ShoppingListGrocery(
                  grocery: grocery,
                  completed: _grocerySet.contains(grocery),
                  onListChanged: _handleListChanged,
                  onDeleteGrocery: _handleDeleteGrocery,
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.yellow.shade100,
                    side: const BorderSide(
                      color: Colors.yellow,
                      width: 0.8,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return ShoppingListDialog(onListAdded: _handleNewGrocery);
                      }
                    );
                  },
                  child: const Text('Add a Grocery'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.green.shade100,
                    side: const BorderSide(
                      color: Colors.green,
                      width: 0.8,
                    ),
                  ),
                  onPressed: () {
                    if (groceries.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('The list is already empty.'),
                        ),
                      );
                      return;
                    }
                    _handleCashOutGrocery();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You checked out. The list was cleared.'),
                      ),
                    );
                  },
                  child: const Text('Checkout')
                ),
              ]
            ),
          ),
        ],
      ),
      
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Shopping List',
    home: ShoppingList(),
  ));
}
