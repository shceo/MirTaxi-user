import 'package:flutter/widgets.dart';
import 'package:tagyourtaxi_driver/l10n/app_localizations.dart';

extension LocalizationExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
