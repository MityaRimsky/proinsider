import '/components/custom_bottom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'subscribes_model.dart';
export 'subscribes_model.dart';

class SubscribesWidget extends StatefulWidget {
  const SubscribesWidget({super.key});

  static String routeName = 'Subscribes';
  static String routePath = '/subscribes';

  @override
  State<SubscribesWidget> createState() => _SubscribesWidgetState();
}

class _SubscribesWidgetState extends State<SubscribesWidget> {
  late SubscribesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscribesModel());
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [],
                ),
              ),
              wrapWithModel(
                model: _model.customBottomNavBarModel,
                updateCallback: () => safeSetState(() {}),
                child: CustomBottomNavBarWidget(
                  activeTab: 'subscriptions',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
