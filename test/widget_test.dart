import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setans/app.dart';

void main() {
  testWidgets('App renders calendar screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SetansApp()));
    await tester.pumpAndSettle();

    expect(find.text('Setans'), findsOneWidget);
    expect(find.text('Calendario'), findsOneWidget);
    expect(find.text('Registro'), findsOneWidget);
    expect(find.text('Vista general'), findsOneWidget);
  });
}
