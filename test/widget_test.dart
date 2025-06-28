import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_mate/app.dart';
import 'package:lost_mate/main.dart';

void main() {
  testWidgets('Splash screen shows and then navigates to LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const LostMateApp());

    // Cek splash screen (misal cek ada logo, atau widget tertentu di splash)
    expect(find.byType(Image), findsOneWidget); // jika splash ada image logo
    // atau
    expect(find.text('Lost Mate'), findsNothing); // jika splash tidak ada teks

    // Tunggu 1 detik (durasi splash) + animasi selesai
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Cek apakah sekarang berada di LoginScreen (misal ada widget login yang bisa dicari)
    expect(find.text('Login'), findsOneWidget); // ganti sesuai label login screen kamu
  });
}
