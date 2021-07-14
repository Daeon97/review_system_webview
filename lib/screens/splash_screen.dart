import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;
import '../utils/shared_prefs.dart' as shared_prefs;

class SplashScreen extends StatefulWidget {
  const SplashScreen(this._isJustInitApp, {Key? key}) : super(key: key);
  final bool _isJustInitApp;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget._isJustInitApp
            ? const Image(
                width: constants.logoImageSize,
                height: constants.logoImageSize,
                image: AssetImage(
                  'assets/logo.png',
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    width: constants.logoImageSize,
                    height: constants.logoImageSize,
                    image: AssetImage(
                      'assets/logo.png',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32.0,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          constants.baseColor,
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                        shared_prefs.firstOpen(false);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
