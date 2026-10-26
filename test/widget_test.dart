import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('TourNestApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(cost TourNestApp());
    expect(find.text('TourNest'), findsWidgets);
  });
}
