// Code from : https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter/
// TODO : responsive scaffold

import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav/play/route_body/chessground_body.dart';
import 'package:crea_chess/route/nav/play/route_body/create_challenge_body.dart';
import 'package:crea_chess/route/nav/play/route_body/home_body.dart';
import 'package:crea_chess/route/nav/profile/route_body/profile_screen.dart';
import 'package:crea_chess/route/nav/profile/route_body/signin_screen.dart';
import 'package:crea_chess/route/nav/profile/route_body/signup_screen.dart';
import 'package:crea_chess/route/nav/settings/route_body/color_screen.dart';
import 'package:crea_chess/route/nav/settings/route_body/settings_screen.dart';
import 'package:crea_chess/route/route_scaffold.dart';
import 'package:flutter/material.dart';
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
                child: RouteScaffold(body: ProfileScreen()),
              ),
              routes: [
                // child routes
                GoRoute(
                  path: 'signin',
                  builder: (context, state) =>
                      const RouteScaffold(body: SigninScreen()),
                ),
                GoRoute(
                  path: 'signup',
                  builder: (context, state) =>
                      const RouteScaffold(body: SignupScreen()),
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
                child: RouteScaffold(body: SettingsScreen()),
              ),
              routes: [
                // child routes
                GoRoute(
                  path: 'color',
                  builder: (context, state) =>
                      const RouteScaffold(body: ColorScreen()),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

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

// use like this:
// MaterialApp.router(routerConfig: goRouter, ...)

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
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: [
          NavigationDestination(
            label: context.l10n.play,
            icon: const Icon(Icons.play_arrow),
          ),
          NavigationDestination(
            label: context.l10n.profile,
            icon: const Icon(Icons.person),
          ),
          NavigationDestination(
            label: context.l10n.settings,
            icon: const Icon(Icons.settings),
          ),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
