import 'package:json_annotation/json_annotation.dart';

part 'CAFF_data.g.dart';

@JsonSerializable()
class CAFFData {
  int id;
  String caption;
  @JsonKey(fromJson: dateTimeFromTimestamp)
  DateTime creationDate;
  String creator;
  int price;


  CAFFData({
    required this.id,
    required this.caption,
    required this.creationDate,
    required this.creator,
    required this.price
  });

  factory CAFFData.fromJson(Map<String, dynamic> json) => _$CAFFDataFromJson(json);
  Map<String, dynamic> toJson() => _$CAFFDataToJson(this);
}

DateTime dateTimeFromTimestamp(String timestamp) {
  return DateTime.parse(timestamp);
}