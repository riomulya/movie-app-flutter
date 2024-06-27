import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  final List<dynamic> transactions;
  final List<dynamic> transaksi;

  const AppDrawer({
    Key? key,
    required this.transactions,
    required this.transaksi,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? email;

  @override
  void initState() {
    super.initState();
    _getEmail();
  }

  Future<void> _getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(
              'Kelompok 2',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            accountEmail: Text(
              email ?? 'Loading...', // Display the email or a placeholder
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/wa.jpg'),
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 77, 70, 218),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Film'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/films');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Tambah Film'),
            onTap: () {
              Navigator.of(context).pushNamed('/films');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Data Transaksi'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/transactions');
            },
          ),
          ListTile(
            leading: const Icon(Icons.data_usage),
            title: const Text('Data Master'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/data_master');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              _logout(context); // Call logout function
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Clear authentication token or perform logout operations
    // Here you can add code to clear user session or token
    // For example, using shared preferences:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('auth_token');

    // Navigate to login screen and remove all previous routes
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
