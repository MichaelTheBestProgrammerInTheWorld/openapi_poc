import 'package:flutter_test/flutter_test.dart';
import 'package:openapi_poc/main.dart';

void main() {
  testWidgets('OpenAPI POC app renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify title and main elements are present
    expect(find.text('OpenAPI Generator POC'), findsOneWidget);
    expect(find.text('Clean Architecture Flow'), findsOneWidget);
    expect(find.text('Execute OpenAPI GET /users/{id}'), findsOneWidget);
  });
}
