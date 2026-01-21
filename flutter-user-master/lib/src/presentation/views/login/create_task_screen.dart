import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_service.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/data/models/http_result.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/send_success_screen.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';

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
    nameController.addListener(() => setState(() {}));
    phoneController.addListener(() => setState(() {}));
    commentController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Форма заполнения',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: w,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.10),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF2DBE60), width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              'i',
                              style: TextStyle(
                                color: Color(0xFF2DBE60),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 34),
                          GestureDetector(
                            onTap: () async {
                              image = await picker.pickImage(source: ImageSource.gallery);
                              setState(() {});
                            },
                            child: Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromRGBO(46, 55, 56, 1),
                              ),
                              child: image != null
                                  ? ClipOval(
                                      child: Image.file(
                                        File(image!.path),
                                        fit: BoxFit.cover,
                                        height: 110,
                                        width: 110,
                                      ),
                                    )
                                  : const Center(
                                      child: Icon(Icons.camera_alt, color: Colors.white, size: 46),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Редактировать изображение',
                            style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 22),

                          _LabeledOutlineField(
                            label: 'Имя',
                            controller: nameController,
                            hintText: 'Name',
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 14),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 170,
                              child: _LabeledOutlineField(
                                label: 'Телефон',
                                controller: phoneController,
                                hintText: '',
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          _LabeledOutlineField(
                            label: 'Комментарий',
                            controller: commentController,
                            hintText: '',
                            keyboardType: TextInputType.multiline,
                            minLines: 6,
                            maxLines: 8,
                          ),

                          const Spacer(),

                          _SubmitButton(
                            text: 'Отправить заявку',
                            enabled: check(),
                            onTap: () async {
                              if (!check()) return;

                              setState(() => isLoading = true);

                              final HttpResult result = await sendTask(
                                nameController.text,
                                phoneController.text,
                                File(image!.path).path,
                                commentController.text,
                                widget.id,
                              );

                              setState(() => isLoading = false);

                              if (result.isSuccess) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SendSuccessScreen(desc: result.result['message']),
                                  ),
                                );
                              } else {
                                AppService.errorToast(result.result.toString());
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
          if (isLoading) const Positioned(top: 0, left: 0, right: 0, child: Loading()),
        ],
      ),
    );
  }

  bool check() {
    return nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        commentController.text.isNotEmpty &&
        image != null;
  }
}

class _LabeledOutlineField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;

  const _LabeledOutlineField({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.hintText = '',
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.3),
    );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: Color(0xFF8E8E8E), width: 1.5),
        ),
        labelStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: Color(0xFF111111), fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final VoidCallback onTap;

  const _SubmitButton({
    required this.text,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFFFFD66B);

    return AbsorbPointer(
      absorbing: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
