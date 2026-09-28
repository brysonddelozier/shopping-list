import 'package:flutter/material.dart';

typedef ShoppingListAddedCallback = Function(String nameValue, double priceValue);

class ShoppingListDialog extends StatefulWidget {
  const ShoppingListDialog({
    super.key,
    required this.onListAdded,
  });

  final ShoppingListAddedCallback onListAdded;

  @override
  State<ShoppingListDialog> createState() => _ShoppingListDialogState();
}

class _ShoppingListDialogState extends State<ShoppingListDialog> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green.shade300, foregroundColor: Colors.black);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red.shade300, foregroundColor: Colors.black);

  String? _priceError;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveGrocery() {
    final String name = _nameController.text.trim();
    final String priceText = _priceController.text.trim();

    final double? parsedPrice = double.tryParse(priceText);

    if (parsedPrice == null) {
      setState(() {
        _priceError = 'Please enter a number, like 2.99';
      });
      return;
    }

    if (parsedPrice < 0) {
      setState(() {
        _priceError = 'Price cannot be negative';
      });
      return;
    }

    widget.onListAdded(name, parsedPrice, );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Grocery To Add'),
      content: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Grocery Name',
              hintText: 'For example: Apples',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              labelText: 'Price',
              hintText: 'For example: 2.99',
              errorText: _priceError,
            ),
            onChanged: (_) {
              if (_priceError != null) {
                setState(() {
                  _priceError = null;
                });
              }
            },
            onSubmitted: (_) => _saveGrocery(),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          key: const Key('CancelButton'),
          style: noStyle,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const Key('OKButton'),
          style: yesStyle,
          onPressed: _saveGrocery,
          child: const Text('OK'),
        ),
      ],
    );
  }
}

