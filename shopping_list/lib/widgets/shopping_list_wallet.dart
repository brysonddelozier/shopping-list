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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade700,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.black,
          ),
          const SizedBox(width: 12),
          Text(
            'Wallet: \$${widget.wallet.cash.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}