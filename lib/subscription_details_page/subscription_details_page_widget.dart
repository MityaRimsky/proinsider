import '/backend/supabase/supabase.dart';
import '/components/gold_subscription_header_widget.dart';
import '/components/live_subscription_header_widget.dart';
import '/components/premium_subscription_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'subscription_details_page_model.dart';
export 'subscription_details_page_model.dart';

class SubscriptionDetailsPageWidget extends StatefulWidget {
  const SubscriptionDetailsPageWidget({
    super.key,
    required this.planId,
  });

  final int? planId;

  static String routeName = 'SubscriptionDetailsPage';
  static String routePath = '/subscriptionDetailsPage';

  @override
  State<SubscriptionDetailsPageWidget> createState() =>
      _SubscriptionDetailsPageWidgetState();
}

class _SubscriptionDetailsPageWidgetState
    extends State<SubscriptionDetailsPageWidget> {
  late SubscriptionDetailsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionDetailsPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SubscriptionPlanDetailsViewRow>>(
      future: SubscriptionPlanDetailsViewTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'plan_id',
          widget.planId,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<SubscriptionPlanDetailsViewRow>
            subscriptionDetailsPageSubscriptionPlanDetailsViewRowList =
            snapshot.data!;

        final subscriptionDetailsPageSubscriptionPlanDetailsViewRow =
            subscriptionDetailsPageSubscriptionPlanDetailsViewRowList.isNotEmpty
                ? subscriptionDetailsPageSubscriptionPlanDetailsViewRowList
                    .first
                : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Builder(
                          builder: (context) {
                            if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                    ?.name ==
                                'premium') {
                              return wrapWithModel(
                                model: _model.premiumSubscriptionHeaderModel,
                                updateCallback: () => safeSetState(() {}),
                                child: PremiumSubscriptionHeaderWidget(
                                  subtitle:
                                      subscriptionDetailsPageSubscriptionPlanDetailsViewRow!
                                          .subtitle!,
                                ),
                              );
                            } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                    ?.name ==
                                'gold') {
                              return wrapWithModel(
                                model: _model.goldSubscriptionHeaderModel,
                                updateCallback: () => safeSetState(() {}),
                                child: GoldSubscriptionHeaderWidget(
                                  subtitle:
                                      subscriptionDetailsPageSubscriptionPlanDetailsViewRow!
                                          .subtitle!,
                                ),
                              );
                            } else {
                              return wrapWithModel(
                                model: _model.liveSubscriptionHeaderModel,
                                updateCallback: () => safeSetState(() {}),
                                child: LiveSubscriptionHeaderWidget(
                                  subtitle:
                                      subscriptionDetailsPageSubscriptionPlanDetailsViewRow!
                                          .subtitle!,
                                ),
                              );
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 8.0, 16.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: () {
                                    if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                            ?.name ==
                                        'premium') {
                                      return Color(0x054E7BFF);
                                    } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                            ?.name ==
                                        'gold') {
                                      return Color(0x04FF7B00);
                                    } else {
                                      return Color(0x06FE2525);
                                    }
                                  }(),
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: () {
                                      if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                              ?.name ==
                                          'premium') {
                                        return Color(0x1A4E7BFF);
                                      } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                              ?.name ==
                                          'gold') {
                                        return Color(0x1AFF7B00);
                                      } else {
                                        return Color(0x19FE2525);
                                      }
                                    }(),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 16.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Text(
                                          'Выберите тариф',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                font: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 24.0, 24.0, 16.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .tertiaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    4.0, 4.0, 4.0, 4.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.selectedOption = 1;
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: () {
                                                          if ((subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                      ?.name ==
                                                                  'premium') &&
                                                              (_model.selectedOption ==
                                                                  1)) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .primary;
                                                          } else if ((subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                      ?.name ==
                                                                  'gold') &&
                                                              (_model.selectedOption ==
                                                                  1)) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary;
                                                          } else if ((subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                      ?.name ==
                                                                  'live') &&
                                                              (_model.selectedOption ==
                                                                  1)) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4;
                                                          } else {
                                                            return Colors
                                                                .transparent;
                                                          }
                                                        }(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    8.0,
                                                                    0.0,
                                                                    8.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    formatNumber(
                                                                      subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                          ?.option1Price,
                                                                      formatType:
                                                                          FormatType
                                                                              .custom,
                                                                      format:
                                                                          '',
                                                                      locale:
                                                                          '',
                                                                    ),
                                                                    '490',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .goldman(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: _model.selectedOption ==
                                                                                1
                                                                            ? FlutterFlowTheme.of(context).whiteText
                                                                            : FlutterFlowTheme.of(context).primaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .headlineMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  ' ₽',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .goldman(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: _model.selectedOption ==
                                                                                1
                                                                            ? FlutterFlowTheme.of(context).whiteText
                                                                            : FlutterFlowTheme.of(context).primaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .headlineMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                    ?.option1Name,
                                                                '1 прогноз',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontStyle,
                                                                    ),
                                                                    color: _model.selectedOption ==
                                                                            1
                                                                        ? Color(
                                                                            0xB2FFFFFF)
                                                                        : FlutterFlowTheme.of(context)
                                                                            .tertiaryText,
                                                                    fontSize:
                                                                        10.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              height: 4.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.selectedOption = 2;
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: () {
                                                          if ((subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                      ?.name ==
                                                                  'premium') &&
                                                              (_model.selectedOption ==
                                                                  2)) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .primary;
                                                          } else if ((subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                      ?.name ==
                                                                  'gold') &&
                                                              (_model.selectedOption ==
                                                                  2)) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary;
                                                          } else if ((subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                      ?.name ==
                                                                  'live') &&
                                                              (_model.selectedOption ==
                                                                  2)) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4;
                                                          } else {
                                                            return Colors
                                                                .transparent;
                                                          }
                                                        }(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    8.0,
                                                                    0.0,
                                                                    8.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  formatNumber(
                                                                    subscriptionDetailsPageSubscriptionPlanDetailsViewRow!
                                                                        .option2Price!,
                                                                    formatType:
                                                                        FormatType
                                                                            .custom,
                                                                    format: '',
                                                                    locale: '',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .goldman(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: _model.selectedOption ==
                                                                                2
                                                                            ? FlutterFlowTheme.of(context).whiteText
                                                                            : FlutterFlowTheme.of(context).primaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .headlineMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  ' ₽',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .goldman(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: _model.selectedOption ==
                                                                                2
                                                                            ? FlutterFlowTheme.of(context).whiteText
                                                                            : FlutterFlowTheme.of(context).primaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .headlineMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                    .option2Name,
                                                                '7 прогнозов',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontStyle,
                                                                    ),
                                                                    color: _model.selectedOption ==
                                                                            2
                                                                        ? Color(
                                                                            0xB2FFFFFF)
                                                                        : FlutterFlowTheme.of(context)
                                                                            .tertiaryText,
                                                                    fontSize:
                                                                        10.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              height: 4.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 8.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: () {
                                    if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                            .name ==
                                        'premium') {
                                      return Color(0x054E7BFF);
                                    } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                            .name ==
                                        'gold') {
                                      return Color(0x04FF7B00);
                                    } else {
                                      return Color(0x06FE2525);
                                    }
                                  }(),
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: () {
                                      if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                              .name ==
                                          'premium') {
                                        return Color(0x1A4E7BFF);
                                      } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                              .name ==
                                          'gold') {
                                        return Color(0x1AFF7B00);
                                      } else {
                                        return Color(0x19FE2525);
                                      }
                                    }(),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 16.0, 24.0, 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, -1.0),
                                        child: Text(
                                          'Преимущества премиум',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                font: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 32.0,
                                                  height: 32.0,
                                                  decoration: BoxDecoration(
                                                    color: () {
                                                      if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'premium') {
                                                        return Color(
                                                            0x324E7BFF);
                                                      } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'gold') {
                                                        return Color(
                                                            0x32FF7B00);
                                                      } else {
                                                        return Color(
                                                            0x32FE2525);
                                                      }
                                                    }(),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      FFIcons.kranking,
                                                      color: () {
                                                        if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'premium') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .primary;
                                                        } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'gold') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary;
                                                        } else {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .accent4;
                                                        }
                                                      }(),
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                          .feature1,
                                                      'Преимущества',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .roboto(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 32.0,
                                                  height: 32.0,
                                                  decoration: BoxDecoration(
                                                    color: () {
                                                      if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'premium') {
                                                        return Color(
                                                            0x324E7BFF);
                                                      } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'gold') {
                                                        return Color(
                                                            0x32FF7B00);
                                                      } else {
                                                        return Color(
                                                            0x32FE2525);
                                                      }
                                                    }(),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      FFIcons.kfavoriteChart,
                                                      color: () {
                                                        if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'premium') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .primary;
                                                        } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'gold') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary;
                                                        } else {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .accent4;
                                                        }
                                                      }(),
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                          .feature2,
                                                      'Преимущества',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .roboto(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 32.0,
                                                  height: 32.0,
                                                  decoration: BoxDecoration(
                                                    color: () {
                                                      if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'premium') {
                                                        return Color(
                                                            0x324E7BFF);
                                                      } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'gold') {
                                                        return Color(
                                                            0x32FF7B00);
                                                      } else {
                                                        return Color(
                                                            0x32FE2525);
                                                      }
                                                    }(),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      FFIcons.kflashLine,
                                                      color: () {
                                                        if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'premium') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .primary;
                                                        } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'gold') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary;
                                                        } else {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .accent4;
                                                        }
                                                      }(),
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                          .feature3,
                                                      'Преимущества',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .roboto(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 32.0,
                                                  height: 32.0,
                                                  decoration: BoxDecoration(
                                                    color: () {
                                                      if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'premium') {
                                                        return Color(
                                                            0x324E7BFF);
                                                      } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'gold') {
                                                        return Color(
                                                            0x32FF7B00);
                                                      } else {
                                                        return Color(
                                                            0x32FE2525);
                                                      }
                                                    }(),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      FFIcons.knotificationLine,
                                                      color: () {
                                                        if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'premium') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .primary;
                                                        } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'gold') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary;
                                                        } else {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .accent4;
                                                        }
                                                      }(),
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                          .feature4,
                                                      'Преимущества',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .roboto(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 32.0,
                                                  height: 32.0,
                                                  decoration: BoxDecoration(
                                                    color: () {
                                                      if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'premium') {
                                                        return Color(
                                                            0x324E7BFF);
                                                      } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                              .name ==
                                                          'gold') {
                                                        return Color(
                                                            0x32FF7B00);
                                                      } else {
                                                        return Color(
                                                            0x32FE2525);
                                                      }
                                                    }(),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      FFIcons.kclock,
                                                      color: () {
                                                        if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'premium') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .primary;
                                                        } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                                .name ==
                                                            'gold') {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary;
                                                        } else {
                                                          return FlutterFlowTheme
                                                                  .of(context)
                                                              .accent4;
                                                        }
                                                      }(),
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                                          .feature5,
                                                      'Преимущества',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .roboto(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                          ].divide(SizedBox(height: 8.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                  child: FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Подключить',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 48.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: () {
                        if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                .name ==
                            'premium') {
                          return FlutterFlowTheme.of(context).primary;
                        } else if (subscriptionDetailsPageSubscriptionPlanDetailsViewRow
                                .name ==
                            'gold') {
                          return FlutterFlowTheme.of(context).secondary;
                        } else {
                          return FlutterFlowTheme.of(context).accent4;
                        }
                      }(),
                      textStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                font: GoogleFonts.roboto(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).whiteText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
