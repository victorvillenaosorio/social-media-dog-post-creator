import 'package:flutter/material.dart';
import 'package:dogs_social_posts/src/post_feature/post_item_details_view.dart';
import 'package:dogs_social_posts/main.dart';

import 'post_service.dart';
import '../settings/settings_view.dart';
import 'post_item_view.dart';
import 'post_item.dart';
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

  final PostService _postService = PostService(Config.apiBaseUrl);

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
      final fetchedItems = await _postService.fetchPosts();
      setState(() {
        items = fetchedItems;
      });
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
    try {
      final newItem = await _postService.generateNewPost();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostItemDetailsView(item: newItem),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate a new post')),
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
