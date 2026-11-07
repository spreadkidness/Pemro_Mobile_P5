import 'package:flutter_test/flutter_test.dart';
import 'package:secure_http/main.dart';

void main() {
  testWidgets('Aplikasi Secure HTTP berhasil dibuat',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SecureHttpApp());

    expect(find.text('Keamanan Data & HTTP'), findsOneWidget);
  });
}
