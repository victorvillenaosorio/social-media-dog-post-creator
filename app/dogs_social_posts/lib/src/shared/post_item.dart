class SampleItem {
  SampleItem(this.id, {this.message, this.imageUrl, this.likes = 0, this.hashtags = const [], this.scheduledDate});

  final int id;
  final String? message;
  final String? imageUrl;
  final int likes;
  final List<String> hashtags;
  final DateTime? scheduledDate;
}