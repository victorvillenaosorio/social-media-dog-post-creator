import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({
    super.key,
    this.items = const [],
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  _SampleItemListViewState createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  late List<SampleItem> items;

  @override
  void initState() {
    super.initState();
    items = List<SampleItem>.of(widget.items);
  }

  Future<void> _addItem() async {
    final response = await http.get(Uri.parse('http://localhost:3000/post'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        items.add(SampleItem(
          items.length + 1,
          message: data['message'],
          imageUrl: data['imageUrl'],
          likes: Random().nextInt(999), // Add random number of likes
          hashtags: data['hashtags'] != null ? List<String>.from(data['hashtags']) : [],
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

          return GestureDetector(
            onTap: () {
              Navigator.restorablePushNamed(
                context,
                SampleItemDetailsView.routeName,
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // Remove rounded borders
              ),
              elevation: 4, // Add shadow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: const NetworkImage(
                            'data:image/png;base64,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',
                          ),
                          radius: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
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
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: item.imageUrl != null
                              ? NetworkImage(item.imageUrl!)
                              : const AssetImage('assets/images/flutter_logo.png') as ImageProvider<Object>,
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
                      item.message ?? 'SampleItem ${item.id}',
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
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SampleItem {
  SampleItem(this.id, {this.message, this.imageUrl, this.likes = 0, this.hashtags = const []});

  final int id;
  final String? message;
  final String? imageUrl;
  final int likes;
  final List<String> hashtags;
}
