import 'package:flutter/material.dart';
import 'package:shopping_list/objects/grocery.dart';
import 'package:shopping_list/objects/wallet.dart';

typedef ShoppingListRemovedCallback = Function(Grocery grocery);
typedef ShoppingListAddedCallback = Function(String nameValue, double priceValue);

class ShoppingListWallet extends StatefulWidget {
  const ShoppingListWallet({
    super.key,
    required this.wallet,
    required this.onDeleteGrocery,
    required this.onListAdded,
  });

  final Wallet wallet;
  final ShoppingListRemovedCallback onDeleteGrocery;
  final ShoppingListAddedCallback onListAdded;

  @override
  State<ShoppingListWallet> createState() => _ShoppingListWalletState();
}

class _ShoppingListWalletState extends State<ShoppingListWallet> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: 380.0,
        height: 80.0,
        margin: const EdgeInsets.fromLTRB(16, 24, 16, 4),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.green.shade700),
            bottom: BorderSide(width: 1.0, color: Colors.green.shade700),
            left: BorderSide(width: 1.0, color: Colors.green.shade700),
            right: BorderSide(width: 1.0, color: Colors.green.shade700),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.black,
            ),
            const SizedBox(width: 10),
            Text(
              'Wallet: \$${widget.wallet.cash.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}