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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _hasPermission = true;
    Geolocator.getPositionStream().listen((Position p) {
      _currentPosition = p;
      if (onPositionChanged != null) {
        onPositionChanged!(p);
      }
    });
  }

  Future<void> openSettings() async {
    await AppSettings.openLocationSettings();
  }
}
