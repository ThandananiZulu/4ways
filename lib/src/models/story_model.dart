import 'package:fourways/src/models/models.dart';

class Story {
  final User? user; // Make user nullable
  final String imageUrl;
  final bool isViewed;

  const Story({
    this.user, // Make user nullable
    required this.imageUrl,
    this.isViewed = false,
  });
}

