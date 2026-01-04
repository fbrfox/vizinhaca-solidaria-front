import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vizinhanca_solidaria/core/di/injection_container.dart';
import 'package:vizinhanca_solidaria/core/ui/colors.dart';

class MyDrawer extends StatefulWidget {
  // Make Drawer Stateful
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FlutterSecureStorage storage = sl.get();
  String? userName;
  String? userId; // Assuming you store the user ID
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load data when the widget initializes
  }

  Future<void> _loadUserData() async {
    userName = await storage.read(
        key: 'user_name'); // Replace 'user_name' with your key
    userId =
        await storage.read(key: 'user_id'); // Replace 'user_id' with your key
    userEmail = await storage.read(key: 'user_email');

    // If you are using the ID to construct the image URL
    if (userId != null) {
      profileImageUrl = '${dotenv.env['API_URL'] ?? ''}/users/avatar/$userId';
    }
    setState(() {
      // Rebuild the widget after data is loaded
    });

    print('User name: $userName');
    print('User id: $userId');
    print('User email: $userEmail');
  }

  String? profileImageUrl; // Store the image URL

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(// Usamos um Column para controlar o layout
            children: <Widget>[
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName ??
                  'Loading...'), // Show 'Loading...' while data loads
              accountEmail:
                  Text(userEmail ?? 'Loading...'), // Or get email from storage
              currentAccountPicture: ClipOval(
                  // Widget para deixar a imagem redonda
                  child: CachedNetworkImage(
                imageUrl: profileImageUrl ?? '',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                cacheManager: CachedNetworkImageProvider.defaultCacheManager,
                fit: BoxFit.fill,
                width: 80,
                height: 80,
              )),
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: primaryColor),
              title: Text('Home'),
              onTap: () {
                // Navigate to home screen or perform action
                Navigator.pop(context); // Close the drawer
                // ... your navigation logic
              },
            ),
          ],
        ),
      ),
      ListTile(
        leading: const Icon(Icons.logout, color: primaryColor),
        title: const Text('Logout'),
        onTap: () {
          // Limpar dados do FlutterSecureStorage
          storage.deleteAll(); // Ou remova apenas as chaves necessárias

          // Navegar para a tela de login (ou outra ação de logout)
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (Route<dynamic> route) => false);
        },
      )
    ]));
  }
}
