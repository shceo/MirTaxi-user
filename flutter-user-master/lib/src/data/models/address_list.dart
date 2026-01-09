import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddressList {
  AddressList({
    required this.id,
    required this.address,
    required this.latlng,
  });

  String id;
  String address;
  Point latlng;
}
