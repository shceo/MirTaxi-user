part of 'booking_confirmation.dart';

extension _BookingConfirmationVehicleInfo on _BookingConfirmationState {
  Widget buildVehicleInfoModal(Size media) {
    if (_showInfo != true) return Container();
    final idx = _showInfoInt;
    if (idx == null) return Container();

    final data = (widget.type != 1) ? etaDetails : rentalOption;
    if (idx < 0 || idx >= data.length) return Container();

    final item = data[idx];
    final isRental = widget.type == 1;

    final name = (item['name'] ?? '').toString();
    final desc = (item['description'] ?? '').toString();
    final supported = (item['supported_vehicles'] ?? '').toString();

    final hasDiscount = item['has_discount'] == true;
    final currency = (item['currency'] ?? '').toString();
    final baseAmount = isRental ? item['fare_amount'] : item['total'];
    final discountAmount = item['discounted_totel'] ?? item['discounted_total'];

    return Positioned(
      top: 0,
      child: Container(
        padding: EdgeInsets.only(bottom: media.width * 0.05),
        height: media.height,
        width: media.width,
        color: Colors.transparent.withOpacity(0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: media.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      _updateState(() {
                        _showInfo = false;
                        _showInfoInt = null;
                      });
                    },
                    child: Container(
                      height: media.width * 0.1,
                      width: media.width * 0.1,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: page),
                      child: const Icon(Icons.cancel_outlined),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: media.width * 0.05),
            Container(
              width: media.width * 0.9,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: page),
              padding: EdgeInsets.all(media.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.roboto(
                      fontSize: media.width * sixteen,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: media.width * 0.025),
                  Text(
                    desc,
                    style: GoogleFonts.roboto(
                      fontSize: media.width * fourteen,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Text(
                    context.l10n.text_supported_vehicles,
                    style: GoogleFonts.roboto(
                      fontSize: media.width * sixteen,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: media.width * 0.025),
                  Text(
                    supported,
                    style: GoogleFonts.roboto(
                      fontSize: media.width * fourteen,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: media.width * 0.4,
                        child: Text(
                          context.l10n.text_estimated_amount,
                          style: GoogleFonts.roboto(
                            fontSize: media.width * sixteen,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!hasDiscount)
                        Text(
                          '$currency ${_bcMoney(baseAmount)}',
                          style: GoogleFonts.roboto(
                            fontSize: media.width * fourteen,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$currency ',
                              style: GoogleFonts.roboto(
                                fontSize: media.width * fourteen,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _bcMoney(baseAmount),
                              style: GoogleFonts.roboto(
                                fontSize: media.width * fourteen,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              ' ${_bcMoney(discountAmount)}',
                              style: GoogleFonts.roboto(
                                fontSize: media.width * fourteen,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
