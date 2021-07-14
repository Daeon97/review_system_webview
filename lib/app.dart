import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/shared_prefs.dart' as shared_prefs;
import 'utils/constants.dart' as constants;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        onGenerateRoute: _routes,
        theme: ThemeData(
        primaryColor: constants.baseColor,
      ),
      );

  Route _routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<bool>(
            future: shared_prefs.isFirstOpen(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen(true);
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return const SplashScreen(false);
                  } else {
                    return const HomeScreen();
                  }
                } else {
                  return const SplashScreen(false);
                }
              }
            },
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Container(),
        );
    }
  }
}
