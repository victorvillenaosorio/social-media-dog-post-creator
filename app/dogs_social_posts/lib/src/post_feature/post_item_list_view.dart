import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import '../settings/settings_view.dart';
import '../shared/post_item_view.dart';
import '../shared/post_item.dart';
import '../shared/post_item_utils.dart'; // Import the new utility file

class PostItemListView extends StatefulWidget {
  const PostItemListView({
    super.key,
    this.items = const [],
  });

  static const routeName = '/';

  final List<PostItem> items;

  @override
  _PostItemListViewState createState() => _PostItemListViewState();
}

class _PostItemListViewState extends State<PostItemListView> {
  late List<PostItem> items;

  @override
  void initState() {
    super.initState();
    items = List<PostItem>.of(widget.items);
  }

  Future<void> _addItem() async {
    final response = await http.get(Uri.parse('http://localhost:3000/post'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        items.add(PostItem(
          id: items.length + 1,
          message: data['message'],
          imageUrl: data['imageUrl'],
          likes: Random().nextInt(999),
          hashtags: data['hashtags'] != null ? List<String>.from(data['hashtags']) : [],
          scheduledDate: data['scheduledDate'] != null ? DateTime.parse(data['scheduledDate']) : null,
        ));
      });
    } else {      
      print('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'settings':
                  Navigator.pushNamed(context, SettingsView.routeName);
                  break;
                case 'post':
                  // TODO
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'post',
                child: Text('Post'),
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          final scheduledDateColor = getScheduledDateColor(item.scheduledDate);

          return PostItemView(scheduledDateColor: scheduledDateColor, item: item);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
