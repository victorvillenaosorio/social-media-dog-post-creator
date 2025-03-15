import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        ));
      });
    } else {      
      print('Failed to load dog');
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
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
            title: Text(item.message ?? 'SampleItem ${item.id}'),
            leading: CircleAvatar(
              foregroundImage: item.imageUrl != null
                  ? NetworkImage(item.imageUrl!)
                  : const AssetImage('assets/images/flutter_logo.png') as ImageProvider<Object>?,
            ),
            onTap: () {
              Navigator.restorablePushNamed(
                context,
                SampleItemDetailsView.routeName,
              );
            },
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
  SampleItem(this.id, {this.message, this.imageUrl});

  final int id;
  final String? message;
  final String? imageUrl;
}
