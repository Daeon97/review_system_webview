import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        onGenerateRoute: _routes,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
      );

  Route _routes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const SizedBox(
            width: 0.0,
            height: 0.0,
          ),
        );
    }
  }
}
