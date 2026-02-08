part of 'booking_confirmation.dart';

extension _BookingConfirmationModalHelpers on _BookingConfirmationState {
  int? _bcTryParseMinutes(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.round();
    final s = v.toString().trim();
    if (s.isEmpty) return null;

    // If backend already returns "1 hour 20 min"/"1 час 20 мин", keep as-is.
    final lower = s.toLowerCase();
    if (lower.contains('hour') ||
        lower.contains('hr') ||
        lower.contains('час') ||
        lower.contains('soat')) {
      return null;
    }

    final m = RegExp(r'\d+').firstMatch(s);
    if (m == null) return null;
    return int.tryParse(m.group(0)!);
  }

  String _bcRuPlural(int n, {required String one, required String few, required String many}) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return one;
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return few;
    return many;
  }

  String _bcFormatMinutesAsHoursMinutes(int totalMinutes) {
    final minutes = totalMinutes < 0 ? 0 : totalMinutes;
    final h = minutes ~/ 60;
    final m = minutes % 60;

    final lang = Localizations.localeOf(context).languageCode.toLowerCase();

    String hourWord(int n) {
      if (lang == 'ru') {
        return _bcRuPlural(n, one: 'час', few: 'часа', many: 'часов');
      }
      if (lang == 'uz') return 'soat';
      return n == 1 ? 'hour' : 'hours';
    }

    String minuteWord(int n) {
      if (lang == 'ru') {
        return _bcRuPlural(n, one: 'минута', few: 'минуты', many: 'минут');
      }
      if (lang == 'uz') return 'minut';
      return n == 1 ? 'minute' : 'minutes';
    }

    if (h <= 0) {
      return '$minutes ${minuteWord(minutes)}';
    }
    if (m == 0) {
      return '$h ${hourWord(h)}';
    }
    return '$h ${hourWord(h)} $m ${minuteWord(m)}';
  }

  String _bcAddressById(String id) {
    try {
      final found = addressList.firstWhere((e) => (e as dynamic).id == id);
      final d = found as dynamic;
      final v = d.address ?? d.placeName ?? d.name ?? '';
      return v.toString();
    } catch (_) {
      return '';
    }
  }

  String _bcShort(String s) {
    final t = s.trim();
    if (t.isEmpty) return '';
    final first = t.split(',').first.trim();
    return first.isNotEmpty ? first : t;
  }

  String _bcTripEtaText() {
    try {
      final idx = choosenVehicle;
      if (idx == null) return '—';
      final data = (widget.type != 1) ? etaDetails[idx] : rentalOption[idx];
      final v = data['trip_eta'] ?? data['eta'] ?? data['eta_minutes'] ?? data['time'] ?? data['duration'];
      if (v == null) return '—';

      final mins = _bcTryParseMinutes(v);
      if (mins != null) {
        return _bcFormatMinutesAsHoursMinutes(mins);
      }

      final s = v.toString().trim();
      return s.isEmpty ? '—' : s;
    } catch (_) {
      return '—';
    }
  }

  String _bcVehicleEta(dynamic item) {
    try {
      final v = item['eta'] ?? item['eta_minutes'] ?? item['time'] ?? item['duration'] ?? item['trip_eta'];
      if (v == null) return '';

      final mins = _bcTryParseMinutes(v);
      if (mins != null) {
        return _bcFormatMinutesAsHoursMinutes(mins);
      }

      final s = v.toString().trim();
      return s.isEmpty ? '' : s;
    } catch (_) {
      return '';
    }
  }

  String _bcVehicleName(dynamic item) {
    try {
      final s = (item['name'] ?? item['vehicle_type'] ?? item['title'] ?? '').toString().trim();
      return s.isEmpty ? '—' : s;
    } catch (_) {
      return '—';
    }
  }

  String _bcVehiclePrice(dynamic item) {
    try {
      final currency = (item['currency'] ?? '').toString().trim();
      final hasDiscount = item['has_discount'] == true;
      final raw = hasDiscount ? (item['discounted_totel'] ?? item['discounted_total']) : (item['total'] ?? item['fare_amount']);
      final price = _bcMoney(raw);
      if (currency.isEmpty) return price;
      return '$price $currency';
    } catch (_) {
      return '';
    }
  }

  String _bcMoney(dynamic v) {
    if (v == null) return '0';
    if (v is num) {
      if (v >= 100) return v.toStringAsFixed(0);
      return v.toStringAsFixed(2);
    }
    final s = v.toString().trim();
    if (s.isEmpty) return '0';
    final n = double.tryParse(s.replaceAll(' ', '').replaceAll(',', '.'));
    if (n == null) return s;
    if (n >= 100) return n.toStringAsFixed(0);
    return n.toStringAsFixed(2);
  }

  Widget _bcVehicleImage(dynamic item) {
    try {
      final v = item['image'] ?? item['icon'] ?? item['vehicle_image'];
      if (v is String) {
        final s = v.trim();
        if (s.startsWith('http')) return Image.network(s, fit: BoxFit.contain);
        if (s.isNotEmpty) return Image.asset(s, fit: BoxFit.contain);
      }
      return const Icon(Icons.directions_car, size: 26, color: Colors.black);
    } catch (_) {
      return const Icon(Icons.directions_car, size: 26, color: Colors.black);
    }
  }

  Widget _bcPaymentIcon(String type) {
    final t = type.toLowerCase().trim();
    if (t == 'cash') return Image.asset('assets/images/cash.png', fit: BoxFit.contain);
    if (t == 'wallet') return Image.asset('assets/images/wallet.png', fit: BoxFit.contain);
    if (t == 'card') return Image.asset('assets/images/card.png', fit: BoxFit.contain);
    if (t == 'upi') return Image.asset('assets/images/upi.png', fit: BoxFit.contain);
    return const Icon(Icons.payment, size: 18);
  }

  String _bcPaymentHint(String type) {
    final t = type.toLowerCase().trim();
    if (t == 'cash') return context.l10n.text_paycash;
    if (t == 'wallet') return context.l10n.text_paywallet;
    if (t == 'card') return context.l10n.text_paycard;
    if (t == 'upi') return context.l10n.text_payupi;
    return '';
  }
}
