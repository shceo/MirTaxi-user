import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/functions.dart' show userDetails, phnumber;
import '../../data/repositories/request_repository.dart';

/// Состояние экрана заявки.
///
/// Экран теперь только отрисовывает то, что здесь лежит, и сообщает о
/// действиях. Ни сетевых вызовов, ни глобальных переменных в самом экране нет.
class CreateTaskViewModel extends ChangeNotifier {
  CreateTaskViewModel({
    required this.serviceId,
    RequestRepository? repository,
  }) : _repository = repository ?? const RequestRepository();

  final int serviceId;
  final RequestRepository _repository;
  final ImagePicker _picker = ImagePicker();

  String name = '';
  String phone = '';
  String comment = '';
  XFile? image;
  bool isSubmitting = false;
  String errorMessage = '';

  /// Имя и телефон известны после входа — не заставляем вводить повторно.
  /// Значения остаются редактируемыми: заявку могут оформлять на другого
  /// человека, и контакт для связи бывает другим.
  void prefillFromProfile() {
    name = (userDetails['name'] ?? '').toString().trim();
    final profilePhone = (userDetails['mobile'] ?? '').toString().trim();
    phone = profilePhone.isNotEmpty ? profilePhone : phnumber;
    notifyListeners();
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  void setComment(String value) {
    comment = value;
    notifyListeners();
  }

  /// Сколько из четырёх пунктов заполнено — для индикатора прогресса.
  int get filledCount {
    var n = 0;
    if (image != null) n++;
    if (name.trim().isNotEmpty) n++;
    if (phone.trim().isNotEmpty) n++;
    if (comment.trim().isNotEmpty) n++;
    return n;
  }

  bool get canSubmit => filledCount == 4 && !isSubmitting;

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    image = picked;
    notifyListeners();
  }

  /// Возвращает сообщение сервера при успехе, иначе null — тогда в
  /// [errorMessage] лежит текст ошибки.
  Future<String?> submit() async {
    if (!canSubmit) return null;
    isSubmitting = true;
    errorMessage = '';
    notifyListeners();

    final result = await _repository.sendServiceRequest(
      name: name.trim(),
      phone: phone.trim(),
      imagePath: image!.path,
      comment: comment.trim(),
      serviceId: serviceId,
    );

    isSubmitting = false;
    if (result.isSuccess) {
      notifyListeners();
      final message = result.result is Map ? result.result['message'] : null;
      return (message ?? '').toString();
    }

    errorMessage = _formatError(result.result);
    notifyListeners();
    return null;
  }

  String _formatError(dynamic result) {
    if (result is Map) {
      final errors = result['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        if (first != null) return first.toString();
      }
      final message = result['message'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }
    return result?.toString() ?? '';
  }
}
