import 'package:json_annotation/json_annotation.dart';

part 'download_data.g.dart';

@JsonSerializable()
class DownloadData {
  String userId;
  int caffFileId;
  String caffFileName;
  @JsonKey(fromJson: dateTimeFromTimestamp)
  DateTime downloadedDate;

  DownloadData({
    required this.userId,
    required this.caffFileId,
    required this.caffFileName,
    required this.downloadedDate,
  });

  factory DownloadData.fromJson(Map<String, dynamic> json) => _$DownloadDataFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadDataToJson(this);
}

DateTime dateTimeFromTimestamp(String timestamp) {
  return DateTime.parse(timestamp);
}