import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

import '../config.dart';
import 'post_item_details_view.dart';
import '../settings/settings_view.dart';
import 'post_item.dart';

class PostItemView extends StatelessWidget {
  const PostItemView({
    super.key,
    required this.item,
  });

  final PostItem item;

  Color _getScheduledDateColor(DateTime? scheduledDate) {
    if (scheduledDate == null) {
      return Colors.red;
    } else if (scheduledDate.isAfter(DateTime.now())) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  String _formatScheduledDate(DateTime? scheduledDate) {
    if (scheduledDate == null) {
      return 'Not scheduled';
    }
    return DateFormat('MMM d, yyyy h:mm a').format(scheduledDate);
  }

  @override
  Widget build(BuildContext context) {
    final scheduledDateColor = _getScheduledDateColor(item.scheduledDate);
    final formattedScheduledDate = _formatScheduledDate(item.scheduledDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.schedule, color: scheduledDateColor),
              const SizedBox(width: 4),
              Text(
                formattedScheduledDate,
                style: TextStyle(color: scheduledDateColor),
              ),
            ],
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostItemDetailsView(item: item),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'avatar-${item.id}',
                          child:
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                Config.barkibuAvatarUrl,
                              ),
                              radius: 20,
                            ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Barkibu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Follow'),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: item.imageUrl != null
                              ? NetworkImage(item.imageUrl!)
                              : const AssetImage(Config.defaultImagePath) as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {},
                        ),
                        Spacer(),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 0.6,
                          child: const Icon(Icons.favorite),
                        ),
                        const SizedBox(width: 4),
                        Text('${item.likes} likes'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item.message ?? 'PostItem ${item.id}',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      spacing: 4.0,
                      children: item.hashtags.map((hashtag) => Text(
                        hashtag,
                        style: TextStyle(color: Colors.blue),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 12), // Add padding below hashtags
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}