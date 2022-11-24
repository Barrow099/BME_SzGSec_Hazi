import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:webshop_client/data/string_to_datetime.dart';

import 'comment.dart';

part 'CAFF_data.g.dart';

@JsonSerializable()
class CAFFData {
  int id;
  String caption;
  @JsonKey(fromJson: dateTimeFromTimestamp)
  DateTime creationDate;
  String creator;
  int price;

  // we only have this data using the individual getter
  String? ownerId;
  String? ownerName;
  List<Comment>? comments;

  CAFFData({
    required this.id,
    required this.caption,
    required this.creationDate,
    required this.creator,
    required this.price,
    this.ownerId,
    this.ownerName,
    this.comments
  });

  String get creationDateString {
    return DateFormat("yyyy.MM.dd HH:mm").format(creationDate);
  }

  double? get rating {
    double _rating=0;
    if(comments == null) {
      return null;
    }

    if(comments!.isEmpty) {
      return null;
    }

    int allRatings = 0;
    for (Comment c in comments!) {
      if(c.rating != null && c.rating != 0) {
        _rating += c.rating!;
        allRatings++;
      }
    }
    if(allRatings==0) return 0;
    _rating = _rating / allRatings;
    return _rating;
  }

  bool userHasReview(String userId) {
    if(comments == null || comments!.isEmpty) {
      return false;
    }

    for(Comment c in comments!) {
      if(c.userId == userId && c.rating != null && c.rating != 0) {
        return true;
      }
    }
    return false;
  }

  factory CAFFData.fromJson(Map<String, dynamic> json) => _$CAFFDataFromJson(json);
  Map<String, dynamic> toJson() => _$CAFFDataToJson(this);
}

