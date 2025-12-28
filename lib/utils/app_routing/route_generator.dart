export "package:flutter/material.dart";
import "package:beamer/beamer.dart";
import "package:flutter/cupertino.dart";
import "package:smart_incident/feature/incident_form/model/incident_model.dart";
import "routing_imports.dart";

class RouteGenerator {
  static BeamerDelegate generateRoute() {
    return BeamerDelegate(
      initialPath: AppRoutes.splashViewRoute,
      locationBuilder: RoutesLocationBuilder(
        routes: {
          AppRoutes.splashViewRoute: (context, state, data) => BeamPage(
            title: AppRoutes.splashViewRoute,
            key: ValueKey(AppRoutes.splashViewRoute),
            child: SplashView(),
          ),

          AppRoutes.loginViewRoute: (context, state, data) => BeamPage(
            key: ValueKey(AppRoutes.loginViewRoute),
            title: AppRoutes.loginViewRoute,
            child: LoginView(),
            type: BeamPageType.scaleTransition,
          ),
          AppRoutes.signUpViewRoute: (context, state, data) => BeamPage(
            key: ValueKey(AppRoutes.signUpViewRoute),
            title: AppRoutes.signUpViewRoute,
            child: SignUpView(),
            type: BeamPageType.scaleTransition,
          ),

          AppRoutes.homeViewRoute: (context, state, data) => BeamPage(
            title: AppRoutes.homeViewRoute,
            key: ValueKey(AppRoutes.homeViewRoute),
            child: HomeView(),
            type: BeamPageType.scaleTransition,
          ),
          AppRoutes.incidentFormRoute: (context, state, data) => BeamPage(
            title: AppRoutes.incidentFormRoute,
            key: ValueKey(AppRoutes.incidentFormRoute),
            child: IncidentForm(),
            type: BeamPageType.scaleTransition,
          ),

          AppRoutes.editIncidentScreenRoute: (context, state, data) => BeamPage(
            title: AppRoutes.editIncidentScreenRoute,
            key: ValueKey(AppRoutes.editIncidentScreenRoute),
            child: EditIncidentScreen(incident: data as IncidentModel),
            type: BeamPageType.scaleTransition,
          ),

          AppRoutes.profileViewRoute: (context, state, data) => BeamPage(
            title: AppRoutes.profileViewRoute,
            key: ValueKey(AppRoutes.profileViewRoute),
            child: ProfileView(),
            type: BeamPageType.scaleTransition,
          ),

          // '/books/:bookId': (context, state, data) {
          //   // Take the path parameter of interest from BeamState
          //   final bookId = state.pathParameters['bookId']!;
          //   // Collect arbitrary data that persists throughout navigation
          //   final info = (data as MyObject).info;
          //   // Use BeamPage to define custom behavior
          //   return BeamPage(
          //     key: ValueKey('book-$bookId'),
          //     title: 'A Book #$bookId',
          //     popToNamed: '/',
          //     type: BeamPageType.scaleTransition,
          //     child: BookDetailsScreen(bookId, info),
          //   );
          // }
        },
      ).call,
    );
  }
}
