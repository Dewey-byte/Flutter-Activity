import 'package:flutter_test/flutter_test.dart';
import 'package:registration_form/main.dart';

void main() {
  testWidgets('Registration screen shows required fields', (tester) async {
    await tester.pumpWidget(const RegistrationApp());

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Register'), findsWidgets);
  });
}
