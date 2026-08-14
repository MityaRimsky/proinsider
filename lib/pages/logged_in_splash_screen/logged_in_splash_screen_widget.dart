import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'logged_in_splash_screen_model.dart';
export 'logged_in_splash_screen_model.dart';

class LoggedInSplashScreenWidget extends StatefulWidget {
  const LoggedInSplashScreenWidget({super.key});

  static String routeName = 'LoggedInSplashScreen';
  static String routePath = '/loggedInSplashScreen';

  @override
  State<LoggedInSplashScreenWidget> createState() =>
      _LoggedInSplashScreenWidgetState();
}

class _LoggedInSplashScreenWidgetState
    extends State<LoggedInSplashScreenWidget> {
  late LoggedInSplashScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoggedInSplashScreenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 5000,
        ),
      );
      _model.getOpenedPushData = await actions.getOpenedPushData();

      context.goNamed(
        HomePageWidget.routeName,
        extra: <String, dynamic>{
          '__transition_info__': TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
            duration: Duration(milliseconds: 0),
          ),
        },
      );
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Lottie.asset(
                'assets/jsons/Frame_1000001594.json',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.contain,
                repeat: false,
                animate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
