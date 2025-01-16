import 'package:blog_creator/Provider/Loaderprovider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/components/ComponentButton.dart';
import 'package:blog_creator/controller/DataController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blog_creator/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

class MockLoaderProvider extends Mock implements LoaderProvider {}

class MockReviewProvider extends Mock implements ReviewProvider {}

class MockDataController extends Mock implements DataController {}

void main() {
  group('HomePage', () {
    testWidgets('builds correctly', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MockLoaderProvider()),
            ChangeNotifierProvider(create: (_) => MockReviewProvider()),
          ],
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNWidgets(3));
      expect(find.byType(ComponentButton), findsNWidgets(5));
    });

    testWidgets('renders suggested topics correctly', (tester) async {
      final mockDataController = MockDataController();
      when(mockDataController.fetchSuggestedTopics()).thenAnswer((_) async => ['Topic 1', 'Topic 2', 'Topic 3']);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MockLoaderProvider()),
            ChangeNotifierProvider(create: (_) => MockReviewProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return HomePage();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Topic 1'), findsOneWidget);
      expect(find.text('Topic 2'), findsOneWidget);
      expect(find.text('Topic 3'), findsOneWidget);
    });

    testWidgets('fetches subdomain correctly', (tester) async {
      final mockDataController = MockDataController();
      when(mockDataController.fetchTitleData( '')).thenAnswer((_) async => ['Topic 1', 'Topic 2', 'Topic 3']);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MockLoaderProvider()),
            ChangeNotifierProvider(create: (_) => MockReviewProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return HomePage();
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ComponentButton).first);
      await tester.pump();

      verify(mockDataController.fetchTitleData('')).called(1);
    });

  });
}