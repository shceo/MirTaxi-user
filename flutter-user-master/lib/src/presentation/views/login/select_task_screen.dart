import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/design/tokens.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/create_task_screen.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/map_page.dart';

class SelectTaskScreen extends StatefulWidget {
  const SelectTaskScreen({super.key});

  @override
  State<SelectTaskScreen> createState() => _SelectTaskScreenState();
}

class _SelectTaskScreenState extends State<SelectTaskScreen> {
  void _openChild() => Navigator.push(context,
      MaterialPageRoute(builder: (_) => const CreateTaskScreen(id: 2)));

  void _openCorporate() => Navigator.push(context,
      MaterialPageRoute(builder: (_) => const CreateTaskScreen(id: 1)));

  void _openTaxi() => Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => const Maps()), (_) => false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    MtSpace.screenX, MtSpace.lg, MtSpace.screenX, MtSpace.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 56,
                        fit: BoxFit.contain,
                        semanticLabel: 'Mir Taxi',
                      ),
                    ),
                    const SizedBox(height: MtSpace.x3l),
                    Text(
                      context.l10n.text_choose_service,
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  MtSpace.screenX, 0, MtSpace.screenX, MtSpace.x3l),
              sliver: SliverList.separated(
                itemCount: 3,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: MtSpace.lg),
                itemBuilder: (context, i) {
                  switch (i) {
                    case 0:
                      return _ServiceCard(
                        asset: 'assets/images/child_car.png',
                        label: context.l10n.text_service_child,
                        onTap: _openChild,
                      );
                    case 1:
                      return _ServiceCard(
                        asset: 'assets/images/business_car.png',
                        label: context.l10n.text_service_corporate,
                        onTap: _openCorporate,
                      );
                    default:
                      return _ServiceCard(
                        asset: 'assets/images/taxi_car.png',
                        label: context.l10n.text_service_taxi,
                        onTap: _openTaxi,
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Карточка услуги.
///
/// Иллюстрация берётся из исходного PNG, но обрезается: в нижней трети каждой
/// картинки была запечена подпись по-русски, из-за чего экран не переводился
/// на английский и узбекский. Теперь подпись — обычный текст из локализации.
class _ServiceCard extends StatefulWidget {
  const _ServiceCard({
    required this.asset,
    required this.label,
    required this.onTap,
  });

  final String asset;
  final String label;
  final VoidCallback onTap;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1,
          duration: MtDuration.fast,
          curve: MtCurves.enter,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: MtRadius.brXl,
              border: Border.all(color: scheme.outlineVariant),
              boxShadow: MtShadow.card(theme.brightness == Brightness.dark),
            ),
            child: Row(
              children: [
                // Машина вырезана из исходного PNG: там она лежала на цветной
                // плашке вместе с вшитой подписью, из-за чего экран не
                // переводился, а плашка не стыковалась с краями карточки.
                SizedBox(
                  width: 116,
                  height: 76,
                  child: Padding(
                    padding: const EdgeInsets.all(MtSpace.sm),
                    child: Image.asset(
                      widget.asset,
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.label,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: MtSpace.sm),
                Padding(
                  padding: const EdgeInsets.only(right: MtSpace.md),
                  child: Icon(
                    Icons.chevron_right,
                    color: scheme.onSurfaceVariant,
                    size: MtSize.icon,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
