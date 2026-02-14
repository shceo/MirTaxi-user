part of 'booking_confirmation.dart';

extension _BookingConfirmationPaymentModal on _BookingConfirmationState {
  Future<void> openChoosePaymentBottomSheet() async {
    final types = _paymentTypesForCurrentVehicle();
    if (types.isEmpty) return;
    if (payingVia < 0 || payingVia >= types.length) {
      _updateState(() => payingVia = 0);
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BookingConfirmationPaymentBottomSheet(
          paymentTypes: types,
          initialPayingVia: payingVia,
          onPaymentSelected: (index) => _updateState(() => payingVia = index),
        );
      },
    );

    promoCode = '';
  }

  List<String> _paymentTypesForCurrentVehicle() {
    final isRental = widget.type == 1;
    final source = isRental ? rentalOption : etaDetails;
    if (source.isEmpty) return const <String>[];

    var selectedIndex = (choosenVehicle is int) ? choosenVehicle as int : 0;
    if (selectedIndex < 0 || selectedIndex >= source.length) {
      selectedIndex = 0;
      choosenVehicle = selectedIndex;
    }

    final current = source[selectedIndex];
    return (current['payment_type'] ?? '')
        .toString()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  int? _promoStatusAsInt() {
    final val = promoStatus;
    if (val is int) return val;
    if (val == null) return null;
    return int.tryParse(val.toString());
  }

  Future<int?> _applyPromoCodeFromSheet(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      promoCode = '';
      return _promoStatusAsInt();
    }

    promoCode = trimmed;
    _updateState(() => _isLoading = true);
    if (widget.type != 1) {
      await etaRequestWithPromo();
    } else {
      await rentalRequestWithPromo();
    }
    if (mounted) {
      _updateState(() => _isLoading = false);
    } else {
      _isLoading = false;
    }
    return _promoStatusAsInt();
  }

  Future<int?> _removeAcceptedPromoFromSheet() async {
    _updateState(() => _isLoading = true);
    dynamic result;
    if (widget.type != 1) {
      result = await etaRequest();
    } else {
      result = await rentalEta();
    }
    if (mounted) {
      _updateState(() {
        _isLoading = false;
        if (result == true) {
          promoStatus = null;
          promoCode = '';
        }
      });
    } else {
      _isLoading = false;
      if (result == true) {
        promoStatus = null;
        promoCode = '';
      }
    }
    return _promoStatusAsInt();
  }

  Future<int?> _removeRejectedPromoFromSheet() async {
    promoStatus = null;
    promoCode = '';
    if (widget.type != 1) {
      await etaRequest();
    } else {
      await rentalEta();
    }
    return _promoStatusAsInt();
  }
}
