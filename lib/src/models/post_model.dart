import 'package:fourways/src/models/models.dart';

class Post {
  final int id;
  final User user;
  final String caption;
  final String timeAgo;
  final String imageUrl;
   int likes;
  final int comments;
  final int shares;
  final int? like;
  final int? haha;
  final int? sad;
  final int? love;
  final int? lovelove;
  final int? angry;
  final int? comment;
  final int? share;
  final int? wow;
  

   Post({
     required this.id,
    required this.user,
    required this.caption,
    required this.timeAgo,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    this.like,
    this.haha,
    this.sad,
    this.love,
    this.lovelove,
    this.angry,
    this.comment,
    this.share,
    this.wow,
    
  });
}
