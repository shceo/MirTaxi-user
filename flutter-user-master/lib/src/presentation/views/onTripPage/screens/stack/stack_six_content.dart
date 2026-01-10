import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_state.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/app/app_svg_icon.dart';

class StackSixCollapsedContent extends StatelessWidget {
  final Function(int i) onChange4;
  final Function(int i) onChange5;
  final Function(int i) onChange6;

  const StackSixCollapsedContent({
    super.key,
    required this.onChange4,
    required this.onChange5,
    required this.onChange6,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          if (lastAddress.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  for (int i = 0;
                      i < (lastAddress.length > 3 ? 3 : lastAddress.length);
                      i++)
                    InkWell(
                      onTap: () => onChange6(i),
                      child: Container(
                        width: media.width * 0.9,
                        padding: EdgeInsets.only(
                            top: media.width * 0.04,
                            bottom: media.width * 0.04),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(201, 201, 201, 1),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AppSvgAsset('assets/icons/location.svg'),
                            SizedBox(
                              width: media.width * 0.8,
                              child: Text(
                                lastAddress[i].dropAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: media.width * twenty,
                                  color: textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          StackSixAutoFillList(
            onChange4: onChange4,
            onChange5: onChange5,
          ),
        ],
      ),
    );
  }
}

class StackSixExpandedContent extends StatelessWidget {
  final bool pickaddress;
  final bool dropaddress;
  final ValueChanged<String> onSearchChanged;
  final Function(int i) onChange4;
  final Function(int i) onChange5;
  final Function(int i) onChange6;
  final VoidCallback onChange7;

  const StackSixExpandedContent({
    super.key,
    required this.pickaddress,
    required this.dropaddress,
    required this.onSearchChanged,
    required this.onChange4,
    required this.onChange5,
    required this.onChange6,
    required this.onChange7,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    final pickupMatches =
        addressList.where((element) => element.id == 'pickup');
    final headerText = pickupMatches.isNotEmpty
        ? pickupMatches.first.address
        : (lastAddress.isNotEmpty ? lastAddress.first.dropAddress : '');

    return Directionality(
      textDirection:
          (languageDirection == 'rtl') ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        width: media.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 8),
            const _SheetHandle(),
            const SizedBox(height: 10),
            if (headerText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CurrentAddressRow(text: headerText),
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SearchBar(
                hint: 'Куда поедем?',
                mapText: 'Карта',
                onMapTap: onChange7,
                onChanged: onSearchChanged,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
            _AddressList(
              maxItems: 4,
              onTap: onChange6,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFD1D5DB),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _CurrentAddressRow extends StatelessWidget {
  final String text;
  const _CurrentAddressRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 8, color: Color(0xFF111827)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String hint;
  final String mapText;
  final VoidCallback onMapTap;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.hint,
    required this.mapText,
    required this.onMapTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          Container(width: 1, height: 22, color: const Color(0xFFE5E7EB)),
          InkWell(
            onTap: onMapTap,
            child: SizedBox(
              width: 64,
              height: double.infinity,
              child: Center(
                child: Text(
                  mapText,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressList extends StatelessWidget {
  final int maxItems;
  final Function(int i) onTap;

  const _AddressList({
    required this.maxItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final count = lastAddress.length > maxItems ? maxItems : lastAddress.length;

    if (count == 0) {
      return const SizedBox(height: 280);
    }

    return Column(
      children: List.generate(count, (i) {
        final title = lastAddress[i].dropAddress;
        return _AddressTile(
          title: title,
          subtitle: 'Ташкент',
          onTap: () => onTap(i),
        );
      }),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AddressTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 20, color: Color(0xFF9CA3AF)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 22, color: Color(0xFF111827)),
          ],
        ),
      ),
    );
  }
}

class StackSixAutoFillList extends StatelessWidget {
  final Function(int i) onChange4;
  final Function(int i) onChange5;

  const StackSixAutoFillList({
    super.key,
    required this.onChange4,
    required this.onChange5,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    if (addAutoFill.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: addAutoFill.asMap().entries.map((entry) {
        final i = entry.key;

        if (i >= 5) return const SizedBox.shrink();

        return Container(
          padding:
              EdgeInsets.fromLTRB(0, media.width * 0.04, 0, media.width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: media.width * 0.1,
                width: media.width * 0.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: const Icon(Icons.access_time),
              ),
              InkWell(
                onTap: () => onChange4(i),
                child: SizedBox(
                  width: media.width * 0.7,
                  child: Text(
                    addAutoFill[i]['description'],
                    style: GoogleFonts.roboto(
                      fontSize: media.width * twelve,
                      color: textColor,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
              if (favAddress.length < 4)
                InkWell(
                  onTap: () => onChange5(i),
                  child: Icon(
                    Icons.favorite_outline,
                    size: media.width * 0.05,
                    color: favAddress
                            .where((e) =>
                                e['pick_address'] ==
                                addAutoFill[i]['description'])
                            .isNotEmpty
                        ? buttonColor
                        : Colors.black,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
