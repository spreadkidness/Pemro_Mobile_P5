import 'package:flutter/material.dart';

import '../services/secure_storage_service.dart';
import 'login_screen.dart';
import 'post_list_screen.dart';
import 'user_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = SecureStorageService();
  bool _hasToken = false;
  final _pinController = TextEditingController();
  String _pinStatus = 'PIN belum diperiksa';

  @override
  void initState() {
    super.initState();
    _loadTokenStatus();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _loadTokenStatus() async {
    final result = await _storage.hasToken();
    if (mounted) setState(() => _hasToken = result);
  }

  Future<void> _savePin() async {
    final pin = _pinController.text.trim();
    if (pin.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN minimal 4 karakter.')),
      );
      return;
    }
    await _storage.savePin(pin);
    _pinController.clear();
    if (mounted) {
      setState(() => _pinStatus = 'PIN tersimpan secara aman.');
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Hapus token dan keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    await _storage.deleteToken();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Praktikum'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.green),
              title: const Text('Secure Storage'),
              subtitle: Text(
                _hasToken
                    ? 'Token tersimpan secara aman.'
                    : 'Token belum tersimpan.',
              ),
              trailing: const Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Penyimpanan PIN',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Masukkan PIN (minimal 4 karakter)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: _savePin,
            child: const Text('Simpan PIN dengan Aman'),
          ),
          Text(_pinStatus),
          const Divider(height: 32),
          const Text(
            'HTTP Request',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Daftar Pengguna'),
              subtitle: const Text('GET /users, pencarian, dan timeout'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserListScreen(),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Daftar Post'),
              subtitle: const Text('GET /posts'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PostListScreen(),
                ),
              ),
            ),
          ),
          const Divider(height: 32),
          const Text(
            'Catatan Keamanan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Jangan mencatat token, PIN, atau kata sandi ke log.'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Gunakan HTTPS untuk komunikasi API.'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Gunakan SharedPreferences hanya untuk data non-sensitif.'),
          ),
        ],
      ),
    );
  }
}
