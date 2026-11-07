import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = ApiService().getPosts();
  }

  Future<void> _refresh() async {
    final future = ApiService().getPosts();
    setState(() => _postsFuture = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Post')),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => setState(
                      () => _postsFuture = ApiService().getPosts(),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          final posts = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final Post post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${post.id}')),
                    title: Text(post.title),
                    subtitle: Text(
                      post.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text('User ${post.userId}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
