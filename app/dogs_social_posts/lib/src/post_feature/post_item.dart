class PostItem {
  final String id;
  final String? message;
  final List<String> hashtags;
  final String? imageUrl;
  final int likes;
  final DateTime? scheduledDate;

  PostItem({
    required this.id,
    this.message,
    required this.hashtags,
    this.imageUrl,
    required this.likes,
    this.scheduledDate,
  });

  PostItem copyWith({
    String? id,
    String? message,
    List<String>? hashtags,
    String? imageUrl,
    int? likes,
    DateTime? scheduledDate,
  }) {
    return PostItem(
      id: id ?? this.id,
      message: message ?? this.message,
      hashtags: hashtags ?? this.hashtags,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      scheduledDate: scheduledDate ?? this.scheduledDate,
    );
  }
}