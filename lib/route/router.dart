// Code from : https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter/
// TODO : responsive scaffold

import 'package:badges/badges.dart' as badges;
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav_notif_cubit.dart';
import 'package:crea_chess/route/play/route_body/chessground_body.dart';
import 'package:crea_chess/route/play/route_body/create_challenge_body.dart';
import 'package:crea_chess/route/play/route_body/home_body.dart';
import 'package:crea_chess/route/profile/route_body/email_verification_body.dart';
import 'package:crea_chess/route/profile/route_body/modify_name_body.dart';
import 'package:crea_chess/route/profile/route_body/profile_body.dart';
import 'package:crea_chess/route/profile/route_body/sign_methods_body.dart';
import 'package:crea_chess/route/profile/route_body/signin_body.dart';
import 'package:crea_chess/route/profile/route_body/signup_body.dart';
import 'package:crea_chess/route/route_scaffold.dart';
import 'package:crea_chess/route/settings/route_body/settings_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');

// the one and only GoRouter instance
final router = GoRouter(
  initialLocation: '/play',
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => ErrorPage(state: state),
  routes: [
    // Stateful nested navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/play',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RouteScaffold(body: HomeBody()),
              ),
              routes: [
                // child routes
                GoRoute(
                  path: 'chessground',
                  builder: (context, state) => const ChessgroundBody(),
                ),
                GoRoute(
                  path: 'create_challenge',
                  builder: (context, state) =>
                      const RouteScaffold(body: CreateChallengeBody()),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RouteScaffold(body: ProfileBody()),
              ),
              routes: [
                // child routes
                GoRoute(
                  path: 'sign_methods',
                  builder: (context, state) =>
                      const RouteScaffold(body: SignMethodsBody()),
                ),
                GoRoute(
                  path: 'signin',
                  builder: (context, state) =>
                      const RouteScaffold(body: SigninBody()),
                ),
                GoRoute(
                  path: 'signup',
                  builder: (context, state) =>
                      const RouteScaffold(body: SignupBody()),
                ),
                GoRoute(
                  path: 'email_verification',
                  builder: (context, state) =>
                      const RouteScaffold(body: EmailVerificationBody()),
                ),
                GoRoute(
                  path: 'modify_name',
                  builder: (context, state) =>
                      const RouteScaffold(body: ModifyNameBody()),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RouteScaffold(body: SettingsBody()),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

final mainRouteBodies = [
  const HomeBody(),
  const ProfileBody(),
  const SettingsBody(),
];

class ErrorPage extends StatelessWidget {
  const ErrorPage({required this.state, super.key});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error?.toString() ?? 'null'),
            TextButton(
              onPressed: () => context.go('/play'),
              child: Text(context.l10n.home),
            ),
          ],
        ),
      ),
    );
  }
}

// Stateful nested navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BlocBuilder<NavNotifCubit, Map<String, Set<String>>>(
        builder: (context, notifs) {
          return NavigationBar(
            height: CCWidgetSize.xxsmall,
            selectedIndex: navigationShell.currentIndex,
            destinations: mainRouteBodies
                .map(
                  (e) => NavigationDestination(
                    icon: notifs[e.id]?.isNotEmpty ?? false
                        ? badges.Badge(child: Icon(e.icon))
                        : Icon(e.icon),
                    label: e.getTitle(context.l10n),
                  ),
                )
                .toList(),
            onDestinationSelected: _goBranch,
          );
        },
      ),
    );
  }
}
