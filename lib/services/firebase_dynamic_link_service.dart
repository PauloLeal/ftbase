import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class FirebaseDynamicLinkService {
  FirebaseDynamicLinkService._privateConstructor();
  static final FirebaseDynamicLinkService instance = FirebaseDynamicLinkService._privateConstructor();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<void> Function(PendingDynamicLinkData dynamicLink)? onLoginLink;

  bool _isLoginLink(PendingDynamicLinkData dynamicLink) {
    return dynamicLink.link.path == "/__/auth/action";
  }

  Future<void> _doLink(PendingDynamicLinkData? dynamicLink) async {
    if (dynamicLink == null) {
      return;
    }

    if (_isLoginLink(dynamicLink)) {
      if (onLoginLink != null) {
        return onLoginLink!(dynamicLink);
      }
    }

    navigatorKey.currentState?.pushNamed(dynamicLink.link.path);

    return Future.value();
  }

  void initialize() async {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData dynamicLink) async {
      _doLink(dynamicLink);
    });

    final PendingDynamicLinkData? dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
    _doLink(dynamicLink);
  }
}
