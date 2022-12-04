import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:webshop_client/data/string_to_datetime.dart';

part 'comment.g.dart';

@immutable
@JsonSerializable()
class Comment extends Equatable {
  final int id;
  final String? content;
  @JsonKey(fromJson: dateTimeFromTimestamp)
  final DateTime creationDate;
  final int? rating;
  final String? userName;
  final String? userId;
  final int caffFileId;

  const Comment({
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

  bool get isReview {
    return rating!=null && rating!=0;
  }

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  List<Object?> get props => [id];
}