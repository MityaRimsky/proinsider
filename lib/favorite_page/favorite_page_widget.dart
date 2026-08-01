import '/backend/supabase/supabase.dart';
import '/components/express_widget.dart';
import '/components/gold_widget.dart';
import '/components/ordinar_widget.dart';
import '/components/premium_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'favorite_page_model.dart';
export 'favorite_page_model.dart';

class FavoritePageWidget extends StatefulWidget {
  const FavoritePageWidget({super.key});

  static String routeName = 'FavoritePage';
  static String routePath = '/favoritePage';

  @override
  State<FavoritePageWidget> createState() => _FavoritePageWidgetState();
}

class _FavoritePageWidgetState extends State<FavoritePageWidget> {
  late FavoritePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FavoritePageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
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
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Избранное',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.roboto(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                    ),
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (FFAppState().favoriteForecast.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 32.0, 0.0, 16.0),
                          child: FutureBuilder<List<ForecastCardsFeedViewRow>>(
                            future: ForecastCardsFeedViewTable().queryRows(
                              queryFn: (q) => q.inFilterOrNull(
                                'card_id',
                                FFAppState().favoriteForecast,
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
                              List<ForecastCardsFeedViewRow>
                                  listViewForecastCardsFeedViewRowList =
                                  snapshot.data!;

                              return ListView.separated(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  0,
                                  16.0,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    listViewForecastCardsFeedViewRowList.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 8.0),
                                itemBuilder: (context, listViewIndex) {
                                  final listViewForecastCardsFeedViewRow =
                                      listViewForecastCardsFeedViewRowList[
                                          listViewIndex];
                                  return Builder(
                                    builder: (context) {
                                      if (listViewForecastCardsFeedViewRow
                                              .type ==
                                          'ordinary') {
                                        return OrdinarWidget(
                                          key: Key(
                                              'Keyffs_${listViewIndex}_of_${listViewForecastCardsFeedViewRowList.length}'),
                                          cardId:
                                              listViewForecastCardsFeedViewRow
                                                  .cardId!,
                                          resultStatus:
                                              listViewForecastCardsFeedViewRow
                                                  .resultStatus!,
                                          startTime:
                                              listViewForecastCardsFeedViewRow
                                                  .startTime!,
                                          eventLeague:
                                              listViewForecastCardsFeedViewRow
                                                  .eventLeague!,
                                          betMarket:
                                              listViewForecastCardsFeedViewRow
                                                  .betMarket!,
                                          eventOdds:
                                              listViewForecastCardsFeedViewRow
                                                  .eventOdds!,
                                          homeTeamId:
                                              listViewForecastCardsFeedViewRow
                                                  .homeTeamId!,
                                          homeTeamName:
                                              listViewForecastCardsFeedViewRow
                                                  .homeTeamName!,
                                          homeTeamLogoUrl:
                                              listViewForecastCardsFeedViewRow
                                                  .homeTeamLogoUrl!,
                                          awayTeamId:
                                              listViewForecastCardsFeedViewRow
                                                  .awayTeamId!,
                                          awayTeamName:
                                              listViewForecastCardsFeedViewRow
                                                  .awayTeamName!,
                                          awayTeamLogoUrl:
                                              listViewForecastCardsFeedViewRow
                                                  .awayTeamLogoUrl!,
                                          eventSport:
                                              listViewForecastCardsFeedViewRow
                                                  .eventSport!,
                                        );
                                      } else if (listViewForecastCardsFeedViewRow
                                              .type ==
                                          'express') {
                                        return ExpressWidget(
                                          key: Key(
                                              'Key8fu_${listViewIndex}_of_${listViewForecastCardsFeedViewRowList.length}'),
                                          cardId:
                                              listViewForecastCardsFeedViewRow
                                                  .cardId!,
                                          totalOdds:
                                              listViewForecastCardsFeedViewRow
                                                  .totalOdds!,
                                          resultStatus:
                                              listViewForecastCardsFeedViewRow
                                                  .resultStatus!,
                                          startTime:
                                              listViewForecastCardsFeedViewRow
                                                  .startTime!,
                                        );
                                      } else if (listViewForecastCardsFeedViewRow
                                              .type ==
                                          'gold') {
                                        return GoldWidget(
                                          key: Key(
                                              'Keyiuh_${listViewIndex}_of_${listViewForecastCardsFeedViewRowList.length}'),
                                          cardId:
                                              listViewForecastCardsFeedViewRow
                                                  .cardId!,
                                          totalOdds:
                                              listViewForecastCardsFeedViewRow
                                                  .totalOdds!,
                                          resultStatus:
                                              listViewForecastCardsFeedViewRow
                                                  .resultStatus!,
                                          startTime:
                                              listViewForecastCardsFeedViewRow
                                                  .startTime!,
                                          hasAccess:
                                              listViewForecastCardsFeedViewRow
                                                  .hasAccess!,
                                          canPurchase:
                                              listViewForecastCardsFeedViewRow
                                                  .canPurchase!,
                                          subscriptionPlanId:
                                              listViewForecastCardsFeedViewRow
                                                  .subscriptionPlanId!,
                                        );
                                      } else {
                                        return PremiumWidget(
                                          key: Key(
                                              'Keyk9u_${listViewIndex}_of_${listViewForecastCardsFeedViewRowList.length}'),
                                          cardId:
                                              listViewForecastCardsFeedViewRow
                                                  .cardId!,
                                          totalOdds:
                                              listViewForecastCardsFeedViewRow
                                                  .totalOdds!,
                                          resultStatus:
                                              listViewForecastCardsFeedViewRow
                                                  .resultStatus!,
                                          startTime:
                                              listViewForecastCardsFeedViewRow
                                                  .startTime!,
                                          hasAccess:
                                              listViewForecastCardsFeedViewRow
                                                  .hasAccess!,
                                          canPurchase:
                                              listViewForecastCardsFeedViewRow
                                                  .canPurchase!,
                                          subscriptionPlanId:
                                              listViewForecastCardsFeedViewRow
                                                  .subscriptionPlanId!,
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'У вас пока нет избранных прогнозов',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontStyle,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Нажмите на значок',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.roboto(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .tertiaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Icon(
                                    FFIcons.karchiveAdd,
                                    color: FlutterFlowTheme.of(context)
                                        .tertiaryText,
                                    size: 20.0,
                                  ),
                                ].divide(SizedBox(width: 4.0)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                'чтобы добавить прогноз в избранное.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.roboto(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .tertiaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
