import '../../core/services/functions.dart' as api;
import '../models/http_result.dart';

/// Заявки на услуги: перевозка детей и корпоративные поездки.
///
/// Пока метод оборачивает существующую функцию из `functions.dart` — поведение
/// не меняется, но экран уже не обращается к god-файлу напрямую. Когда все
/// вызывающие места переедут сюда, реализация переносится внутрь репозитория,
/// а из `functions.dart` удаляется. См. README рядом.
class RequestRepository {
  const RequestRepository();

  /// id: 1 — корпоративная заявка, 2 — перевозка детей.
  Future<HttpResult> sendServiceRequest({
    required String name,
    required String phone,
    required String imagePath,
    required String comment,
    required int serviceId,
  }) {
    return api.sendTask(name, phone, imagePath, comment, serviceId);
  }
}
