// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sportpro/main.dart';
import 'package:sportpro/try/try.dart';

void main() {
      testWidgets('Counter increments smoke test', (WidgetTester tester) async {
        // Build our app and trigger a frame.
        await tester.pumpWidget(MyApp(prefsService: MockPreferencesService() as PreferencesService));

        // Verify that our counter starts at 0.
        expect(find.text('0'), findsOneWidget);
        expect(find.text('1'), findsNothing);

        // Tap the '+' icon and trigger a frame.
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();

        // Verify that our counter has incremented.
        expect(find.text('0'), findsNothing);
        expect(find.text('1'), findsOneWidget);
      });
}
class MockPreferencesService implements PreferencesService {
  @override
  List<String> getCartItems() {
    // TODO: implement getCartItems
    throw UnimplementedError();
  }

  @override
  List<String> getFavoriteItems() {
    // TODO: implement getFavoriteItems
    throw UnimplementedError();
  }

  @override
  Future<void> saveCartItems(List<String> items) {
    // TODO: implement saveCartItems
    throw UnimplementedError();
  }

  @override
  Future<void> saveFavoriteItems(List<String> items) {
    // TODO: implement saveFavoriteItems
    throw UnimplementedError();
  }
    // Implement mock methods as needed
}
