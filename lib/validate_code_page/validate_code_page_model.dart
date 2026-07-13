import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'validate_code_page_widget.dart' show ValidateCodePageWidget;
import 'package:flutter/material.dart';

class ValidateCodePageModel extends FlutterFlowModel<ValidateCodePageWidget> {
  ///  Local state fields for this page.

  bool canResend = false;

  String otpState = 'idle';

  ///  State fields for stateful widgets in this page.

  // State field(s) for OTP_Code widget.
  TextEditingController? oTPCode;
  FocusNode? oTPCodeFocusNode;
  String? Function(BuildContext, String?)? oTPCodeValidator;
  // Stores action output result for [Custom Action - verifyOtpEmail] action in OTP_Code widget.
  bool? isVerified;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 120000;
  int timerMilliseconds = 120000;
  String timerValue = StopWatchTimer.getDisplayTime(
    120000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  @override
  void initState(BuildContext context) {
    oTPCode = TextEditingController();
  }

  @override
  void dispose() {
    oTPCodeFocusNode?.dispose();
    oTPCode?.dispose();

    timerController.dispose();
  }
}
