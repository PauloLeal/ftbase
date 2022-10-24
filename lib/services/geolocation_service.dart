import 'dart:async';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationService {
  GeolocationService._privateConstructor();
  static final GeolocationService instance = GeolocationService._privateConstructor();

  void Function(Position position)? onPositionChanged;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  bool _hasPermission = false;
  bool get hasPermission => _hasPermission;

  Future<void> initialize() async => await _configure();

  Future<void> _configure() async {
    Completer c = Completer();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      c.complete();
      return c.future;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        c.complete();
        return c.future;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      c.complete();
      return c.future;
    }

    _hasPermission = true;
    Geolocator.getPositionStream().listen((Position p) {
      _currentPosition = p;
      if (!c.isCompleted) {
        c.complete();
      }

      if (onPositionChanged != null) {
        onPositionChanged!(p);
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!c.isCompleted) {
        c.complete();
      }
    });

    return c.future;
  }

  Future<void> openSettings() async {
    await AppSettings.openLocationSettings();
  }

  static double calculateDistanceInMetters(Position p1, Position p2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((p2.latitude - p1.latitude) * p) / 2 +
        cos(p1.latitude * p) * cos(p2.latitude * p) * (1 - cos((p2.longitude - p1.longitude) * p)) / 2;
    return (12742 * asin(sqrt(a))) * 1000;
  }
}
