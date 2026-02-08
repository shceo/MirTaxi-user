part of 'booking_confirmation.dart';

extension _BookingConfirmationOnTripPanel on _BookingConfirmationState {
  Widget buildOnTripPanel(Size media) {
    if (userRequestData.isEmpty || userRequestData['accepted_at'] == null) {
      return const SizedBox.shrink();
    }

    // --- helper: driver map safe
    Map driverData = {};
    final dd = userRequestData['driverDetail'];
    if (dd is Map && dd['data'] is Map) {
      driverData = dd['data'] as Map;
    } else if (dd is Map) {
      driverData = dd;
    }

    String? readNested(Map m, List<String> path) {
      dynamic cur = m;
      for (final k in path) {
        if (cur is Map && cur[k] != null) {
          cur = cur[k];
        } else {
          return null;
        }
      }
      return cur.toString();
    }

    // ETA
    final int etaMin =
        (_dist != null) ? (double.tryParse((_dist * 2).toString())?.round() ?? 5) : 5;

    // API fields
    final String carColor = (driverData['car_color'] ?? '').toString();
    final String carMake = (driverData['car_make_name'] ?? '').toString();
    final String carLine = ('${carColor.trim()} ${carMake.trim()}'.trim()).isNotEmpty
        ? ('${carColor.trim()} ${carMake.trim()}'.trim())
        : 'серый BVD';

    final String plate = (driverData['car_number'] ?? '').toString().trim().isNotEmpty
        ? driverData['car_number'].toString()
        : '10S618UA';

    final String driverName = (driverData['name'] ?? '').toString().trim().isNotEmpty
        ? driverData['name'].toString()
        : 'Eshmatboy';

    final String rating = (driverData['rating'] ?? '').toString().trim().isNotEmpty
        ? driverData['rating'].toString()
        : '4.84';

    final String? avatarUrl =
        (driverData['profile_picture'] ?? driverData['profilePicture'])?.toString();

    final String pickupAddress =
        readNested(userRequestData, ['pickup_address']) ??
            readNested(userRequestData, ['pick_address']) ??
            readNested(userRequestData, ['pickup', 'address']) ??
            readNested(userRequestData, ['start_address']) ??
            'улица Богишамол, 1';

    final String dropoffAddress =
        readNested(userRequestData, ['dropoff_address']) ??
            readNested(userRequestData, ['drop_address']) ??
            readNested(userRequestData, ['dropoff', 'address']) ??
            readNested(userRequestData, ['destination_address']) ??
            'проспект Амира Темура, 95А';

    // UI constants
    final double radius = media.width * 0.055; // чуть больше — как на iOS
    final EdgeInsets pad = EdgeInsets.symmetric(horizontal: media.width * 0.04);

    Widget handle() => Center(
          child: Container(
            width: media.width * 0.12,
            height: media.width * 0.012,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(210, 210, 210, 1),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );

    BoxDecoration cardDecoration() => BoxDecoration(
          color: page,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        );

    Widget topDriverCard() {
      return Container(
        decoration: cardDecoration(),
        padding: EdgeInsets.fromLTRB(
          media.width * 0.045,
          media.width * 0.03,
          media.width * 0.045,
          media.width * 0.04,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            handle(),
            SizedBox(height: media.width * 0.03),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Через ≈ ${etaMin}мин приедет>',
                        style: GoogleFonts.roboto(
                          fontSize: media.width * 0.048,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: media.width * 0.01),
                      Text(
                        carLine,
                        style: GoogleFonts.roboto(
                          fontSize: media.width * 0.042,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(120, 120, 120, 1),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(237, 238, 242, 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: media.width * 0.03,
                    vertical: media.width * 0.016,
                  ),
                  child: Text(
                    plate,
                    style: GoogleFonts.roboto(
                      fontSize: media.width * 0.042,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: media.width * 0.03),
            Container(height: 1, color: const Color.fromRGBO(220, 220, 220, 1)),
            SizedBox(height: media.width * 0.035),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: media.width * 0.18,
                      width: media.width * 0.20,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: media.width * 0.16,
                              width: media.width * 0.16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: (avatarUrl != null && avatarUrl.isNotEmpty)
                                    ? DecorationImage(
                                        image: NetworkImage(avatarUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: const Color.fromRGBO(235, 235, 235, 1),
                              ),
                              child: (avatarUrl == null || avatarUrl.isEmpty)
                                  ? Icon(Icons.person,
                                      size: media.width * 0.08, color: Colors.black45)
                                  : null,
                            ),
                          ),
                          Positioned(
                            top: media.width * 0.015,
                            right: media.width * 0.03,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 6,
                                    color: Color.fromRGBO(0, 0, 0, 0.18),
                                  ),
                                ],
                              ),
                              child: Text(
                                rating,
                                style: GoogleFonts.roboto(
                                  fontSize: media.width * 0.032,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driverName,
                      style: GoogleFonts.roboto(
                        fontSize: media.width * 0.036,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(150, 150, 150, 1),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: media.width * 0.10),

                Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {
                        makingPhoneCall((driverData['mobile'] ?? '').toString());
                      },
                      child: Container(
                        height: media.width * 0.16,
                        width: media.width * 0.16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(32, 173, 57, 1),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.phone, color: Colors.white, size: media.width * 0.075),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Позвонить',
                      style: GoogleFonts.roboto(
                        fontSize: media.width * 0.036,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(150, 150, 150, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget addressCard() {
      Widget row({
        required Widget leftIcon,
        required String title,
        required String value,
        bool showChevron = false,
        bool isTop = false,
      }) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: media.width * 0.045,
            vertical: media.width * 0.03,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: media.width * 0.11, child: Center(child: leftIcon)),
              SizedBox(width: media.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: media.width * 0.030,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(160, 160, 160, 1),
                      ),
                    ),
                    SizedBox(height: media.width * 0.01),
                    Text(
                      value,
                      style: GoogleFonts.roboto(
                        fontSize: media.width * 0.038,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (showChevron)
                Icon(Icons.chevron_right, color: Colors.black54, size: media.width * 0.06),
            ],
          ),
        );
      }

      return Container(
        decoration: cardDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            row(
              leftIcon: Container(
                height: media.width * 0.09,
                width: media.width * 0.09,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(32, 173, 57, 1),
                ),
                child: Icon(Icons.person_pin, color: Colors.white, size: media.width * 0.055),
              ),
              title: 'Подача',
              value: pickupAddress,
              showChevron: true,
            ),
            Container(height: 1, color: const Color.fromRGBO(220, 220, 220, 1)),
            row(
              leftIcon: Icon(Icons.flag, color: Colors.black87, size: media.width * 0.06),
              title: 'Прибытие',
              value: dropoffAddress,
            ),
          ],
        ),
      );
    }

    Widget paymentCard() {
      return Container(
        decoration: cardDecoration(),
        padding: EdgeInsets.symmetric(
          horizontal: media.width * 0.045,
          vertical: media.width * 0.03,
        ),
        child: Row(
          children: [
            Icon(Icons.payments_outlined, color: const Color.fromRGBO(32, 173, 57, 1),
                size: media.width * 0.075),
            SizedBox(width: media.width * 0.03),
            Expanded(
              child: Text(
                'Наличными: 12000 сум',
                style: GoogleFonts.roboto(
                  fontSize: media.width * 0.038,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(237, 238, 242, 1),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: media.width * 0.04,
                vertical: media.width * 0.02,
              ),
              child: Text(
                'Изменить',
                style: GoogleFonts.roboto(
                  fontSize: media.width * 0.032,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget listRow({
      required IconData icon,
      required String title,
      VoidCallback? onTap,
      bool showChevron = true,
      Color iconColor = const Color.fromRGBO(32, 173, 57, 1),
    }) {
      return InkWell(
        onTap: onTap,
        child: Container(
          decoration: cardDecoration(),
          padding: EdgeInsets.symmetric(
            horizontal: media.width * 0.045,
            vertical: media.width * 0.03,
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: media.width * 0.07),
              SizedBox(width: media.width * 0.03),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: media.width * 0.038,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              if (showChevron)
                Icon(Icons.chevron_right, color: Colors.red, size: media.width * 0.06),
            ],
          ),
        ),
      );
    }

    Widget cancelRow() {
      return InkWell(
        onTap: () async {
          // оставил твою логику отмены — как было
          _updateState(() {
            _isLoading = true;
          });
          var reason = await cancelReason(
            (userRequestData['is_driver_arrived'] == 0) ? 'before' : 'after',
          );
          if (reason == true) {
            _updateState(() {
              _cancellingError = '';
              _cancelling = true;
            });
          }
          _updateState(() {
            _isLoading = false;
          });
        },
        child: Container(
          decoration: cardDecoration(),
          padding: EdgeInsets.symmetric(
            horizontal: media.width * 0.045,
            vertical: media.width * 0.03,
          ),
          child: Row(
            children: [
              Icon(Icons.close, color: Colors.red, size: media.width * 0.07),
              SizedBox(width: media.width * 0.03),
              Expanded(
                child: Text(
                  'Отменить поездку',
                  style: GoogleFonts.roboto(
                    fontSize: media.width * 0.038,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.red, size: media.width * 0.06),
            ],
          ),
        ),
      );
    }

    Widget actionButtons() {
      Widget one({
        required IconData icon,
        required String label,
        VoidCallback? onTap,
      }) {
        final double s = media.width * 0.16;
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: s,
                width: s,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(237, 238, 242, 1),
                ),
                child: Icon(icon, color: Colors.black87, size: s * 0.45),
              ),
              SizedBox(height: media.width * 0.02),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: media.width * 0.032,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(150, 150, 150, 1),
                ),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.only(top: media.width * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            one(icon: Icons.near_me, label: 'Отправить\nмаршрут', onTap: () {}),
            one(icon: Icons.add, label: 'Заказать\nещё', onTap: () {}),
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
        child: DraggableScrollableSheet(
          initialChildSize: 0.46, // свернуто (как первый скрин)
          minChildSize: 0.34,
          maxChildSize: 0.92,     // развернуто (как второй скрин)
          snap: true,
          snapSizes: const [0.46, 0.92],
          builder: (context, scrollController) {
            return Container(
              // сам “sheet” без фона, фон у карточек
              color: Colors.transparent,
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: pad.left,
                    right: pad.right,
                    bottom: media.width * 0.06,
                    top: media.width * 0.02,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      topDriverCard(),
                      SizedBox(height: media.width * 0.03),
                      addressCard(),
                      SizedBox(height: media.width * 0.03),

                      // Всё ниже — видно только в expanded (но можно оставить — будет просто ниже зоны)
                      paymentCard(),
                      SizedBox(height: media.width * 0.03),
                      listRow(
                        icon: Icons.info_outline,
                        title: 'Детали заказа',
                        onTap: () {},
                        showChevron: true,
                      ),
                      SizedBox(height: media.width * 0.03),
                      cancelRow(),
                      SizedBox(height: media.width * 0.04),
                      actionButtons(),
                      SizedBox(height: media.width * 0.02),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
