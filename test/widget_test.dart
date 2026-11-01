import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sayak/main.dart';
import 'package:sayak/screens/login_screen.dart';
import 'package:sayak/screens/register_screen.dart';
import 'package:sayak/screens/splash_screen.dart';

void main() {
  testWidgets('Sayak App smoke test - Splash, Login, and Register flows', (WidgetTester tester) async {
    // Set standard mobile size screen (412 x 915)
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(const SayakApp());
    expect(find.byType(SplashScreen), findsOneWidget);

    // Fast-forward past splash timer (3 seconds)
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();

    // Verify LoginScreen is now shown
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Sign In to Shop'), findsOneWidget);

    // Navigate to Register screen
    final signUpLink = find.text('Create an Account');
    expect(signUpLink, findsOneWidget);
    await tester.ensureVisible(signUpLink);
    await tester.pumpAndSettle();

    await tester.tap(signUpLink);
    await tester.pumpAndSettle();

    // Verify RegisterScreen is now shown
    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Create Sayak Account'), findsOneWidget);
  });
}
