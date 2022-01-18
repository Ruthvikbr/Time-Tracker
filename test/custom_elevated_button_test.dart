import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/components/customElevatedButton.dart';

void main() {
  testWidgets("Custom elevated button widget", (WidgetTester tester) async {
    var pressed = false;
    await tester.pumpWidget(MaterialApp(
      home: CustomElevatedButton(
        child: Text("Test"),
        borderRadius: 8.0,
        color: Colors.indigo,
        onPressed: () => pressed = true,
      ),
    ));

    //find one widget within custom component
    expect(find.byType(ElevatedButton), findsOneWidget);

    //find widget that hasn't been used in custom component
    expect(find.byType(Icon), findsNothing);

    //find widget with text in custom component
    expect(find.text("Test"), findsOneWidget);

    //test onPress callback in custom component
    final button = find.byType(ElevatedButton);
    await tester.tap(button);
    expect(pressed, true);
  });
}
