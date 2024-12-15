import 'package:go_router/go_router.dart';
import 'package:kanban_board/screens/home_screen.dart';

class AppRouter {
  static final router = GoRouter(initialLocation: "/home", routes: [
    GoRoute(
      path: "/home",
      name: "/home",
      builder: (context, state) => const HomeScreen(),
    )
  ]);
}
