import 'package:dogs_social_posts/src/shared/post_item.dart';
import 'package:flutter/material.dart';

import '../shared/post_item_view.dart';

class SampleItemDetailsView extends StatelessWidget {
  static const routeName = '/sampleItemDetails';

  final SampleItem item;

  const SampleItemDetailsView({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color scheduledDateColor = Colors.blue; // Define the color

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        child: PostItemView(scheduledDateColor: scheduledDateColor, item: item),
      ),
    );
  }
}
