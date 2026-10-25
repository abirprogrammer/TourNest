class TravelVideo {
  final String title;
  final String creator;
  final String youtubeUrl;
  final String thumbnailUrl;
  final String duration;

  const TravelVideo({
    required this.title,
    required this.creator,
    required this.youtubeUrl,
    required this.thumbnailUrl,
    required this.duration,
  });
}

class Destination {
  final String id;
  final String name;
  final String location;
  final String category;
  final String rating;
  final String imageUrl;
  final String description;
  final String bestTime;
  final String estimatedCost;
  final String mapUrl;
  final List<TravelVideo> videos;

  const Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.bestTime,
    required this.estimatedCost,
    required this.mapUrl,
    required this.videos,
  });
}
