import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:webshop_client/data/string_to_datetime.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  int id;
  String? content;
  @JsonKey(fromJson: dateTimeFromTimestamp)
  DateTime creationDate;
  int rating;
  String? userName;
  String? userId;
  int caffFileId;

  Comment({
    required this.id,
    this.content,
    required this.creationDate,
    required this.rating,
    this.userName,
    this.userId,
    required this.caffFileId
  });

  String get creationDateString {
    return DateFormat("yyyy.MM.dd HH:mm").format(creationDate);
  }

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}