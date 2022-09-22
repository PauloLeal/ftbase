library ftbase;

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io' as io;
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:json_theme/json_theme.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'services/firebase_analytics_service.dart';
part 'services/firebase_dynamic_link_service.dart';
part 'services/firebase_functions_service.dart';
part 'services/firebase_login_service.dart';
part 'services/firebase_notification_service.dart';
part 'services/firebase_service.dart';
part 'services/firebase_storage_service.dart';
part 'services/geolocation_service.dart';
part 'services/local_storage_service.dart';
part 'services/theme_service.dart';
part 'utils/exception_handler.dart';
part 'utils/http_utils.dart';
part 'utils/i18n.dart';
part 'utils/log.dart';
part 'utils/regex_utils.dart';
part 'utils/text_formatters.dart';
