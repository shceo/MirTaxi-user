part of 'booking_confirmation.dart';

extension _BookingConfirmationBottomPanel on _BookingConfirmationState {
  Widget buildTopBackButton(Size media, {double? bottom, VoidCallback? onTap}) {
    final top = MediaQuery.of(context).padding.top;
    return Positioned(
      top: bottom == null ? top + 12 : null,
      bottom: bottom,
      left: 12,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap ?? () => Navigator.maybePop(context),
        child: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                blurRadius: 14,
                color: Colors.black.withOpacity(0.18),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }

  Widget buildBookingBottomPanel(Size media) {
    final list = (widget.type != 1) ? etaDetails : rentalOption;

    final pick = _bcShort(_bcAddressById('pickup'));
    final drop = _bcShort(_bcAddressById('drop'));
    final routeText = (pick.isNotEmpty && drop.isNotEmpty)
        ? '$pick > $drop'
        : (pick.isNotEmpty ? pick : (drop.isNotEmpty ? drop : 'вЂ”'));

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -6),
                blurRadius: 18,
                color: Colors.black.withOpacity(0.10),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BcRow(
                leading: const Icon(Icons.radio_button_unchecked,
                    size: 18, color: Colors.black),
                title: pick.isNotEmpty ? pick : 'вЂ”',
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF2F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    context.l10n.text_pick_up_location,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 10),
              _BcRow(
                leading: const Icon(Icons.alt_route_rounded,
                    size: 20, color: Colors.black),
                title: routeText,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _bcTripEtaText(),
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.add,
                            size: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final item = list[i];
                    final isSelected = i == choosenVehicle;
                    return _BcVehicleCard(
                      isSelected: isSelected,
                      etaText: _bcVehicleEta(item),
                      name: _bcVehicleName(item),
                      price: _bcVehiclePrice(item),
                      image: _bcVehicleImage(item),
                      onTap: () => _updateState(() => choosenVehicle = i),
                      onInfo: () => _updateState(() {
                        _showInfo = true;
                        _showInfoInt = i;
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _updateState(() => _choosePayment = true),
                    child: const SizedBox(
                      height: 48,
                      width: 48,
                      child: Center(
                        child: Icon(Icons.account_balance_wallet_rounded,
                            size: 26, color: Color(0xFF22C55E)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _updateState(() => _choosePayment = true),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 220, 113, 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          context.l10n.text_ridenow,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: const SizedBox(
                      height: 48,
                      width: 48,
                      child: Center(
                        child: Icon(Icons.tune, size: 24, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BcRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget trailing;

  const _BcRow(
      {required this.leading, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        const SizedBox(width: 10),
        trailing,
      ],
    );
  }
}

class _BcVehicleCard extends StatelessWidget {
  final bool isSelected;
  final String etaText;
  final String name;
  final String price;
  final Widget image;
  final VoidCallback onTap;
  final VoidCallback onInfo;

  const _BcVehicleCard({
    required this.isSelected,
    required this.etaText,
    required this.name,
    required this.price,
    required this.image,
    required this.onTap,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 112,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE5E7EB),
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 6),
              blurRadius: 12,
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (etaText.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      etaText,
                      style: GoogleFonts.roboto(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  )
                else
                  const SizedBox(height: 20),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onInfo,
                  child: const SizedBox(
                    height: 24,
                    width: 24,
                    child: Icon(Icons.info_outline,
                        size: 18, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(height: 26, child: Center(child: image)),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.bolt, size: 14, color: Colors.black),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
