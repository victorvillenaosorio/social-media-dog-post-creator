import 'package:dogs_social_posts/src/post_feature/post_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'post_service.dart';
import '../config.dart';
import '../shared/action_button_widget.dart';
import '../shared/edit_dialog.dart';
import 'post_item_view.dart';
import 'post_item.dart';

class PostItemDetailsView extends StatefulWidget {
  static const routeName = '/postDetails';
  final PostService postService = PostService(Config.apiBaseUrl);
  final PostItem item;

  PostItemDetailsView({
    Key? key,
    required this.item,
  }) : super(key: key);


  @override
  _PostItemDetailsViewState createState() => _PostItemDetailsViewState();
}

class _PostItemDetailsViewState extends State<PostItemDetailsView> {
  late String message;
  late List<String> hashtags;
  DateTime? scheduledDate;

  @override
  void initState() {
    super.initState();
    message = widget.item.message ?? '';
    hashtags = widget.item.hashtags;
    scheduledDate = widget.item.scheduledDate;
  }

  void _showEditDialog(String title, String initialValue, Function(String) onSubmit) {
  showDialog(
    context: context,
    builder: (context) => EditDialog(
      title: title,
      initialValue: initialValue,
      onSubmit: onSubmit,
    ),
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

  void _schedulePost() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = scheduledDate ?? DateTime.now();
        TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);

        return AlertDialog(
          title: const Text('Schedule Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Date'),
                trailing: Text(DateFormat.yMd().format(selectedDate)),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Time'),
                trailing: Text(selectedTime.format(context)),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null && picked != selectedTime) {
                    setState(() {
                      selectedTime = picked;
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                },
              ),
            ],
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
                setState(() {
                  scheduledDate = selectedDate;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
            if (scheduledDate != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    scheduledDate = null;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Remove Date'),
              ),
          ],
        );
      },
    );
  }

Future<void> _savePost() async {
  final postData = {
    'id': widget.item.id,
    'message': message,
    'hashtags': hashtags,
    'imageUrl': widget.item.imageUrl,
    'scheduledDate': scheduledDate?.toIso8601String(),
  };

  try {
    final response = await widget.postService.savePost(
      postData,
      isNew: widget.item.id == '',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post saved successfully!')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save post')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving post: $e')),
    );
  }
}

  Future<void> _deletePost() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    if (widget.item.id == '')
    {
        Navigator.of(context).pop();
    }

    final url = Uri.parse('${Config.apiBaseUrl}/post/${widget.item.id}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete post: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post details'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: FractionallySizedBox(
              widthFactor: constraints.maxWidth > 600 ? 0.6 : 0.9,
              heightFactor: constraints.maxHeight > 800 ? 0.8 : 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PostItemView(
                  item: widget.item.copyWith(
                    message: message,
                    hashtags: hashtags,
                    scheduledDate: scheduledDate,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: PostItemDetailsActionButtons(
        onEditMessage: _editMessage,
        onEditHashtags: _editHashtags,
        onSchedulePost: _schedulePost,
        onSavePost: _savePost,
        onDeletePost: _deletePost,
      ),
    );
  }
}
