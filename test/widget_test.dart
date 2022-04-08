import 'package:flutter_test/flutter_test.dart';
import 'package:hybrid_gift/main.dart';
import 'package:hybrid_gift/models/products.dart';
import 'package:hybrid_gift/recommender_system/agent.dart';

void main() {
  testWidgets('Basic rendering', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that our counter starts at 0.
    // expect(find.text('Firebase Meetup'), findsOneWidget);
    // expect(find.text('January 1st'), findsNothing);
  });

  test("Agent working", () {
    Agent agent = Agent();
    String product = products[0].id;
    expect(agent.predict(product), isNot(null));
  });
}
