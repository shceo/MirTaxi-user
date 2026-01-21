import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_state.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/NavigatorPages/historydetails.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool _isLoading = true;
  String _periodLabel = 'За этот месяц';

  @override
  void initState() {
    _isLoading = true;
    _getHistory();
    super.initState();
  }

  _getHistory() async {
    setState(() {
      myHistoryPage.clear();
      myHistory.clear();
      _isLoading = true;
    });

    final val = await getHistory('is_completed=1');

    if (val == 'success') {
      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Material(
      child: ValueListenableBuilder(
        valueListenable: valueNotifierBook.value,
        builder: (context, value, child) {
          return Directionality(
            textDirection: (languageDirection == 'rtl') ? TextDirection.rtl : TextDirection.ltr,
            child: Stack(
              children: [
                Container(
                  height: media.height,
                  width: media.width,
                  color: const Color(0xFFF4F4F4),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.08),
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  height: 38,
                                  width: 38,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF3F3F3),
                                  ),
                                  child: const Icon(Icons.close, color: Colors.black, size: 22),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    context.l10n.text_enable_history,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 38),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                'История',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  final picked = await showModalBottomSheet<String>(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    builder: (ctx) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 4,
                                              width: 44,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE0E0E0),
                                                borderRadius: BorderRadius.circular(99),
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            _BottomSheetItem(
                                              text: 'За этот месяц',
                                              onTap: () => Navigator.pop(ctx, 'За этот месяц'),
                                            ),
                                            _BottomSheetItem(
                                              text: 'За прошлый месяц',
                                              onTap: () => Navigator.pop(ctx, 'За прошлый месяц'),
                                            ),
                                            _BottomSheetItem(
                                              text: 'За всё время',
                                              onTap: () => Navigator.pop(ctx, 'За всё время'),
                                            ),
                                            const SizedBox(height: 6),
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                  if (picked != null && picked != _periodLabel) {
                                    setState(() => _periodLabel = picked);
                                  }
                                },
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD66B),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _periodLabel,
                                        style: GoogleFonts.roboto(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: (myHistory.isNotEmpty)
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                                  itemCount: _computedItemCount(),
                                  itemBuilder: (context, index) {
                                    final entry = _itemAt(index);
                                    if (entry is _DateHeader) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            entry.label,
                                            style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF9E9E9E),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    if (entry is _LoadMore) {
                                      return _buildLoadMore(media);
                                    }

                                    final i = entry as int;

                                    final pickTitle = _shortTitle(myHistory[i]['pick_address']);
                                    final dropTitle = _shortTitle(myHistory[i]['drop_address']);

                                    final startTime = _extractTime(myHistory[i]['trip_start_time']) ??
                                        _extractTime(myHistory[i]['accepted_at']) ??
                                        '';

                                    final endTime = _extractTime(myHistory[i]['completed_at']) ??
                                        _extractTime(myHistory[i]['updated_at']) ??
                                        '';

                                    final driverName = _safeStr(myHistory[i]['driverDetail']?['data']?['name']) ??
                                        _safeStr(myHistory[i]['driver']?['name']) ??
                                        _safeStr(myHistory[i]['user']?['name']) ??
                                        '';

                                    final driverPhoto = _safeStr(myHistory[i]['driverDetail']?['data']?['profile_picture']) ??
                                        _safeStr(myHistory[i]['driver']?['profile_picture']) ??
                                        '';

                                    final rating = _safeStr(myHistory[i]['driverDetail']?['data']?['rating']) ??
                                        _safeStr(myHistory[i]['driver']?['rating']) ??
                                        '4.9';

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: InkWell(
                                        onTap: () {
                                          selectedHistory = i;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const HistoryDetails()),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: _HistoryCard(
                                          pickTitle: pickTitle ?? '—',
                                          dropTitle: dropTitle ?? '—',
                                          startTime: startTime,
                                          endTime: endTime,
                                          driverName: driverName.isEmpty ? '—' : driverName,
                                          driverPhoto: driverPhoto,
                                          rating: rating,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : (!_isLoading)
                                  ? SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: media.width * 0.7,
                                            width: media.width * 0.7,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('assets/images/nodatafound.gif'),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            context.l10n.text_no_data_found,
                                            style: GoogleFonts.roboto(
                                              fontSize: media.width * sixteen,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (internet == false)
                  Positioned(
                    top: 0,
                    child: NoInternet(
                      onTap: () {
                        setState(() {
                          internetTrue();
                        });
                      },
                    ),
                  ),
                if (_isLoading) const Positioned(top: 0, left: 0, right: 0, child: Loading()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadMore(Size media) {
    if (myHistoryPage['pagination'] == null) return const SizedBox.shrink();

    final pagination = myHistoryPage['pagination'];
    final current = pagination['current_page'];
    final total = pagination['total_pages'];

    if (current == null || total == null || current >= total) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: InkWell(
        onTap: () async {
          setState(() => _isLoading = true);
          await getHistoryPages('is_completed=1&page=${current + 1}');
          setState(() => _isLoading = false);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(media.width * 0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
          ),
          child: Text(
            context.l10n.text_loadmore,
            style: GoogleFonts.roboto(fontSize: media.width * sixteen, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  int _computedItemCount() {
    final items = _buildItems();
    return items.length;
  }

  dynamic _itemAt(int index) {
    final items = _buildItems();
    return items[index];
  }

  List<dynamic> _buildItems() {
    final items = <dynamic>[];
    String? lastDate;

    for (int i = 0; i < myHistory.length; i++) {
      final raw = _safeStr(myHistory[i]['accepted_at']) ??
          _safeStr(myHistory[i]['trip_start_time']) ??
          _safeStr(myHistory[i]['updated_at']) ??
          _safeStr(myHistory[i]['created_at']) ??
          '';

      final dateLabel = _formatDayMonth(raw);

      if (dateLabel != null && dateLabel != lastDate) {
        items.add(_DateHeader(dateLabel));
        lastDate = dateLabel;
      }

      items.add(i);
    }

    if (myHistoryPage['pagination'] != null) {
      final pagination = myHistoryPage['pagination'];
      final current = pagination['current_page'];
      final total = pagination['total_pages'];
      if (current != null && total != null && current < total) {
        items.add(_LoadMore());
      }
    }

    return items;
  }
}

class _HistoryCard extends StatelessWidget {
  final String pickTitle;
  final String dropTitle;
  final String startTime;
  final String endTime;
  final String driverName;
  final String driverPhoto;
  final String rating;

  const _HistoryCard({
    required this.pickTitle,
    required this.dropTitle,
    required this.startTime,
    required this.endTime,
    required this.driverName,
    required this.driverPhoto,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _RouteDots(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      _AddressRow(
                        title: pickTitle,
                        time: startTime,
                      ),
                      const SizedBox(height: 10),
                      _AddressRow(
                        title: dropTitle,
                        time: endTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: const Color(0xFFF0F0F0)),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF7F7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                _Avatar(url: driverPhoto),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    driverName,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF444444),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC107)),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final String title;
  final String time;

  const _AddressRow({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5A5A5A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          time,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF777777),
          ),
        ),
      ],
    );
  }
}

class _RouteDots extends StatelessWidget {
  const _RouteDots();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      child: Column(
        children: [
          Container(
            height: 14,
            width: 14,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF7C3AED),
            ),
            child: Center(
              child: Container(
                height: 6,
                width: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 26,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (i) => Container(
                  height: 2,
                  width: 2,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Icon(Icons.location_on_rounded, color: Color(0xFFFF2D55), size: 18),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String url;

  const _Avatar({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEDEDED),
        image: (url.isNotEmpty)
            ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
            : null,
      ),
      child: url.isEmpty
          ? const Icon(Icons.person, size: 18, color: Color(0xFF9E9E9E))
          : null,
    );
  }
}

class _BottomSheetItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _BottomSheetItem({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _DateHeader {
  final String label;
  _DateHeader(this.label);
}

class _LoadMore {}

String? _safeStr(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  if (s.isEmpty) return null;
  return s;
}

String? _shortTitle(dynamic address) {
  final s = _safeStr(address);
  if (s == null) return null;
  final parts = s.split(',');
  return parts.isNotEmpty ? parts.first.trim() : s;
}

String? _extractTime(dynamic raw) {
  final s = _safeStr(raw);
  if (s == null) return null;

  final dt = _tryParseDateTime(s);
  if (dt != null) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  final m = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(s);
  if (m != null) {
    final hh = m.group(1)!.padLeft(2, '0');
    final mm = m.group(2)!;
    return '$hh:$mm';
  }

  return null;
}

String? _formatDayMonth(String raw) {
  final dt = _tryParseDateTime(raw);
  if (dt == null) return null;

  const months = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  return '${dt.day} ${months[dt.month - 1]}';
}

DateTime? _tryParseDateTime(String s) {
  try {
    final normalized = s.replaceAll('T', ' ').split('.').first;
    return DateTime.tryParse(normalized);
  } catch (_) {
    return null;
  }
}
