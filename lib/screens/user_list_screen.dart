import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/user_card.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  bool _loading = true;
  String? _error;
  int _timeoutSeconds = 10;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _api.getUsers(
        timeout: Duration(seconds: _timeoutSeconds),
      );
      if (!mounted) return;
      setState(() => _users = result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showUserDetail(User user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Wrap(
            runSpacing: 10,
            children: [
              Text(
                user.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('Username: ${user.username}'),
              Text('Email: ${user.email}'),
              Text('Telepon: ${user.phone}'),
              Text('Website: ${user.website}'),
              Text('Perusahaan: ${user.companyName}'),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final filteredUsers = _users.where((user) {
      return user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pengguna')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari nama atau email',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _searchController.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Timeout: '),
                DropdownButton<int>(
                  value: _timeoutSeconds,
                  items: [3, 5, 10, 15, 20]
                      .map(
                        (seconds) => DropdownMenuItem(
                          value: seconds,
                          child: Text('$seconds detik'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _timeoutSeconds = value);
                    _fetchUsers();
                  },
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _fetchUsers,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Muat ulang'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.wifi_off, size: 48),
                              const SizedBox(height: 12),
                              Text(_error!, textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: _fetchUsers,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : filteredUsers.isEmpty
                        ? const Center(child: Text('Data tidak ditemukan.'))
                        : RefreshIndicator(
                            onRefresh: _fetchUsers,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];
                                return UserCard(
                                  user: user,
                                  onTap: () => _showUserDetail(user),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
