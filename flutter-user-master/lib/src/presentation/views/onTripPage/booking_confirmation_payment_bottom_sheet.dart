import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';

class BookingConfirmationPaymentBottomSheet extends StatefulWidget {
  const BookingConfirmationPaymentBottomSheet({
    super.key,
    required this.paymentTypes,
    required this.initialPayingVia,
    required this.onPaymentSelected,
  });

  final List<String> paymentTypes;
  final int initialPayingVia;
  final ValueChanged<int> onPaymentSelected;

  @override
  State<BookingConfirmationPaymentBottomSheet> createState() =>
      _BookingConfirmationPaymentBottomSheetState();
}

class _BookingConfirmationPaymentBottomSheetState
    extends State<BookingConfirmationPaymentBottomSheet> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = (widget.paymentTypes.isNotEmpty &&
            widget.initialPayingVia >= 0 &&
            widget.initialPayingVia < widget.paymentTypes.length)
        ? widget.initialPayingVia
        : 0;
  }

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: page,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.text_paymentmethod, // "Способы оплаты"
                style: GoogleFonts.roboto(
                  fontSize: media.width * 0.055,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Divider(height: 1, color: borderLines),
              const SizedBox(height: 10),

              // Один пункт как на фото
              _PaymentRow(
                title: 'Наличные',
                isSelected: true,
                onTap: () {
                  setState(() => _selectedIndex = 0);
                  widget.onPaymentSelected(0);
                },
              ),

              const SizedBox(height: 14),

              // "Добавить карту" — пустышка
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: add card (placeholder)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3D36B),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Добавить карту',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // "Готово"
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _close,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9EDF2),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    context.l10n.text_done,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _paymentTitle(BuildContext context) {
    // На фото "Наличные".
    // Если хочешь — можно брать из paymentTypes[0], но тут сделал безопасно.
    if (widget.paymentTypes.isNotEmpty) return widget.paymentTypes.first;
    return context.l10n.text_cash ?? 'Наличные';
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8F6EE),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.payments_outlined,
                  size: 18, color: Color(0xFF18A558)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: media.width * 0.042,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF22C55E),
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
