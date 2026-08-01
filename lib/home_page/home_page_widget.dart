import '/auth/base_auth_user_provider.dart';
import '/backend/supabase/supabase.dart';
import '/components/bonus_sheet_widget.dart';
import '/components/custom_bottom_nav_bar_widget.dart';
import '/components/express_widget.dart';
import '/components/gold_widget.dart';
import '/components/ordinar_widget.dart';
import '/components/premium_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.unreadNotificationsCount =
          await MyUnreadNotificationsCountTable().queryRows(
        queryFn: (q) => q,
      );
      FFAppState().unreadNotificationsCount =
          _model.unreadNotificationsCount!.firstOrNull!.unreadCount!;
      safeSetState(() {});
    });
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
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 8.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: SvgPicture.asset(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? 'assets/images/logo_dark_theme.svg'
                                      : 'assets/images/logo_bright_theme.svg',
                                  width: 154.0,
                                  height: 28.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        barrierColor: Color(0x52000000),
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: BonusSheetWidget(),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Container(
                                      width: 48.0,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Icon(
                                          FFIcons.kgift,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (loggedIn == true)
                                    FutureBuilder<
                                        List<MyUnreadNotificationsCountRow>>(
                                      future: MyUnreadNotificationsCountTable()
                                          .querySingleRow(
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
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<MyUnreadNotificationsCountRow>
                                            stackMyUnreadNotificationsCountRowList =
                                            snapshot.data!;

                                        final stackMyUnreadNotificationsCountRow =
                                            stackMyUnreadNotificationsCountRowList
                                                    .isNotEmpty
                                                ? stackMyUnreadNotificationsCountRowList
                                                    .first
                                                : null;

                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              NotificationsPageWidget.routeName,
                                              extra: <String, dynamic>{
                                                '__transition_info__':
                                                    TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType
                                                          .rightToLeft,
                                                  duration: Duration(
                                                      milliseconds: 150),
                                                ),
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 48.0,
                                            height: 48.0,
                                            child: Stack(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              children: [
                                                Icon(
                                                  FFIcons.knotification,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tertiaryText,
                                                  size: 24.0,
                                                ),
                                                if (stackMyUnreadNotificationsCountRow!
                                                        .unreadCount! >
                                                    0)
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.7, -0.7),
                                                    child: Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        minWidth: 20.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent4,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    4.0,
                                                                    2.0,
                                                                    4.0,
                                                                    2.0),
                                                        child: Text(
                                                          stackMyUnreadNotificationsCountRow
                                                              .unreadCount!
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelSmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .whiteText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        FavoritePageWidget.routeName,
                                        extra: <String, dynamic>{
                                          '__transition_info__': TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.rightToLeft,
                                            duration:
                                                Duration(milliseconds: 100),
                                          ),
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 48.0,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        FFIcons.kbookmarkAdded,
                                        color: FlutterFlowTheme.of(context)
                                            .tertiaryText,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.selectedSport = '%all%';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: _model.selectedSport == '%all%'
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        child: Text(
                                          'Все',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.roboto(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color: valueOrDefault<Color>(
                                                  _model.selectedSport ==
                                                          '%all%'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .whiteText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .tertiaryText,
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                                ),
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
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.selectedSport = '%football%';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: _model.selectedSport ==
                                              '%football%'
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            FFIcons.kfootball,
                                            color: _model.selectedSport ==
                                                    '%football%'
                                                ? FlutterFlowTheme.of(context)
                                                    .whiteText
                                                : FlutterFlowTheme.of(context)
                                                    .tertiaryText,
                                            size: 16.0,
                                          ),
                                          Text(
                                            'Футбол',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.roboto(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: _model.selectedSport ==
                                                          '%football%'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .whiteText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .tertiaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 4.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.selectedSport = '%hockey%';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: _model.selectedSport == '%hockey%'
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            FFIcons.khockey,
                                            color: _model.selectedSport ==
                                                    '%hockey%'
                                                ? FlutterFlowTheme.of(context)
                                                    .whiteText
                                                : FlutterFlowTheme.of(context)
                                                    .tertiaryText,
                                            size: 16.0,
                                          ),
                                          Text(
                                            'Хоккей',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.roboto(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: _model.selectedSport ==
                                                          '%hockey%'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .whiteText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .tertiaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 4.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.selectedSport = '%basketball%';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: _model.selectedSport ==
                                              '%basketball%'
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            FFIcons.kbasketball,
                                            color: _model.selectedSport ==
                                                    '%basketball%'
                                                ? FlutterFlowTheme.of(context)
                                                    .whiteText
                                                : FlutterFlowTheme.of(context)
                                                    .tertiaryText,
                                            size: 16.0,
                                          ),
                                          Text(
                                            'Баскетбол',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.roboto(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: _model.selectedSport ==
                                                          '%basketball%'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .whiteText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .tertiaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 4.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.selectedSport = '%tennis%';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: _model.selectedSport == '%tennis%'
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            FFIcons.ktennis,
                                            color: _model.selectedSport ==
                                                    '%tennis%'
                                                ? FlutterFlowTheme.of(context)
                                                    .whiteText
                                                : FlutterFlowTheme.of(context)
                                                    .tertiaryText,
                                            size: 16.0,
                                          ),
                                          Text(
                                            'Теннис',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.roboto(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: _model.selectedSport ==
                                                          '%tennis%'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .whiteText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .tertiaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 4.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.selectedSport = '%mma%';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: _model.selectedSport == '%mma%'
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            FFIcons.kmma,
                                            color: _model.selectedSport ==
                                                    '%mma%'
                                                ? FlutterFlowTheme.of(context)
                                                    .whiteText
                                                : FlutterFlowTheme.of(context)
                                                    .tertiaryText,
                                            size: 16.0,
                                          ),
                                          Text(
                                            'Бои',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.roboto(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: _model.selectedSport ==
                                                          '%mma%'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .whiteText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .tertiaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 4.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.selectedSport = '%esports%';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: _model.selectedSport == '%esports%'
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            FFIcons.kgames,
                                            color: _model.selectedSport ==
                                                    '%esports%'
                                                ? FlutterFlowTheme.of(context)
                                                    .whiteText
                                                : FlutterFlowTheme.of(context)
                                                    .tertiaryText,
                                            size: 16.0,
                                          ),
                                          Text(
                                            'Киберспорт',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.roboto(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: _model.selectedSport ==
                                                          '%esports%'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .whiteText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .tertiaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 4.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child:
                                FutureBuilder<List<ForecastCardsFeedViewRow>>(
                              future: ForecastCardsFeedViewTable().queryRows(
                                queryFn: (q) => q
                                    .ilike(
                                      'sports_filter',
                                      _model.selectedSport,
                                    )
                                    .order('updated_at'),
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 32.0,
                                      height: 32.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
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
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      listViewForecastCardsFeedViewRowList
                                          .length,
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
                                                'Keytlb_${listViewIndex}_of_${listViewForecastCardsFeedViewRowList.length}'),
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
                                                'Keyopz_${listViewIndex}_of_${listViewForecastCardsFeedViewRowList.length}'),
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
                                                'Key351_${listViewIndex}_of_${listViewForecastCardsFeedViewRowList.length}'),
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
                                                'Keyhk9_${listViewIndex}_of_${listViewForecastCardsFeedViewRowList.length}'),
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
                    activeTab: 'forecasts',
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
