import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_bottom_nav_bar_model.dart';
export 'custom_bottom_nav_bar_model.dart';

class CustomBottomNavBarWidget extends StatefulWidget {
  const CustomBottomNavBarWidget({
    super.key,
    String? activeTab,
  }) : this.activeTab = activeTab ?? 'forecasts';

  final String activeTab;

  @override
  State<CustomBottomNavBarWidget> createState() =>
      _CustomBottomNavBarWidgetState();
}

class _CustomBottomNavBarWidgetState extends State<CustomBottomNavBarWidget> {
  late CustomBottomNavBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CustomBottomNavBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(
                  HomePageWidget.routeName,
                  extra: <String, dynamic>{
                    '__transition_info__': TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.fade,
                      duration: Duration(milliseconds: 0),
                    ),
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.bar_chart_rounded,
                      color: widget.activeTab == 'forecasts'
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).tertiaryText,
                      size: 24.0,
                    ),
                    Text(
                      'Прогнозы',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.roboto(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: widget.activeTab == 'forecasts'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).tertiaryText,
                            fontSize: 10.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                    ),
                  ].divide(SizedBox(
                      height:
                          FlutterFlowTheme.of(context).designToken.spacing.xs)),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(
                  SubscribesWidget.routeName,
                  extra: <String, dynamic>{
                    '__transition_info__': TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.fade,
                      duration: Duration(milliseconds: 0),
                    ),
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      FFIcons.kcrown,
                      color: widget.activeTab == 'subscriptions'
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).tertiaryText,
                      size: 24.0,
                    ),
                    Text(
                      'Подписки',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.roboto(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: widget.activeTab == 'subscriptions'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).tertiaryText,
                            fontSize: 10.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                    ),
                  ].divide(SizedBox(
                      height:
                          FlutterFlowTheme.of(context).designToken.spacing.xs)),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(
                  LivePageWidget.routeName,
                  extra: <String, dynamic>{
                    '__transition_info__': TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.fade,
                      duration: Duration(milliseconds: 0),
                    ),
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      FFIcons.kradar,
                      color: widget.activeTab == 'live'
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).tertiaryText,
                      size: 24.0,
                    ),
                    Text(
                      'Live',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.roboto(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: widget.activeTab == 'live'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).tertiaryText,
                            fontSize: 10.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                    ),
                  ].divide(SizedBox(
                      height:
                          FlutterFlowTheme.of(context).designToken.spacing.xs)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.school_rounded,
                    color: widget.activeTab == 'education'
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).tertiaryText,
                    size: 24.0,
                  ),
                  Text(
                    'Обучение',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.roboto(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                          color: widget.activeTab == 'education'
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).tertiaryText,
                          fontSize: 10.0,
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                  ),
                ].divide(SizedBox(
                    height:
                        FlutterFlowTheme.of(context).designToken.spacing.xs)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    FFIcons.kframe,
                    color: widget.activeTab == 'profile'
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).tertiaryText,
                    size: 24.0,
                  ),
                  Text(
                    'Профиль',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.roboto(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                          color: widget.activeTab == 'profile'
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).tertiaryText,
                          fontSize: 10.0,
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                  ),
                ].divide(SizedBox(
                    height:
                        FlutterFlowTheme.of(context).designToken.spacing.xs)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
