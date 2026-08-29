import 'package:flutter/widgets.dart';

/// Дизайн-токены MirTaxi.
///
/// Единственный источник правды по цвету, отступам, скруглениям и таймингам.
/// В экранах не должно быть литеральных hex-значений и магических чисел —
/// только обращения сюда.
///
/// Важно: размеры здесь фиксированные, в логических пикселях. Прежний подход
/// (`media.width * 0.042666`) привязывал шрифты и отступы к ширине экрана,
/// из-за чего на планшете текст раздувался, а на маленьком телефоне мельчал.
class MtColors {
  const MtColors._();

  // Бренд взят из логотипа: жёлтый MIR TAXI и чёрный контур.
  static const Color brand50 = Color(0xFFFFF8EC);
  static const Color brand100 = Color(0xFFFDEED0);
  static const Color brand200 = Color(0xFFFCDDA2);
  static const Color brand300 = Color(0xFFFCC96B);
  static const Color brand400 = Color(0xFFFCB13D); // основной цвет логотипа
  static const Color brand500 = Color(0xFFEE9C12);
  static const Color brand600 = Color(0xFFC57A08); // контраст для текста по светлому
  static const Color brand700 = Color(0xFF8F5806);

  // Нейтральные с лёгким тёплым уклоном — чистый серый рядом с жёлтым
  // выглядит грязным.
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFFAFAF8);
  static const Color neutral100 = Color(0xFFF3F2EE);
  static const Color neutral200 = Color(0xFFE7E5DF);
  static const Color neutral300 = Color(0xFFD4D1C9);
  static const Color neutral400 = Color(0xFFA6A299);
  static const Color neutral500 = Color(0xFF767268);
  static const Color neutral600 = Color(0xFF54514A);
  static const Color neutral700 = Color(0xFF393733);
  static const Color neutral800 = Color(0xFF23221F);
  static const Color neutral900 = Color(0xFF141312);
  static const Color neutral950 = Color(0xFF0C0B0A);

  // Семантические — отдельно от бренда, чтобы «успех» не спорил с жёлтым.
  static const Color success = Color(0xFF1F8A4C);
  static const Color successSoft = Color(0xFFE6F4EB);
  static const Color danger = Color(0xFFD1382B);
  static const Color dangerSoft = Color(0xFFFBEBE9);
  static const Color warning = Color(0xFFE0900B);
  static const Color info = Color(0xFF2563EB);
}

/// Шаг сетки — 4. Все отступы кратны ему.
class MtSpace {
  const MtSpace._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double x3l = 32;
  static const double x4l = 40;
  static const double x5l = 48;
  static const double x6l = 64;

  /// Горизонтальные поля экрана.
  static const double screenX = 20;
}

class MtRadius {
  const MtRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double pill = 999;

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius brPill = BorderRadius.all(Radius.circular(pill));

  /// Скругление верхних углов у нижних панелей и шторок.
  static const BorderRadius sheet = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );
}

/// Минимальная область нажатия — 44pt по Apple HIG.
class MtSize {
  const MtSize._();

  static const double minTouch = 44;
  static const double control = 52;
  static const double controlSm = 40;
  static const double icon = 24;
  static const double iconSm = 20;
}

class MtDuration {
  const MtDuration._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 340);

  /// Уход быстрее появления — так интерфейс ощущается отзывчивее.
  static const Duration exit = Duration(milliseconds: 160);
}

class MtCurves {
  const MtCurves._();

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve spring = Curves.easeOutBack;
}

/// Тени задаются одной шкалой, чтобы карточки и панели не разъезжались
/// по глубине.
class MtShadow {
  const MtShadow._();

  static List<BoxShadow> card(bool dark) => dark
      ? const [
          BoxShadow(
              color: Color(0x66000000), blurRadius: 24, offset: Offset(0, 8)),
        ]
      : const [
          BoxShadow(
              color: Color(0x0F141312), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(
              color: Color(0x14141312), blurRadius: 20, offset: Offset(0, 8)),
        ];

  static List<BoxShadow> sheet(bool dark) => dark
      ? const [
          BoxShadow(
              color: Color(0x99000000), blurRadius: 32, offset: Offset(0, -6)),
        ]
      : const [
          BoxShadow(
              color: Color(0x1A141312), blurRadius: 32, offset: Offset(0, -6)),
        ];
}
