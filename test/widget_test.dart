import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registration_hospital_user/main.dart';

void main() {
  testWidgets('Dashboard opens directly', (WidgetTester tester) async {
    await tester.pumpWidget(const HospitalApp());
    expect(find.text('Sehatin'), findsOneWidget);
    expect(find.text('Daftar Berobat'), findsOneWidget);
  });

  testWidgets('Dashboard fits a narrow phone screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HospitalApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Sehatin'), findsOneWidget);
  });

  testWidgets('Home clinic chip opens filtered doctor schedule', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HospitalApp());
    await tester.scrollUntilVisible(find.text('Poliklinik'), 300);
    await tester.tap(find.widgetWithText(ActionChip, 'Anak'));
    await tester.pumpAndSettle();

    expect(find.byType(SchedulePage), findsOneWidget);
    expect(find.text('dr. Maya Putri, Sp.A'), findsOneWidget);
    expect(find.text('1 dokter tersedia'), findsOneWidget);
  });

  testWidgets('Android back returns from schedule tab to home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HospitalApp());
    await tester.tap(find.text('Jadwal Dokter').last);
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Sehatin'), findsOneWidget);
    expect(find.text('Daftar Berobat'), findsOneWidget);
  });

  testWidgets('Profile button opens profile and back returns home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HospitalApp());
    await tester.tap(find.byTooltip('Profil pasien'));
    await tester.pumpAndSettle();
    expect(find.text('Profil Pasien'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Sehatin'), findsOneWidget);
  });

  testWidgets('Android back returns to the previous registration step', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HospitalApp());
    await tester.tap(find.text('Registrasi').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pasien Lama'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '000123');
    await tester.enterText(find.byType(TextFormField).at(1), '01/01/2000');
    await tester.tap(find.text('Lanjutkan'));
    await tester.pumpAndSettle();
    expect(find.text('Langkah 2 dari 4'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Langkah 1 dari 4'), findsOneWidget);
  });
}
