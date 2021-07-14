import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../utils/constants.dart' as constants;

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InAppWebViewController? _inAppWebViewController;

  final InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  late PullToRefreshController _pullToRefreshController;
  bool _loadError = false;
  final _ErrorDetails _errorDetails =
      _ErrorDetails('An Error occurred. Please try again');
  String _url = constants.baseUrl;

  @override
  void initState() {
    super.initState();
    _pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: constants.baseColor,
      ),
      onRefresh: () async {
        _inAppWebViewController?.reload();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_inAppWebViewController != null &&
            await _inAppWebViewController!.canGoBack()) {
          _inAppWebViewController!.goBack();
          return false;
        } else {
          return await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text(
                    'Exit app',
                    style: TextStyle(
                      color: constants.baseColor,
                    ),
                  ),
                  content: const Text(
                    'Are you sure you want to exit?',
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'Yep',
                        style: TextStyle(
                          color: constants.baseColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Nope',
                        style: TextStyle(
                          color: constants.baseColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ),
              ) ??
              false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _loadError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        width: constants.imageSize,
                        height: constants.imageSize,
                        image: AssetImage('assets/error.png'),
                      ),
                      Text(
                        _errorDetails.message,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              constants.baseColor,
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                horizontal: 32.0,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(
                              () {
                                _loadError = false;
                              },
                            );
                            _inAppWebViewController?.reload();
                          },
                        ),
                      ),
                    ],
                  )
                : _webView(
                    context,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _webView(
    BuildContext context,
  ) =>
      InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(_url),
        ),
        initialOptions: _options,
        pullToRefreshController: _pullToRefreshController,
        onWebViewCreated: (controller) {
          _inAppWebViewController = controller;
        },
        androidOnPermissionRequest: (_, __, resources) async =>
            PermissionRequestResponse(
          resources: resources,
          action: PermissionRequestResponseAction.GRANT,
        ),
        onLoadStart: (_, uri) {
          _url = uri.toString();
          _pullToRefreshController.beginRefreshing();
          setState(
            () {
              _loadError = false;
            },
          );
        },
        onLoadStop: (_, uri) {
          _pullToRefreshController.endRefreshing();
        },
        onLoadError: (_, uri, ___, message) {
          setState(
            () {
              _loadError = true;
            },
          );
          _errorDetails.message =
              'An Error occurred. Please try again: $message';
        },
      );
}

class _ErrorDetails {
  String message;
  _ErrorDetails(this.message);
}