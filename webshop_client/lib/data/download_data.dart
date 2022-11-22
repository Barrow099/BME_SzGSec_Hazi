import 'package:json_annotation/json_annotation.dart';

part 'download_data.g.dart';

@JsonSerializable()
class DownloadData {
  String caption;
  @JsonKey(fromJson: dateTimeFromTimestamp)
  DateTime creationDate;

  DownloadData({
    required this.caption,
    required this.creationDate,
  });

  factory DownloadData.fromJson(Map<String, dynamic> json) => _$DownloadDataFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadDataToJson(this);
}

DateTime dateTimeFromTimestamp(String timestamp) {
  return DateTime.parse(timestamp);
}