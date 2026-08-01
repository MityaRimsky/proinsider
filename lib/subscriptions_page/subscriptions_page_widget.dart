import '/backend/supabase/supabase.dart';
import '/components/custom_bottom_nav_bar_widget.dart';
import '/components/gold_plan_card_widget.dart';
import '/components/live_plan_card_widget.dart';
import '/components/premium_plan_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'subscriptions_page_model.dart';
export 'subscriptions_page_model.dart';

class SubscriptionsPageWidget extends StatefulWidget {
  const SubscriptionsPageWidget({super.key});

  static String routeName = 'SubscriptionsPage';
  static String routePath = '/subscriptionsPage';

  @override
  State<SubscriptionsPageWidget> createState() =>
      _SubscriptionsPageWidgetState();
}

class _SubscriptionsPageWidgetState extends State<SubscriptionsPageWidget> {
  late SubscriptionsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionsPageModel());
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Оплата и подписки',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 48.0, 16.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                FFIcons.kflash,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).accent2,
                                size: 20.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Получайте эксклюзивные прогнозы с подписками',
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.roboto(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: FutureBuilder<
                              List<SubscriptionPlanDetailsViewRow>>(
                            future:
                                SubscriptionPlanDetailsViewTable().queryRows(
                              queryFn: (q) => q,
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
                              List<SubscriptionPlanDetailsViewRow>
                                  listViewSubscriptionPlanDetailsViewRowList =
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
                                    listViewSubscriptionPlanDetailsViewRowList
                                        .length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 8.0),
                                itemBuilder: (context, listViewIndex) {
                                  final listViewSubscriptionPlanDetailsViewRow =
                                      listViewSubscriptionPlanDetailsViewRowList[
                                          listViewIndex];
                                  return Builder(
                                    builder: (context) {
                                      if (listViewSubscriptionPlanDetailsViewRow
                                              .name ==
                                          'premium') {
                                        return PremiumPlanCardWidget(
                                          key: Key(
                                              'Key1lu_${listViewIndex}_of_${listViewSubscriptionPlanDetailsViewRowList.length}'),
                                          planId:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .planId!,
                                          subtitle:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .subtitle!,
                                          displayPrice:
                                              listViewSubscriptionPlanDetailsViewRow
                                                          .hasAccess ==
                                                      true
                                                  ? listViewSubscriptionPlanDetailsViewRow
                                                      .currentOptionPrice!
                                                  : listViewSubscriptionPlanDetailsViewRow
                                                      .option1Price!,
                                          displayOptionName:
                                              listViewSubscriptionPlanDetailsViewRow
                                                          .hasAccess ==
                                                      true
                                                  ? listViewSubscriptionPlanDetailsViewRow
                                                      .currentOptionName!
                                                  : listViewSubscriptionPlanDetailsViewRow
                                                      .option1Name!,
                                          planName:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .name!,
                                          remainingForecasts:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .remainingForecasts,
                                          hasAccess:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .hasAccess!,
                                        );
                                      } else if (listViewSubscriptionPlanDetailsViewRow
                                              .name ==
                                          'gold') {
                                        return GoldPlanCardWidget(
                                          key: Key(
                                              'Key27q_${listViewIndex}_of_${listViewSubscriptionPlanDetailsViewRowList.length}'),
                                          planId:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .planId!,
                                          subtitle:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .subtitle!,
                                          displayPrice:
                                              listViewSubscriptionPlanDetailsViewRow
                                                          .hasAccess ==
                                                      true
                                                  ? listViewSubscriptionPlanDetailsViewRow
                                                      .currentOptionPrice!
                                                  : listViewSubscriptionPlanDetailsViewRow
                                                      .option1Price!,
                                          displayOptionName:
                                              listViewSubscriptionPlanDetailsViewRow
                                                          .hasAccess ==
                                                      true
                                                  ? listViewSubscriptionPlanDetailsViewRow
                                                      .currentOptionName!
                                                  : listViewSubscriptionPlanDetailsViewRow
                                                      .option1Name!,
                                          planName:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .name!,
                                          remainingForecasts:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .remainingForecasts,
                                          hasAccess:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .hasAccess!,
                                        );
                                      } else {
                                        return LivePlanCardWidget(
                                          key: Key(
                                              'Keyemk_${listViewIndex}_of_${listViewSubscriptionPlanDetailsViewRowList.length}'),
                                          planId:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .planId!,
                                          subtitle:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .subtitle!,
                                          displayPrice:
                                              listViewSubscriptionPlanDetailsViewRow
                                                          .hasAccess ==
                                                      true
                                                  ? listViewSubscriptionPlanDetailsViewRow
                                                      .currentOptionPrice!
                                                  : listViewSubscriptionPlanDetailsViewRow
                                                      .option1Price!,
                                          displayOptionName:
                                              listViewSubscriptionPlanDetailsViewRow
                                                          .hasAccess ==
                                                      true
                                                  ? listViewSubscriptionPlanDetailsViewRow
                                                      .currentOptionName!
                                                  : listViewSubscriptionPlanDetailsViewRow
                                                      .option1Name!,
                                          planName:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .name!,
                                          hasAccess:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .hasAccess!,
                                          expiresAt:
                                              listViewSubscriptionPlanDetailsViewRow
                                                  .expiresAt,
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
      ),
    );
  }
}
