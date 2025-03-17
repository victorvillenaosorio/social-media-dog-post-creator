import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:dogs_social_posts/src/post_feature/post_item_details_view.dart';
import 'package:dogs_social_posts/main.dart';

import '../settings/settings_view.dart';
import '../shared/post_item_view.dart';
import '../shared/post_item.dart';
import '../config.dart';

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

class _PostItemListViewState extends State<PostItemListView> with RouteAware {
  late List<PostItem> items;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    items = List<PostItem>.of(widget.items);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _fetchPosts();
  }

  @override
  void didPopNext() {
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    if (_isFetching) return;
    setState(() {
      _isFetching = true;
    });

    try {
      final response = await http.get(Uri.parse('${Config.apiBaseUrl}/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final fetchedItems = data.map((post) {
          return PostItem(
            id: post['id'],
            message: post['message'],
            imageUrl: post['imageUrl'],
            likes: post['likes'] ?? 0,
            hashtags: post['hashtags'] != null ? List<String>.from(post['hashtags']) : [],
            scheduledDate: post['scheduledDate'] != null ? DateTime.parse(post['scheduledDate']) : null,
          );
        }).toList();

        setState(() {
          items = fetchedItems.cast<PostItem>();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch posts: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while fetching posts')),
      );
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  Future<void> _addItem() async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/post'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newItem = PostItem(
        id: '',
        message: data['message'],
        imageUrl: data['imageUrl'],
        likes: Random().nextInt(999),
        hashtags: data['hashtags'] != null ? List<String>.from(data['hashtags']) : [],
        scheduledDate: data['scheduledDate'] != null ? DateTime.parse(data['scheduledDate']) : null,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostItemDetailsView(item: newItem),
        ),
      );
    } else {
      print('Failed to load post');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate a new post: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram posts'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'settings':
                  Navigator.pushNamed(context, SettingsView.routeName);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 0.8,
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return PostItemView(item: item);
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addItem',
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
