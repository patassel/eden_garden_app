// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:eden_garden/view/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {
  // Build our app and trigger a frame.
  //await tester.pumpWidget(const MaterialApp(home: HomeScreen(from: "test"),));

  late HomeScreen home;



  setUp(() {
    home = const HomeScreen(from: "test");


  });


  test("initial View values are correct", () {

    expect(home.from, "test");

  });


}
