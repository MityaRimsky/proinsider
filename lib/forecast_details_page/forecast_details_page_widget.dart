import '/backend/supabase/supabase.dart';
import '/components/analytics_widget.dart';
import '/components/event_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'forecast_details_page_model.dart';
export 'forecast_details_page_model.dart';

class ForecastDetailsPageWidget extends StatefulWidget {
  const ForecastDetailsPageWidget({
    super.key,
    required this.cardId,
  });

  final int? cardId;

  static String routeName = 'ForecastDetailsPage';
  static String routePath = '/forecastDetailsPage';

  @override
  State<ForecastDetailsPageWidget> createState() =>
      _ForecastDetailsPageWidgetState();
}

class _ForecastDetailsPageWidgetState extends State<ForecastDetailsPageWidget> {
  late ForecastDetailsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ForecastDetailsPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<List<ForecastCardsDetailsViewRow>>(
      future: ForecastCardsDetailsViewTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget.cardId,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 32.0,
                height: 32.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<ForecastCardsDetailsViewRow>
            forecastDetailsPageForecastCardsDetailsViewRowList = snapshot.data!;

        final forecastDetailsPageForecastCardsDetailsViewRow =
            forecastDetailsPageForecastCardsDetailsViewRowList.isNotEmpty
                ? forecastDetailsPageForecastCardsDetailsViewRowList.first
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: () {
                      if (forecastDetailsPageForecastCardsDetailsViewRow
                              ?.type ==
                          'premium') {
                        return FlutterFlowTheme.of(context).primary;
                      } else if (forecastDetailsPageForecastCardsDetailsViewRow
                              ?.type ==
                          'gold') {
                        return FlutterFlowTheme.of(context).secondary;
                      } else {
                        return FlutterFlowTheme.of(context).tertiary;
                      }
                    }(),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24.0),
                      bottomRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 48.0, 16.0, 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.safePop();
                              },
                              child: Container(
                                width: 48.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color:
                                        FlutterFlowTheme.of(context).whiteText,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              valueOrDefault<String>(
                                () {
                                  if (forecastDetailsPageForecastCardsDetailsViewRow
                                          ?.type ==
                                      'premium') {
                                    return 'Premium прогноз';
                                  } else if (forecastDetailsPageForecastCardsDetailsViewRow
                                          ?.type ==
                                      'gold') {
                                    return 'Gold прогноз';
                                  } else if (forecastDetailsPageForecastCardsDetailsViewRow
                                          ?.type ==
                                      'express') {
                                    return 'Экспресс прогноз';
                                  } else {
                                    return 'Прогноз';
                                  }
                                }(),
                                'Прогноз',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    color:
                                        FlutterFlowTheme.of(context).whiteText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Builder(
                                builder: (context) {
                                  if (FFAppState()
                                      .favoriteForecast
                                      .contains(widget.cardId)) {
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        FFAppState().removeFromFavoriteForecast(
                                            widget.cardId!);
                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(),
                                        child: Icon(
                                          FFIcons.karchiveTick,
                                          color: FlutterFlowTheme.of(context)
                                              .whiteText,
                                          size: 24.0,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        FFAppState().addToFavoriteForecast(
                                            widget.cardId!);
                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(),
                                        child: Icon(
                                          FFIcons.karchiveAdd,
                                          color: Color(0xB3FFFFFF),
                                          size: 24.0,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 32.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    functions.getForecastStatus(
                                        forecastDetailsPageForecastCardsDetailsViewRow!
                                            .startTime!,
                                        forecastDetailsPageForecastCardsDetailsViewRow
                                            .resultStatus!),
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.roboto(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: Color(0xB3FFFFFF),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    dateTimeFormat(
                                        "Hm",
                                        forecastDetailsPageForecastCardsDetailsViewRow
                                            .startTime!),
                                    style: FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .override(
                                          font: GoogleFonts.goldman(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .whiteText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .headlineLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineLarge
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    dateTimeFormat(
                                        "dd/MM/yyyy",
                                        forecastDetailsPageForecastCardsDetailsViewRow
                                            .startTime!),
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          font: GoogleFonts.goldman(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .whiteText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                  ),
                                  if ((forecastDetailsPageForecastCardsDetailsViewRow
                                              .type ==
                                          'premium') ||
                                      (forecastDetailsPageForecastCardsDetailsViewRow
                                              .type ==
                                          'gold'))
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 24.0, 0.0, 0.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          forecastDetailsPageForecastCardsDetailsViewRow
                                              .betFormat,
                                          'Экспресс',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.roboto(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .whiteText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 32.0, 0.0, 0.0),
                                child: Container(
                                  height: 32.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).whiteText,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            'ОБЩИЙ КФ:',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .override(
                                                  font: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                                  color: () {
                                                    if (forecastDetailsPageForecastCardsDetailsViewRow
                                                            .type ==
                                                        'premium') {
                                                      return Color(0xFF3A6CF7);
                                                    } else if (forecastDetailsPageForecastCardsDetailsViewRow
                                                            .type ==
                                                        'gold') {
                                                      return Color(0xFFE77300);
                                                    } else {
                                                      return Color(0xFF67A101);
                                                    }
                                                  }(),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            valueOrDefault<String>(
                                              forecastDetailsPageForecastCardsDetailsViewRow
                                                  .totalOdds
                                                  ?.toString(),
                                              '0.00',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .override(
                                                  font: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                                  color: () {
                                                    if (forecastDetailsPageForecastCardsDetailsViewRow
                                                            .type ==
                                                        'premium') {
                                                      return Color(0xFF3A6CF7);
                                                    } else if (forecastDetailsPageForecastCardsDetailsViewRow
                                                            .type ==
                                                        'gold') {
                                                      return FlutterFlowTheme
                                                              .of(context)
                                                          .secondary;
                                                    } else {
                                                      return Color(0xFF67A101);
                                                    }
                                                  }(),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 4.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (forecastDetailsPageForecastCardsDetailsViewRow
                                  .resultStatus !=
                              'pending')
                            Container(
                              width: double.infinity,
                              height: 32.0,
                              decoration: BoxDecoration(
                                color:
                                    forecastDetailsPageForecastCardsDetailsViewRow
                                                .resultStatus ==
                                            'won'
                                        ? FlutterFlowTheme.of(context).success
                                        : FlutterFlowTheme.of(context).accent4,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  forecastDetailsPageForecastCardsDetailsViewRow
                                              .resultStatus ==
                                          'won'
                                      ? 'Прошел'
                                      : 'Не прошел',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .whiteText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                          FutureBuilder<List<ForecastDetailsViewRow>>(
                            future: ForecastDetailsViewTable().queryRows(
                              queryFn: (q) => q.eqOrNull(
                                'forecast_card_id',
                                widget.cardId,
                              ),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 32.0,
                                    height: 32.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<ForecastDetailsViewRow>
                                  listViewForecastDetailsViewRowList =
                                  snapshot.data!;

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewForecastDetailsViewRowList.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 8.0),
                                itemBuilder: (context, listViewIndex) {
                                  final listViewForecastDetailsViewRow =
                                      listViewForecastDetailsViewRowList[
                                          listViewIndex];
                                  return EventCardWidget(
                                    key: Key(
                                        'Keypgf_${listViewIndex}_of_${listViewForecastDetailsViewRowList.length}'),
                                    cardId: listViewForecastDetailsViewRow
                                        .forecastCardId!,
                                    eventLeague:
                                        listViewForecastDetailsViewRow.league!,
                                    predictionText:
                                        listViewForecastDetailsViewRow
                                            .predictionText!,
                                    eventOdds:
                                        listViewForecastDetailsViewRow.odds!,
                                    homeTeamId: listViewForecastDetailsViewRow
                                        .homeTeamId!,
                                    homeTeamName: listViewForecastDetailsViewRow
                                        .homeTeamName!,
                                    homeTeamLogoUrl:
                                        listViewForecastDetailsViewRow
                                            .homeTeamLogoUrl!,
                                    awayTeamId: listViewForecastDetailsViewRow
                                        .awayTeamId!,
                                    awayTeamName: listViewForecastDetailsViewRow
                                        .awayTeamName!,
                                    awayTeamLogoUrl:
                                        listViewForecastDetailsViewRow
                                            .awayTeamLogoUrl!,
                                    eventSport:
                                        listViewForecastDetailsViewRow.sport!,
                                    winnerTeamId: listViewForecastDetailsViewRow
                                        .winnerTeamId,
                                    homeScore: listViewForecastDetailsViewRow
                                        .homeScore,
                                    awayScore: valueOrDefault<String>(
                                      listViewForecastDetailsViewRow.awayScore,
                                      '0',
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          if (forecastDetailsPageForecastCardsDetailsViewRow
                                      .analyticsText !=
                                  null &&
                              forecastDetailsPageForecastCardsDetailsViewRow
                                      .analyticsText !=
                                  '')
                            wrapWithModel(
                              model: _model.analyticsModel,
                              updateCallback: () => safeSetState(() {}),
                              child: AnalyticsWidget(
                                analyticsTitle: valueOrDefault<String>(
                                  forecastDetailsPageForecastCardsDetailsViewRow
                                      .analyticsTitle,
                                  'Ставка',
                                ),
                                analyticsText: valueOrDefault<String>(
                                  forecastDetailsPageForecastCardsDetailsViewRow
                                      .analyticsText,
                                  'Аналитика',
                                ),
                                analyticsSummary: valueOrDefault<String>(
                                  forecastDetailsPageForecastCardsDetailsViewRow
                                      .analyticsSummary,
                                  'Рекомендации',
                                ),
                              ),
                            ),
                        ]
                            .divide(SizedBox(height: 8.0))
                            .addToEnd(SizedBox(height: 64.0)),
                      ),
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
