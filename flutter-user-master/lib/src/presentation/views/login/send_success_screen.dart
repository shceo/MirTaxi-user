import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/design/tokens.dart';

class SendSuccessScreen extends StatelessWidget {
  final String desc;

  const SendSuccessScreen({super.key, required this.desc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // Экран принимал ответ сервера в `desc`, но не показывал его: вместо
    // этого стоял захардкоженный русский текст про детскую перевозку. При
    // корпоративной заявке человек читал, что зарегистрирована заявка на
    // перевозку ребёнка.
    final message =
        desc.trim().isNotEmpty ? desc.trim() : context.l10n.text_request_sent_desc;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: MtSpace.screenX),
          child: Column(
            children: [
              const Spacer(),
              Container(
                height: 88,
                width: 88,
                decoration: const BoxDecoration(
                  color: MtColors.successSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: MtColors.success, size: 44),
              ),
              const SizedBox(height: MtSpace.xxl),
              Text(
                context.l10n.text_request_sent,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: MtSpace.md),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: Text(context.l10n.text_close),
              ),
              const SizedBox(height: MtSpace.lg),
            ],
          ),
        ),
      ),
    );
  }
}
