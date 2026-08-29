import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_state.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/data/models/address_list.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/design/tokens.dart';

/// Шапка карты с адресом подачи.
///
/// Было: блок с градиентом из белого в прозрачный, из-за которого подпись
/// «Ваш адрес» и строка адреса выглядели незакреплёнными и налезали на кнопку
/// меню. Плюс размеры считались от ширины экрана.
class StackThreeWidget extends StatelessWidget {
  final int bottom;
  final bool pickaddress;
  final Function() changePosition;
  final Function(String) addDirections;
  final Function() pickup;

  const StackThreeWidget({
    super.key,
    required this.bottom,
    required this.pickaddress,
    required this.changePosition,
    required this.addDirections,
    required this.pickup,
  });

  AddressList? get _pickup {
    final matches = addressList.where((e) => e.id == 'pickup');
    return matches.isEmpty ? null : matches.first;
  }

  bool get _isFavourite {
    final address = _pickup?.address;
    if (address == null) return false;
    return favAddress.any((e) => e['pick_address'] == address);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final pickupAddress = _pickup?.address;
    final editing = pickaddress && bottom == 1;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          // Слева оставлено место под кнопку меню, которая лежит отдельным
          // слоем в map_page.
          padding: const EdgeInsets.fromLTRB(
              MtSize.control + MtSpace.lg, MtSpace.sm, MtSpace.lg, 0),
          child: Material(
            color: scheme.surface,
            borderRadius: MtRadius.brLg,
            elevation: 0,
            child: InkWell(
              onTap: changePosition,
              borderRadius: MtRadius.brLg,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: MtRadius.brLg,
                  border: Border.all(color: scheme.outlineVariant),
                  boxShadow: MtShadow.card(
                      theme.brightness == Brightness.dark),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: MtSpace.lg, vertical: MtSpace.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.text_your_address,
                            style: theme.textTheme.labelMedium,
                          ),
                          const SizedBox(height: MtSpace.xs),
                          if (editing)
                            TextField(
                              autofocus: true,
                              maxLines: 1,
                              onChanged: addDirections,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: false,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText:
                                    context.l10n.text_4lettersforautofill,
                                hintStyle: theme.textTheme.bodyLarge
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                            )
                          else
                            Text(
                              pickupAddress ??
                                  context.l10n.text_4lettersforautofill,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: pickupAddress == null
                                    ? scheme.onSurfaceVariant
                                    : scheme.onSurface,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!editing && pickupAddress != null && favAddress.length < 4)
                      IconButton(
                        onPressed: pickup,
                        icon: Icon(
                          _isFavourite
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: _isFavourite
                              ? MtColors.brand500
                              : scheme.onSurfaceVariant,
                          size: MtSize.icon,
                        ),
                        tooltip: context.l10n.text_saveaddressas,
                        constraints: const BoxConstraints(
                          minWidth: MtSize.minTouch,
                          minHeight: MtSize.minTouch,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
