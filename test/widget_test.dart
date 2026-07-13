import 'package:flutter_test/flutter_test.dart';

import 'package:crud_sqlite/main.dart';

void main() {
  testWidgets('App starts and shows Lista de Libros', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts up and displays the title.
    expect(find.text('Lista de Libros'), findsOneWidget);
  });
}
