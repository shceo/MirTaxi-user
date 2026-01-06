import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tagyourtaxi_driver/functions/app_service.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/model/http_result.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/login/send_success_screen.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class CreateTaskScreen extends StatefulWidget {
  final int id;

  const CreateTaskScreen({super.key, required this.id});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  ImagePicker picker = ImagePicker();
  XFile? image;
  bool isLoading = false;

  @override
  void initState() {
    nameController.addListener(() {
      setState(() {});
    });
    phoneController.addListener(() {
      setState(() {});
    });
    commentController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(),
        centerTitle: true,
        title: const Text(
          'Форма заполнения',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        blurRadius: 4.0,
                        offset: Offset(0.0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 36),
                      GestureDetector(
                        onTap: () async {
                          image = await picker.pickImage(source: ImageSource.gallery);
                          setState(() {});
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromRGBO(46, 55, 56, 1),
                          ),
                          child: image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    File(image!.path),
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                )
                              : const Center(
                                  child: Icon(Icons.camera_alt, color: Colors.white, size: 50),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Редактировать изображение',
                        style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: InputField(
                          icon: Icons.person_outline_rounded,
                          text: 'Имя',
                          textController: nameController,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: InputField(
                          icon: Icons.phone,
                          text: 'Телефон',
                          inputType: TextInputType.phone,
                          textController: phoneController,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: InputField(
                          icon: Icons.comment,
                          text: 'Комментарий',
                          textController: commentController,
                          maxLength: 200,
                        ),
                      ),
                      const Spacer(),
                      Button(
                        onTap: () async {
                          if (check()) {
                            //send request
                            setState(() {
                              isLoading = true;
                            });
                            HttpResult result = await sendTask(nameController.text, phoneController.text,
                                File(image!.path).path, commentController.text, widget.id);
                            setState(() {
                              isLoading = false;
                            });
                            if (result.isSuccess) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SendSuccessScreen(desc: result.result['message'])));
                            } else {
                              AppService.errorToast(result.result.toString());
                            }
                          }
                        },
                        color: check() ? buttonColor : Colors.grey,
                        text: 'Отправить заявку',
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          //loader
          (isLoading == true) ? const Positioned(top: 0, child: Loading()) : Container()
        ],
      ),
    );
  }

  bool check() {
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        commentController.text.isNotEmpty &&
        image != null) {
      return true;
    } else {
      return false;
    }
  }
}
