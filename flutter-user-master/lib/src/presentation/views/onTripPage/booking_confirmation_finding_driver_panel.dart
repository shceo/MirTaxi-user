part of 'booking_confirmation.dart';

extension _BookingConfirmationFindingDriverPanel on _BookingConfirmationState {
  Widget buildFindingDriverPanel(Size media) {
    final bool shouldShow = userRequestData.isNotEmpty &&
        userRequestData['accepted_at'] == null &&
        (userRequestData['is_later'] == null ||
            userRequestData['is_later'] == 0);

    if (!shouldShow) return const SizedBox.shrink();

    final int t = (timing ?? 0);
    final int maxTime = int.tryParse(
          userDetails['maximum_time_for_find_drivers_for_regular_ride']
              .toString(),
        ) ??
        1;

    final double progress = (t / maxTime).clamp(0.0, 1.0);

    String mmss(int seconds) {
      final d = Duration(seconds: seconds);
      final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$mm:$ss';
    }

    Widget actionButton({
      required Color bg,
      required IconData icon,
      required Color iconColor,
      required String label,
      VoidCallback? onTap,
    }) {
      final double size = media.width * 0.14; // ~56 при ширине ~400
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: size * 0.5),
            ),
            SizedBox(height: media.height * 0.01),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: media.width * 0.035,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ],
        ),
      );
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: Container(
          width: media.width,
          decoration: BoxDecoration(
            color: page, // если надо строго белое — поставь Colors.white
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(media.width * 0.04),
              topRight: Radius.circular(media.width * 0.04),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            media.width * 0.06,
            media.width * 0.05,
            media.width * 0.06,
            media.width * 0.04,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Как мы ищем\nмашину>',
                      style: GoogleFonts.roboto(
                        fontSize: media.width * 0.045,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                      ),
                    ),
                  ),
                  Text(
                    mmss(t),
                    style: GoogleFonts.roboto(
                      fontSize: media.width * 0.045,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: media.height * 0.008),
              Text(
                'Чтобы она приехала\nбыстрее',
                style: GoogleFonts.roboto(
                  fontSize: media.width * 0.038,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                ),
              ),
              SizedBox(height: media.height * 0.015),

              // progress
              ClipRRect(
                borderRadius: BorderRadius.circular(media.width * 0.01),
                child: Container(
                  height: media.width * 0.012,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.35),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: const Color.fromRGBO(0, 247, 1, 1),
                    ),
                  ),
                ),
              ),

              SizedBox(height: media.height * 0.03),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  actionButton(
                    bg: const Color(0xFFE74C3C),
                    icon: Icons.close,
                    iconColor: Colors.white,
                    label: 'Отменить\nпоездку',
                    onTap: () {
                      _updateState(() {
                        _cancelModalFromFindingDriver = true;
                        _cancellingError = '';
                        _cancelReason = '';
                        _cancelCustomReason = '';
                        cancelReasonsList = [
                          {'reason': 'Мне больше не нужно в это место'},
                          {'reason': 'Я хочу изменить детали поездки'},
                          {'reason': 'Ребенок заболел'},
                          {'reason': 'Другая причина'},
                        ];
                        _cancelling = true;
                      });
                    },
                  ),
                  actionButton(
                    bg: const Color(0xFFEDEDED),
                    icon: Icons.menu,
                    iconColor: Colors.black54,
                    label: 'Детали',
                    onTap: () {
                      // TODO: открой детали (если у тебя есть метод)
                    },
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
