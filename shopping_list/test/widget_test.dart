// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopping_list/main.dart';
import 'package:shopping_list/objects/grocery.dart';
import 'package:shopping_list/objects/wallet.dart';
import 'package:shopping_list/widgets/shopping_list_dialog.dart';
import 'package:shopping_list/widgets/shopping_list_groceries.dart';
import 'package:shopping_list/widgets/shopping_list_wallet.dart';

void main() {
  test('Item abbreviation should be first letter', () {
    const grocery = Grocery(name: "add more groceries", price: 0.00);
    expect(grocery.abbrev(), "a");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ShoppingListGrocery has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ShoppingListGrocery(
                grocery: const Grocery(name: "test", price: 0.00),
                completed: true,
                onListChanged: (Grocery grocery, bool completed) {},
                onDeleteGrocery: (Grocery grocery) {}))));
    final textFinder = find.text('test \$0.00');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('ShoppingListGrocery has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ShoppingListGrocery(
                grocery: const Grocery(name: "test", price: 0.00),
                completed: true,
                onListChanged: (Grocery grocery, bool completed) {},
                onDeleteGrocery: (Grocery grocery) {}))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.black54);
    expect(ctext.data, "t");
  });

  testWidgets('Default ShoppingList is empty', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    final listGroceryFinder = find.byType(ShoppingListGrocery);

    expect(listGroceryFinder, findsNothing);
  });

  testWidgets('Clicking and Typing adds item to ShoppingList', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byKey(const Key('AddGroceryButton')));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("grapes"), findsNothing);

    await tester.enterText(find.byKey(const Key('NameTextField')), 'grapes');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('PriceTextField')), '1.00');
    await tester.pump();
    expect(find.text("grapes"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("grapes \$1.00"), findsOneWidget);

    final listItemFinder = find.byType(ShoppingListGrocery);

    expect(listItemFinder, findsOneWidget);
  });

/*
  // One to test the tap and press actions on the items?
  testWidgets('Tap and Press actions on groceries work', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    await tester.tap(find.byKey(const Key("AddGroceryButton")));
    await tester.pump();
    await tester.enterText(find.byKey(const Key("NameTextField")), 'bananas');
    await tester.pump();
    await tester.enterText(find.byKey(const Key("PriceTextField")), '1.00');
    await tester.pump();
    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();

    await tester.tap(find.byKey(const Key("AddGroceryButton")));
    await tester.pump();
    expect(find.text('bananas \$1.00'), findsOneWidget);

    await tester.tap(find.byKey(const Key("LTKeybananas")));
    await tester.pump();

    await tester.longPress(find.byKey(const Key("LTKeybananas")));
    await tester.pump();
    expect(find.text('bananas \$1.00'), findsNothing);
  });
*/

  testWidgets('Checkout clears all groceries', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    await tester.tap(find.byKey(const Key("AddGroceryButton")));
    await tester.pump();
    await tester.enterText(find.byKey(const Key("NameTextField")), 'strawberries');
    await tester.pump();
    await tester.enterText(find.byKey(const Key("PriceTextField")), '1.00');
    await tester.pump();
    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();

    await tester.tap(find.byKey(const Key("AddGroceryButton")));
    await tester.pump();
    await tester.enterText(find.byKey(const Key("NameTextField")), 'kiwi');
    await tester.pump();
    await tester.enterText(find.byKey(const Key("PriceTextField")), '1.00');
    await tester.pump();
    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();

    await tester.tap(find.byKey(const Key("CheckoutButton")));
    await tester.pump();

    expect(find.text('strawberries \$1.00'), findsNothing);
    expect(find.text('kiwi \$1.00'), findsNothing);
  });

  testWidgets('Checkout does not change wallet cash', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShoppingList()));

    await tester.tap(find.byKey(const Key("AddGroceryButton")));
    await tester.pump();
    await tester.enterText(find.byKey(const Key("NameTextField")), 'carrots');
    await tester.pump();
    await tester.enterText(find.byKey(const Key("PriceTextField")), '1.00');
    await tester.pump();
    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();

    expect(find.text('Wallet: \$99.00'), findsOneWidget);

    await tester.tap(find.byKey(const Key("CheckoutButton")));
    await tester.pump();

    expect(find.text('Wallet: \$99.00'), findsOneWidget);
  });
}
