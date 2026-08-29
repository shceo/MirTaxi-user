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

  bool get _canSubmit =>
      nameController.text.trim().isNotEmpty &&
      phoneController.text.trim().isNotEmpty &&
      commentController.text.trim().isNotEmpty &&
      image != null;

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

    return Scaffold(
      // Раньше стояло resizeToAvoidBottomInset: false — клавиатура закрывала
      // поля, и человек не видел, что печатает.
      backgroundColor: scheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: scheme.surfaceContainer,
        title: Text(context.l10n.text_request_form),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                        MtSpace.screenX, MtSpace.sm, MtSpace.screenX, MtSpace.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: _PhotoPicker(image: image, onTap: _pickImage)),
                        const SizedBox(height: MtSpace.md),
                        Text(
                          image == null
                              ? context.l10n.text_photo_hint
                              : context.l10n.text_edit_photo,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: MtSpace.x3l),
                        _Field(
                          label: context.l10n.text_name,
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                        ),
                        const SizedBox(height: MtSpace.lg),
                        _Field(
                          label: context.l10n.text_phone,
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          tabular: true,
                        ),
                        const SizedBox(height: MtSpace.lg),
                        _Field(
                          label: context.l10n.text_comment,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      MtSpace.screenX, 0, MtSpace.screenX, MtSpace.lg),
                  child: FilledButton(
                    onPressed: _canSubmit && !isLoading ? _submit : null,
                    child: Text(context.l10n.text_send_request),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const Positioned(top: 0, left: 0, right: 0, child: Loading()),
        ],
      ),
    );
  }
}

/// Круглый выбор фото. Раньше рядом висел зелёный кружок с «i» без обработчика
/// нажатия — подсказка, которая ничего не подсказывала. Убран, вместо него
/// поясняющий текст под кнопкой.
class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.image, required this.onTap});

  final XFile? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: context.l10n.text_edit_photo,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          height: 112,
          width: 112,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.surfaceContainer,
            border: Border.all(color: scheme.outline, width: 1),
          ),
          child: image != null
              ? Image.file(File(image!.path), fit: BoxFit.cover)
              : Icon(
                  Icons.add_a_photo_outlined,
                  color: scheme.onSurfaceVariant,
                  size: 36,
                ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.minLines = 1,
    this.maxLines = 1,
    this.tabular = false,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final int minLines;
  final int maxLines;
  final bool tabular;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: MtSpace.sm),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          minLines: minLines,
          maxLines: maxLines,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontFeatures:
                tabular ? const [FontFeature.tabularFigures()] : null,
          ),
        ),
      ],
    );
  }
}
