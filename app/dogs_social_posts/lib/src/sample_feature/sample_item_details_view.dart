import 'package:dogs_social_posts/src/shared/post_item.dart';
import 'package:flutter/material.dart';

import '../shared/post_item_view.dart';

class SampleItemDetailsView extends StatefulWidget {
  static const routeName = '/sampleItemDetails';

  final SampleItem item;

  const SampleItemDetailsView({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _SampleItemDetailsViewState createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  late String message;
  late List<String> hashtags;

  @override
  void initState() {
    super.initState();
    message = widget.item.message ?? '';
    hashtags = widget.item.hashtags;
  }

  void _showEditDialog(String title, String initialValue, Function(String) onSubmit) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: title,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSubmit(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _editMessage() {
    _showEditDialog('Edit Message', message, (newMessage) {
      setState(() {
        message = newMessage;
      });
    });
  }

  void _editHashtags() {
    _showEditDialog('Edit Hashtags (comma separated)', hashtags.join(', '), (newHashtags) {
      setState(() {
        hashtags = newHashtags.split(',').map((tag) => tag.trim()).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color scheduledDateColor = Colors.blue; // Define the color

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: FractionallySizedBox(
              widthFactor: constraints.maxWidth > 600 ? 0.6 : 0.9,
              heightFactor: constraints.maxHeight > 800 ? 0.8 : 0.9,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PostItemView(
                    scheduledDateColor: scheduledDateColor,
                    item: widget.item.copyWith(
                      message: message,
                      hashtags: hashtags,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _editMessage,
            tooltip: 'Edit Message',
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _editHashtags,
            tooltip: 'Edit Hashtags',
            child: const Icon(Icons.tag),
          ),
        ],
      ),
    );
  }
}
