class SampleItem {
  final int id;
  final String? message;
  final List<String> hashtags;
  final String? imageUrl;
  final int likes;
  final DateTime? scheduledDate;

  SampleItem({
    required this.id,
    this.message,
    required this.hashtags,
    this.imageUrl,
    required this.likes,
    this.scheduledDate,
  });

  SampleItem copyWith({
    int? id,
    String? message,
    List<String>? hashtags,
    String? imageUrl,
    int? likes,
    DateTime? scheduledDate,
  }) {
    return SampleItem(
      id: id ?? this.id,
      message: message ?? this.message,
      hashtags: hashtags ?? this.hashtags,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      scheduledDate: scheduledDate ?? this.scheduledDate,
    );
  }
}