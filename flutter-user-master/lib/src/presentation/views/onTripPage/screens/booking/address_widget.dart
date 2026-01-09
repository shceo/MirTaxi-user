import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/data/models/address_list.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/app/app_svg_icon.dart';

class AddressWidget extends StatelessWidget {
  final Map<String, dynamic> userRequestData;
  final List<AddressList> addressList;

  const AddressWidget({
    super.key,
    required this.userRequestData,
    required this.addressList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (userRequestData.isNotEmpty)
            ? textWidget(userRequestData['pick_address'], 'start')
            : (addressList.where((e) => e.id == 'drop').isNotEmpty)
                ? textWidget(
                    addressList
                        .firstWhere((element) => element.id == 'pickup')
                        .address,
                    'start')
                : Container(),
        (userRequestData.isNotEmpty)
            ? textWidget(userRequestData['drop_address'], 'finish')
            : (addressList.where((e) => e.id == 'drop').isNotEmpty)
                ? textWidget(
                    addressList
                        .firstWhere((element) => element.id == 'drop')
                        .address,
                    'finish')
                : Container(),
      ],
    );
  }

  Widget textWidget(String text, String icon) {
    return Row(
      children: [
        AppSvgAsset('assets/icons/$icon.svg'),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(201, 201, 201, 1),
                ),
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
