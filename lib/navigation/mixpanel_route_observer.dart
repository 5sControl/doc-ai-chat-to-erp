import 'package:flutter/material.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';

/// Sends a screen_view event to Mixpanel when a new route is pushed.
class MixpanelRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final MixpanelBloc mixpanelBloc;

  MixpanelRouteObserver(this.mixpanelBloc);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final name = route.settings.name;
    if (name != null && name.isNotEmpty) {
      mixpanelBloc.add(ScreenView(screenName: name));
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      final name = newRoute.settings.name;
      if (name != null && name.isNotEmpty) {
        mixpanelBloc.add(ScreenView(screenName: name));
      }
    }
  }
}
