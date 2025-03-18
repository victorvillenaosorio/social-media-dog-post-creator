import 'package:flutter/material.dart';

class PostItemDetailsActionButtons extends StatelessWidget {
   final VoidCallback onEditMessage;
  final VoidCallback onEditHashtags;
  final VoidCallback onSchedulePost;
  final VoidCallback onSavePost;
  final VoidCallback onDeletePost;

  const PostItemDetailsActionButtons({
    Key? key,
    required this.onEditMessage,
    required this.onEditHashtags,
    required this.onSchedulePost,
    required this.onSavePost,
    required this.onDeletePost,
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'editMessage',
          tooltip: 'Edit Message',
          onPressed: onEditMessage,
          child: const Icon(Icons.edit),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'editHashtags',
          tooltip: 'Edit Hashtags',
          onPressed: onEditHashtags,
          child: const Icon(Icons.tag),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'schedulePost',
          tooltip: 'Schedule Post',
          onPressed: onSchedulePost,
          child: const Icon(Icons.schedule),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'savePost',
          tooltip: 'Save Post',
          onPressed: onSavePost,
          child: const Icon(Icons.save),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'deletePost',
          tooltip: 'Delete Post',
          backgroundColor: Colors.red,
          onPressed: onDeletePost,
          child: const Icon(Icons.delete),
        ),
      ],
    );
  }
}