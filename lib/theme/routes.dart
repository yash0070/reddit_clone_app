import 'package:flutter/material.dart';
import 'package:reddit_app/feature/auth/screens/login_screen.dart';
import 'package:reddit_app/feature/community/screens/community_screen.dart';
import 'package:reddit_app/feature/community/screens/create_community_screen.dart';
import 'package:reddit_app/feature/community/screens/mod-tools.dart';
import 'package:reddit_app/feature/home_screen/screen/home_screen.dart';
import 'package:routemaster/routemaster.dart';

const String createCommunityScreenRoute = "/createCommunityScreenRoute";
const String communityScreen = "/r/:name";

final loggedOutRoute = RouteMap(routes: {
  '/': (_) =>const MaterialPage(child: LoginScreen())
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) =>const MaterialPage(child: HomeScreen()),
  createCommunityScreenRoute: (_) =>const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name':(route) =>  MaterialPage(child: CommunityScreen(
    name: route.pathParameters['name']!,
  )),
  '/mod-tools':(_) => const MaterialPage(child: ModToolsScreen()),
});