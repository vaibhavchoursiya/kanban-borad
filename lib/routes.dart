import 'package:go_router/go_router.dart';
import 'package:kanban_board/screens/home_screen.dart';
import 'package:kanban_board/screens/task_panel.dart';

class AppRouter {
  static final router = GoRouter(initialLocation: "/home", routes: [
    GoRoute(
      path: "/home",
      name: "/home",
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: "/task_panel",
      name: "/task_panel",
      builder: (context, state) {
        Map m = state.extra as Map<String, String>;

        return TaskPanel(collectionName: m["collectionName"]);
      },
    )
  ]);
}
