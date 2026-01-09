class LastAddressModel {
  bool success;
  String message;
  List<AddressModel> data;

  LastAddressModel({
    required this.success,
    required this.message,
    required this.data,
  });

  LastAddressModel copyWith({
    bool? success,
    String? message,
    List<AddressModel>? data,
  }) =>
      LastAddressModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LastAddressModel.fromJson(Map<String, dynamic> json) =>
      LastAddressModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        data: json["data"] == null
            ? List<AddressModel>.from({})
            : List<AddressModel>.from(json["data"].map((x) => AddressModel.fromJson(x))),
      );
}

class AddressModel {
  int id;
  String requestId;
  double pickLat;
  double pickLng;
  double dropLat;
  double dropLng;
  String requestPath;
  String pickAddress;
  String dropAddress;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressModel({
    required this.id,
    required this.requestId,
    required this.pickLat,
    required this.pickLng,
    required this.dropLat,
    required this.dropLng,
    required this.requestPath,
    required this.pickAddress,
    required this.dropAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  AddressModel copyWith({
    int? id,
    String? requestId,
    double? pickLat,
    double? pickLng,
    double? dropLat,
    double? dropLng,
    String? requestPath,
    String? pickAddress,
    String? dropAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      AddressModel(
        id: id ?? this.id,
        requestId: requestId ?? this.requestId,
        pickLat: pickLat ?? this.pickLat,
        pickLng: pickLng ?? this.pickLng,
        dropLat: dropLat ?? this.dropLat,
        dropLng: dropLng ?? this.dropLng,
        requestPath: requestPath ?? this.requestPath,
        pickAddress: pickAddress ?? this.pickAddress,
        dropAddress: dropAddress ?? this.dropAddress,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"] ?? 0,
        requestId: json["request_id"] ?? '',
        pickLat: json["pick_lat"] == null ? 0.0 : json["pick_lat"]?.toDouble(),
        pickLng: json["pick_lng"] == null ? 0.0 : json["pick_lng"]?.toDouble(),
        dropLat: json["drop_lat"] == null ? 0.0 : json["drop_lat"]?.toDouble(),
        dropLng: json["drop_lng"] == null ? 0.0 : json["drop_lng"]?.toDouble(),
        requestPath: json["request_path"] ?? '',
        pickAddress: json["pick_address"] ?? '',
        dropAddress: json["drop_address"] ?? '',
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
