import 'package:geolocator/geolocator.dart';

class GeolocationService {
  GeolocationService._privateConstructor();
  static final GeolocationService instance = GeolocationService._privateConstructor();

  void Function(Position position)? onPositionChanged;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  Future<void> initialize() async => _configure();

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
      // Geolocator.openAppSettings();
      return;
    }

    Geolocator.getPositionStream().listen((Position p) {
      _currentPosition = p;
      if (onPositionChanged != null) {
        onPositionChanged!(p);
      }
    });
  }
}
