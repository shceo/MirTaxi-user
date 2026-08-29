import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagyourtaxi_driver/src/data/models/http_result.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/design/tokens.dart';
import 'package:tagyourtaxi_driver/src/presentation/viewmodels/auth_view_model.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/get_started.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/otp_page.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/noInternet/nointernet.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController controller = TextEditingController();
  late final AuthViewModel _viewModel;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
    _viewModel.loadCountries();
    _selectedLanguage = choosenLanguage.isNotEmpty ? choosenLanguage : 'en';
    updateAppLanguage(_selectedLanguage);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    controller.dispose();
    super.dispose();
  }

  void _navigateToOtp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Otp()));
  }

  String _langShort(String code) {
    final c = code.toLowerCase();
    if (c == 'uz' || c == 'uzb') return "O'zbek";
    if (c == 'ru' || c == 'rus') return "Rus";
    if (c == 'en') return "En";
    return code.toUpperCase();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    updateAppLanguage(_selectedLanguage);
    phnumber = controller.text;

    final exists = await validateMobileForLogin(controller.text);
    if (!mounted) return;
    if (exists == false) {
      // Номера нет на бэкенде — ведём сразу на регистрацию, без OTP.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GetStarted()),
      );
      return;
    }

    final HttpResult val = await _viewModel.requestOtp(controller.text);
    if (!mounted) return;
    if (val.isSuccess) {
      phoneAuthCheck = false;
      _navigateToOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      body: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: AnimatedBuilder(
          animation: Listenable.merge([_viewModel, controller]),
          builder: (context, _) {
            final canSubmit = _viewModel.canSubmitPhone(controller.text);

            return Stack(
              children: [
                if (_viewModel.hasCountries)
                  SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: constraints.maxHeight),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: MtSpace.screenX,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: MtSpace.md),
                                    // Язык — утилитарный переключатель, а не
                                    // поле формы: держим его сверху, чтобы
                                    // единственная задача экрана (ввод номера)
                                    // оставалась в фокусе.
                                    Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: _LanguageSegmented(
                                        selected: _selectedLanguage,
                                        langShort: _langShort,
                                        onSelect: (code) {
                                          HapticFeedback.selectionClick();
                                          setState(() {
                                            _selectedLanguage = code;
                                            updateAppLanguage(code);
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: MtSpace.xl),
                                    Center(
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        height: 72,
                                        fit: BoxFit.contain,
                                        semanticLabel: 'Mir Taxi',
                                      ),
                                    ),
                                    const SizedBox(height: MtSpace.x3l),
                                    Text(
                                      context.l10n.text_login,
                                      style: theme.textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: MtSpace.sm),
                                    Text(
                                      context.l10n.text_login_subtitle,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: MtSpace.xxl),
                                    Text(
                                      context.l10n.text_phone_number,
                                      style: theme.textTheme.labelMedium,
                                    ),
                                    const SizedBox(height: MtSpace.sm),
                                    _PhoneField(controller: controller),
                                    // Кнопка прижата к низу — до неё удобно
                                    // дотянуться большим пальцем. При открытой
                                    // клавиатуре её поднимает viewInsets.
                                    const Expanded(
                                      child: SizedBox(height: MtSpace.x3l),
                                    ),
                                    FilledButton(
                                      onPressed: canSubmit ? _submit : null,
                                      child: Text(context.l10n.text_continue),
                                    ),
                                    const SizedBox(height: MtSpace.lg),
                                    // Условий использования на экране входа
                                    // не было вовсе, хотя строки для них есть.
                                    Text(
                                      context.l10n.text_agree_terms_privacy(
                                        context.l10n.text_terms,
                                        context.l10n.text_privacy,
                                      ),
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
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
                  )
                else
                  const _LoginSkeleton(),
                if (_viewModel.hasInternet == false)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: NoInternet(
                      onTap: _viewModel.retryFetchCountries,
                    ),
                  ),
                if (_viewModel.isLoading == true)
                  const Positioned(top: 0, left: 0, right: 0, child: Loading()),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Поле телефона: код страны слева, номер справа, единая рамка.
///
/// Раньше номер набирался шрифтом с `letterSpacing: 1` и обычными цифрами —
/// при вводе строка «дёргалась». Теперь моноширинные цифры.
class _PhoneField extends StatefulWidget {
  const _PhoneField({required this.controller});

  final TextEditingController controller;

  @override
  State<_PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<_PhoneField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dial = countries[phcode]['dial_code'].toString();
    final maxLen = countries[phcode]['dial_max_length'] as int?;

    return AnimatedContainer(
      duration: MtDuration.fast,
      curve: MtCurves.enter,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: MtSpace.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: MtRadius.brLg,
        border: Border.all(
          color: _focus.hasFocus ? MtColors.brand400 : scheme.outline,
          width: _focus.hasFocus ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            dial,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: MtSpace.md),
          Container(width: 1, height: 24, color: scheme.outlineVariant),
          const SizedBox(width: MtSpace.md),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focus,
              autofocus: false,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumberNational],
              maxLength: maxLen,
              onChanged: (val) {
                phnumber = widget.controller.text;
                if (maxLen != null && val.length == maxLen) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              decoration: InputDecoration(
                hintText: '94 555 77 77',
                counterText: '',
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Выбор языка тремя сегментами вместо списка на пол-экрана.
///
/// Это разовый выбор из трёх вариантов — ему не нужен список с подписями
/// и галочками, который раньше занимал половину экрана входа.
class _LanguageSegmented extends StatelessWidget {
  const _LanguageSegmented({
    required this.selected,
    required this.onSelect,
    required this.langShort,
  });

  final String selected;
  final void Function(String code) onSelect;
  final String Function(String code) langShort;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(MtSpace.xs),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: MtRadius.brMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final lang in languagesCode)
            _Segment(
              label: langShort(lang['code'].toString()),
              selected: selected == lang['code'].toString(),
              onTap: () => onSelect(lang['code'].toString()),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: MtDuration.fast,
          curve: MtCurves.enter,
          height: MtSize.controlSm,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: MtSpace.lg),
          decoration: BoxDecoration(
            color: selected ? scheme.surface : Colors.transparent,
            borderRadius: MtRadius.brSm,
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x14141312),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}


/// Пока грузится справочник стран, экран был полностью белым — пользователь
/// видел пустоту и не понимал, работает ли приложение.
class _LoginSkeleton extends StatelessWidget {
  const _LoginSkeleton();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 72,
            fit: BoxFit.contain,
            semanticLabel: 'Mir Taxi',
          ),
          const SizedBox(height: MtSpace.x3l),
          SizedBox(
            width: MtSize.iconSm,
            height: MtSize.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
