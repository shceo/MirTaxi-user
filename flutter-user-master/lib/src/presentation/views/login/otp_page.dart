import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/design/tokens.dart';
import 'package:tagyourtaxi_driver/src/presentation/viewmodels/auth_view_model.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/get_started.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/select_task_screen.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/booking_confirmation.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/invoice.dart';

const int _otpLength = 6;

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController otpController = TextEditingController();
  final FocusNode _focus = FocusNode();
  String _error = '';
  late final AuthViewModel _viewModel;

  /// Последний текст поля. TextEditingController уведомляет слушателей и при
  /// изменении выделения, а не только текста, — без этой проверки автопроверка
  /// кода срабатывала повторно с тем же кодом.
  String _lastText = '';

  /// Код, который уже ушёл на проверку. Бэкенд гасит OTP после первой попытки,
  /// поэтому повторная отправка того же кода всегда возвращает «неверный код».
  String _submittedCode = '';

  /// Защита от параллельных запросов: автопроверка и нажатие кнопки могли
  /// уйти одновременно.
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
    _viewModel.startResendTimer();
    otpController.addListener(_onCodeChanged);
  }

  @override
  void dispose() {
    otpController.removeListener(_onCodeChanged);
    _viewModel.dispose();
    otpController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onCodeChanged() {
    final text = otpController.text;
    if (text == _lastText) return; // сменилось выделение, а не текст
    _lastText = text;

    if (_error.isNotEmpty) setState(() => _error = '');
    if (text.length == _otpLength) {
      _focus.unfocus();
      // Код введён полностью — проверяем сразу, не заставляя жать кнопку.
      _verifyOtp();
    } else {
      setState(() {});
    }
  }

  void _navigate(AuthDestination destination) {
    switch (destination) {
      case AuthDestination.invoice:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Invoice()),
            (route) => false);
        break;
      case AuthDestination.bookingConfirmationRental:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BookingConfirmation(type: 1)),
            (route) => false);
        break;
      case AuthDestination.bookingConfirmation:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BookingConfirmation()),
            (route) => false);
        break;
      case AuthDestination.selectTask:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SelectTaskScreen()),
            (route) => false);
        break;
      case AuthDestination.getStarted:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GetStarted()));
        break;
    }
  }

  Future<void> _verifyOtp() async {
    final code = otpController.text;
    if (code.length != _otpLength) return;
    if (_verifying) return;
    // Тот же код второй раз отправлять бессмысленно: он уже погашен на бэкенде.
    if (code == _submittedCode) return;

    _verifying = true;
    _submittedCode = code;
    try {
      final result = await _viewModel.verifyOtp(code);
      if (!mounted) return;
      if (result.hasError) {
        HapticFeedback.heavyImpact();
        setState(() => _error = result.error ?? '');
        return;
      }
      setState(() => _error = '');
      if (result.destination != null) {
        _navigate(result.destination!);
      }
    } finally {
      _verifying = false;
    }
  }

  Future<void> _resend() async {
    HapticFeedback.selectionClick();
    otpController.clear();
    _lastText = '';
    _submittedCode = '';
    await _viewModel.requestOtp(phnumber);
    _viewModel.startResendTimer();
  }

  /// Код страны берём безопасно: обращение `countries[phcode]` кидает
  /// RangeError, если справочник ещё не загружен или пуст.
  String get _dialCode {
    if (phcode >= 0 && phcode < countries.length) {
      return countries[phcode]['dial_code']?.toString() ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: scheme.surfaceContainerLow,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        ),
      ),
      body: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: ValueListenableBuilder(
          valueListenable: valueNotifierHome.value,
          builder: (context, value, child) {
            return AnimatedBuilder(
              animation: Listenable.merge([_viewModel, otpController]),
              builder: (context, _) {
                final resendTime = _viewModel.resendSeconds;
                final filled = otpController.text.length;

                return Stack(
                  children: [
                    SafeArea(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight),
                              child: IntrinsicHeight(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: MtSpace.screenX),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: MtSpace.sm),
                                      Text(
                                        context.l10n.text_phone_verify,
                                        style: theme.textTheme.headlineMedium,
                                      ),
                                      const SizedBox(height: MtSpace.sm),
                                      Text(
                                        context.l10n.text_enter_otp,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                color:
                                                    scheme.onSurfaceVariant),
                                      ),
                                      const SizedBox(height: MtSpace.xs),
                                      Text(
                                        '$_dialCode $phnumber',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontFeatures: const [
                                            FontFeature.tabularFigures()
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: MtSpace.x4l),
                                      _OtpBoxes(
                                        controller: otpController,
                                        focusNode: _focus,
                                        hasError: _error.isNotEmpty,
                                      ),
                                      if (_error.isNotEmpty) ...[
                                        const SizedBox(height: MtSpace.md),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.error_outline,
                                                size: MtSize.iconSm,
                                                color: scheme.error),
                                            const SizedBox(width: MtSpace.sm),
                                            Expanded(
                                              child: Text(
                                                _error,
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                        color: scheme.error),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      const SizedBox(height: MtSpace.xxl),
                                      // Повтор кода — отдельное второстепенное
                                      // действие. Раньше оно делило одну кнопку
                                      // с проверкой, и та меняла смысл на ходу.
                                      Center(
                                        child: TextButton(
                                          onPressed:
                                              resendTime == 0 ? _resend : null,
                                          child: Text(
                                            resendTime == 0
                                                ? context.l10n.text_resend_code
                                                : '${context.l10n.text_resend_code} · 0:${resendTime.toString().padLeft(2, '0')}',
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(height: MtSpace.x3l),
                                      ),
                                      FilledButton(
                                        // Гасим кнопку и для уже отправленного
                                        // кода: иначе нажатие молча ничего не
                                        // делало бы.
                                        onPressed: (filled == _otpLength &&
                                                !_verifying &&
                                                otpController.text !=
                                                    _submittedCode)
                                            ? _verifyOtp
                                            : null,
                                        child: Text(context.l10n.text_verify),
                                      ),
                                      const SizedBox(height: MtSpace.lg),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_viewModel.hasInternet == false)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child:
                            NoInternet(onTap: _viewModel.retryFetchCountries),
                      ),
                    if (_viewModel.isLoading == true)
                      const Positioned(
                          top: 0, left: 0, right: 0, child: Loading()),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Шесть отдельных ячеек вместо одного поля с подсказкой «Enter Otp».
///
/// Под ячейками лежит невидимое поле ввода: оно даёт системную автоподстановку
/// кода из SMS (`AutofillHints.oneTimeCode`) — раньше код приходилось
/// перепечатывать вручную.
class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({
    required this.controller,
    required this.focusNode,
    required this.hasError,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final code = controller.text;

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_otpLength, (i) {
            final filled = i < code.length;
            final isNext = i == code.length && focusNode.hasFocus;
            final borderColor = hasError
                ? scheme.error
                : isNext
                    ? MtColors.brand400
                    : scheme.outline;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: i == _otpLength - 1 ? 0 : MtSpace.sm),
                child: AnimatedContainer(
                  duration: MtDuration.fast,
                  curve: MtCurves.enter,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: MtRadius.brMd,
                    border: Border.all(
                      color: borderColor,
                      width: isNext || hasError ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    filled ? code[i] : '',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        // Прозрачное поле поверх ячеек — принимает ввод и автоподстановку.
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              keyboardType: TextInputType.number,
              maxLength: _otpLength,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              showCursor: false,
              decoration: const InputDecoration(counterText: ''),
            ),
          ),
        ),
      ],
    );
  }
}
