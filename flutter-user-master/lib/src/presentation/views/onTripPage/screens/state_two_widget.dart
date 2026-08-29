import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/design/tokens.dart';

/// Экран запроса геолокации — первое, что видит пользователь на карте.
///
/// Было: маркетинговый слоган «Самое надёжное приложение для бронирования
/// такси» вместо объяснения, зачем нужен доступ, и текст, разорванный на два
/// отдельных Text-виджета — из-за чего два предложения слипались на экране
/// («Чтобы насладиться поездкой Пожалуйста, предоставьте...»).
class StateTwoWidget extends StatelessWidget {
  final Function() onTap;

  const StateTwoWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // Высоту задаём явно: родитель (Stack в map_page) даёт неограниченные
    // constraints, и Spacer внутри Column без этого падает с
    // «RenderFlex children have non-zero flex but incoming height
    // constraints are unbounded».
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: double.infinity,
      color: scheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: MtSpace.screenX),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/allow_location_permission.png',
                height: 220,
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
              const SizedBox(height: MtSpace.x3l),
              Text(
                context.l10n.text_location_title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: MtSpace.md),
              Text(
                context.l10n.text_location_why,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: MtSpace.x3l),
              _Reason(
                icon: Icons.my_location_outlined,
                text: context.l10n.text_location_reason_pickup,
              ),
              const SizedBox(height: MtSpace.lg),
              _Reason(
                icon: Icons.local_taxi_outlined,
                text: context.l10n.text_location_reason_cars,
              ),
              const Spacer(flex: 3),
              FilledButton(
                onPressed: onTap,
                child: Text(context.l10n.text_continue),
              ),
              const SizedBox(height: MtSpace.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _Reason extends StatelessWidget {
  const _Reason({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          height: MtSize.controlSm,
          width: MtSize.controlSm,
          decoration: const BoxDecoration(
            color: MtColors.brand50,
            borderRadius: MtRadius.brMd,
          ),
          child: Icon(icon, size: MtSize.iconSm, color: MtColors.brand600),
        ),
        const SizedBox(width: MtSpace.md),
        Expanded(
          child: Text(text, style: theme.textTheme.bodyLarge),
        ),
      ],
    );
  }
}
