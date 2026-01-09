import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/services/functions.dart';

enum LoadingDestination {
  invoice,
  bookingConfirmation,
  bookingConfirmationRental,
  selectTask,
  login,
  chooseLanguage,
}

class LoadingViewModel extends ChangeNotifier {
  bool updateAvailable = false;
  bool isLoading = false;
  bool hasInternet = true;
  LoadingDestination? _destination;

  PackageInfo? _packageInfo;

  LoadingDestination? consumeDestination() {
    final destination = _destination;
    _destination = null;
    return destination;
  }

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    await _ensureNotifications();
    await _loadPackageInfo();
    await _checkForUpdates();

    if (!updateAvailable) {
      await _bootstrapUserState();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> retry() async {
    internetTrue();
    await initialize();
  }

  Future<void> _ensureNotifications() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
      await AwesomeNotifications().setGlobalBadgeCounter(0);
    }
  }

  Future<void> _loadPackageInfo() async {
    if (_packageInfo != null) return;
    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (_) {
      _packageInfo = null;
    }
  }

  Future<void> _checkForUpdates() async {
    try {
      final versionSnapshot = (platform == TargetPlatform.android)
          ? await FirebaseDatabase.instance.ref().child('user_android_version').get()
          : await FirebaseDatabase.instance.ref().child('user_ios_version').get();

      if (versionSnapshot.value != null && _packageInfo != null) {
        updateAvailable =
            _isUpdateAvailable(versionSnapshot.value.toString(), _packageInfo!.version);
      }
    } catch (_) {
      updateAvailable = false;
    }
  }

  Future<void> _bootstrapUserState() async {
    await getDetailsOfDevice();
    hasInternet = internet;

    if (!hasInternet) return;

    final localState = await getLocalData();
    _destination = _resolveNavigation(localState);
  }

  LoadingDestination _resolveNavigation(dynamic localState) {
    if (localState == '3') {
      if (userRequestData.isNotEmpty && userRequestData['is_completed'] == 1) {
        return LoadingDestination.invoice;
      }
      if (userRequestData.isNotEmpty && userRequestData['is_completed'] != 1) {
        return userRequestData['is_rental'] == true
            ? LoadingDestination.bookingConfirmationRental
            : LoadingDestination.bookingConfirmation;
      }
      return LoadingDestination.selectTask;
    }

    if (localState == '2') {
      return LoadingDestination.login;
    }

    return LoadingDestination.chooseLanguage;
  }

  Future<void> openStoreListing() async {
    if (_packageInfo == null) return;
    isLoading = true;
    notifyListeners();
    try {
      if (platform == TargetPlatform.android) {
        await openBrowser(
            'https://play.google.com/store/apps/details?id=${_packageInfo!.packageName}');
      } else {
        final response = await http
            .get(Uri.parse('http://itunes.apple.com/lookup?bundleId=${_packageInfo!.packageName}'));
        if (response.statusCode == 200) {
          final url = jsonDecode(response.body)['results'][0]['trackViewUrl'];
          await openBrowser(url);
        }
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool _isUpdateAvailable(String storeVersion, String currentVersion) {
    final storeParts = storeVersion.split('.');
    final currentParts = currentVersion.split('.');
    final maxLength = storeParts.length > currentParts.length
        ? storeParts.length
        : currentParts.length;

    for (var i = 0; i < maxLength; i++) {
      final store = i < storeParts.length ? int.tryParse(storeParts[i]) ?? 0 : 0;
      final local = i < currentParts.length ? int.tryParse(currentParts[i]) ?? 0 : 0;
      if (local < store) return true;
      if (local > store) return false;
    }
    return false;
  }
}
