import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mon_pfapp/app/mon_pf_app.dart';

Future<void> pumpMonPfApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const MyApp());
}

void main() {
  testWidgets('starts on the mockup-inspired login screen', (tester) async {
    await pumpMonPfApp(tester);

    expect(find.text('Mon PF App'), findsOneWidget);
    expect(find.text('Se connecter'), findsWidgets);
    expect(find.text('mode demo actif'), findsOneWidget);
    expect(find.text('Creer un compte'), findsOneWidget);
  });

  testWidgets('demo login opens the client home screen', (tester) async {
    await pumpMonPfApp(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.text('Bonjour, Yassmine'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Plats populaires'), findsOneWidget);
  });

  testWidgets('registration stays client-only and hides role selector', (
    tester,
  ) async {
    await pumpMonPfApp(tester);

    await tester.ensureVisible(find.text('Creer un compte'));
    await tester.tap(find.text('Creer un compte'));
    await tester.pumpAndSettle();

    expect(find.text('Inscription client'), findsOneWidget);
    expect(find.text('Rôle'), findsNothing);
    expect(find.text('Admin'), findsNothing);
    expect(find.text('Livreur'), findsNothing);
  });

  testWidgets('client can open menu, cart, and tracking flow', (tester) async {
    await pumpMonPfApp(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    await tester.tap(find.text('Voir tout').first);
    await tester.pumpAndSettle();
    expect(find.text('Menu du restaurant'), findsOneWidget);

    await tester.tap(find.text('Panier'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mon Panier'), findsOneWidget);

    await tester.tap(find.textContaining('Passer la commande'));
    await tester.pump(const Duration(milliseconds: 650));
    expect(find.text('Suivi de livraison'), findsOneWidget);
    expect(find.text('Etapes de la commande'), findsOneWidget);
  });

  testWidgets('demo spaces are reachable from home', (tester) async {
    await pumpMonPfApp(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    await tester.dragFrom(const Offset(200, 720), const Offset(0, -720));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Livreur'));
    await tester.pumpAndSettle();
    expect(find.text('Disponible pour livraison'), findsOneWidget);

    await tester.tap(find.byTooltip('Retour'));
    await tester.pumpAndSettle();

    await tester.dragFrom(const Offset(200, 720), const Offset(0, -720));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Admin'));
    await tester.pumpAndSettle();
    expect(find.text('Administration'), findsOneWidget);
  });
}
