import 'package:flutter_test/flutter_test.dart';
import 'package:ngo_donation_ui/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const HelpBridgeApp());
    expect(find.text('HelpBridge'), findsOneWidget);
  });
}
