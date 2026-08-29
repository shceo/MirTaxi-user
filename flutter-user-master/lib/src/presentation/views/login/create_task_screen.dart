import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_service.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/data/models/http_result.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/design/tokens.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/send_success_screen.dart';

class CreateTaskScreen extends StatefulWidget {
  final int id;

  const CreateTaskScreen({super.key, required this.id});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? image;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Имя и телефон уже известны после входа — не заставляем вводить их
    // повторно. Поля остаются редактируемыми: заявку могут оформлять на
    // другого человека, и контакт для связи бывает другим.
    nameController.text = (userDetails['name'] ?? '').toString().trim();
    final profilePhone = (userDetails['mobile'] ?? '').toString().trim();
    phoneController.text = profilePhone.isNotEmpty ? profilePhone : phnumber;

    nameController.addListener(_onChanged);
    phoneController.addListener(_onChanged);
    commentController.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    nameController.removeListener(_onChanged);
    phoneController.removeListener(_onChanged);
    commentController.removeListener(_onChanged);
    nameController.dispose();
    phoneController.dispose();
    commentController.dispose();
    super.dispose();
  }

  int get _filledCount {
    var n = 0;
    if (image != null) n++;
    if (nameController.text.trim().isNotEmpty) n++;
    if (phoneController.text.trim().isNotEmpty) n++;
    if (commentController.text.trim().isNotEmpty) n++;
    return n;
  }

  bool get _canSubmit => _filledCount == 4;

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => image = picked);
  }

  Future<void> _submit() async {
    if (!_canSubmit || isLoading) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => isLoading = true);

    final HttpResult result = await sendTask(
      nameController.text.trim(),
      phoneController.text.trim(),
      image!.path,
      commentController.text.trim(),
      widget.id,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result.isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SendSuccessScreen(desc: result.result['message']),
        ),
      );
    } else {
      AppService.errorToast(result.result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final serviceTitle = widget.id == 2
        ? context.l10n.text_service_child
        : context.l10n.text_service_corporate;

    return Scaffold(
      // Белая страница с мягкими заливными полями вместо серой подложки
      // с белыми карточками — так форма читается как один цельный лист.
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        scrolledUnderElevation: 0,
        title: Text(context.l10n.text_request_form),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                      MtSpace.screenX, 0, MtSpace.screenX, MtSpace.x3l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(serviceTitle,
                          style: theme.textTheme.displaySmall),
                      const SizedBox(height: MtSpace.sm),
                      _Progress(filled: _filledCount, total: 4),
                      const SizedBox(height: MtSpace.xxl),
                      _PhotoTile(image: image, onTap: _pickImage),
                      const SizedBox(height: MtSpace.xl),
                      _SoftField(
                        label: context.l10n.text_name,
                        hint: context.l10n.text_name_hint,
                        icon: Icons.person_outline,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                      ),
                      const SizedBox(height: MtSpace.md),
                      _SoftField(
                        label: context.l10n.text_phone,
                        hint: '+998 94 555 77 77',
                        icon: Icons.phone_outlined,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        tabular: true,
                      ),
                      const SizedBox(height: MtSpace.md),
                      _SoftField(
                        label: context.l10n.text_comment,
                        hint: context.l10n.text_comment_hint,
                        icon: Icons.chat_bubble_outline,
                        controller: commentController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 4,
                        maxLines: 8,
                      ),
                    ],
                  ),
                ),
              ),
              // Панель действия отделена волоском: кнопка всегда на виду и
              // не сливается со скроллом.
              Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border(
                      top: BorderSide(color: scheme.outlineVariant)),
                ),
                padding: const EdgeInsets.fromLTRB(
                    MtSpace.screenX, MtSpace.md, MtSpace.screenX, MtSpace.md),
                child: SafeArea(
                  top: false,
                  child: FilledButton(
                    onPressed: _canSubmit && !isLoading ? _submit : null,
                    child: Text(context.l10n.text_send_request),
                  ),
                ),
              ),
            ],
          ),
          if (isLoading)
            const Positioned(top: 0, left: 0, right: 0, child: Loading()),
        ],
      ),
    );
  }
}

/// Полоса заполнения: показывает, сколько из четырёх пунктов уже заполнено.
/// Раньше кнопка просто была серой, и человек не понимал, чего не хватает.
class _Progress extends StatelessWidget {
  const _Progress({required this.filled, required this.total});

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(total, (i) {
        final done = i < filled;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == total - 1 ? 0 : MtSpace.xs),
            child: AnimatedContainer(
              duration: MtDuration.base,
              curve: MtCurves.enter,
              height: 4,
              decoration: BoxDecoration(
                color: done ? MtColors.brand400 : scheme.surfaceContainerHigh,
                borderRadius: MtRadius.brPill,
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Плитка загрузки фото. Пустая — мягкая брендовая заливка с пунктиром,
/// заполненная — превью на всю ширину.
class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.image, required this.onTap});

  final XFile? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final has = image != null;

    return Semantics(
      button: true,
      label: context.l10n.text_edit_photo,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: MtDuration.fast,
          height: has ? 200 : 176,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: has ? scheme.surfaceContainer : MtColors.brand50,
            borderRadius: MtRadius.brXxl,
            border: has
                ? null
                : Border.all(color: MtColors.brand200, width: 1.5),
          ),
          child: has
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(image!.path), fit: BoxFit.cover),
                    Positioned(
                      right: MtSpace.md,
                      bottom: MtSpace.md,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: MtSpace.lg, vertical: MtSpace.sm),
                        decoration: BoxDecoration(
                          color: scheme.inverseSurface.withValues(alpha: 0.85),
                          borderRadius: MtRadius.brPill,
                        ),
                        child: Text(
                          context.l10n.text_edit_photo,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onInverseSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: const BoxDecoration(
                        color: MtColors.brand400,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_a_photo_outlined,
                          color: MtColors.neutral900, size: 26),
                    ),
                    const SizedBox(height: MtSpace.md),
                    Text(context.l10n.text_edit_photo,
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: MtSpace.xs),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: MtSpace.xxl),
                      child: Text(
                        context.l10n.text_photo_hint,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Поле с мягкой заливкой: рамка появляется только в фокусе, слева иконка,
/// справа галочка, когда поле заполнено.
class _SoftField extends StatefulWidget {
  const _SoftField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.minLines = 1,
    this.maxLines = 1,
    this.tabular = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final int minLines;
  final int maxLines;
  final bool tabular;

  @override
  State<_SoftField> createState() => _SoftFieldState();
}

class _SoftFieldState extends State<_SoftField> {
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
    final focused = _focus.hasFocus;
    final filled = widget.controller.text.trim().isNotEmpty;
    final multiline = widget.maxLines > 1;

    return AnimatedContainer(
      duration: MtDuration.fast,
      curve: MtCurves.enter,
      padding: const EdgeInsets.fromLTRB(
          MtSpace.lg, MtSpace.md, MtSpace.lg, MtSpace.md),
      decoration: BoxDecoration(
        color: focused ? scheme.surface : scheme.surfaceContainer,
        borderRadius: MtRadius.brXl,
        border: Border.all(
          color: focused ? MtColors.brand400 : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: multiline ? MtSpace.xl : 0),
            child: Icon(
              widget.icon,
              size: MtSize.iconSm,
              color: focused ? MtColors.brand600 : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: MtSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label, style: theme.textTheme.labelMedium),
                TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontFeatures: widget.tabular
                        ? const [FontFeature.tabularFigures()]
                        : null,
                  ),
                  decoration: InputDecoration(
                    // Подсказка обязательна: без неё под подписью было пустое
                    // место, и было неясно, что сюда вообще нужно вводить.
                    hintText: widget.hint,
                    hintStyle: theme.textTheme.bodyLarge
                        ?.copyWith(color: scheme.onSurfaceVariant),
                    filled: false,
                    isDense: true,
                    contentPadding: const EdgeInsets.only(top: MtSpace.xs),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            duration: MtDuration.fast,
            opacity: filled ? 1 : 0,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MtSpace.sm, top: multiline ? MtSpace.xl : 0),
              child: const Icon(Icons.check_circle,
                  size: MtSize.iconSm, color: MtColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
