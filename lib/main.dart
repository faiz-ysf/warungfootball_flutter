import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:warungfootball_flutter/screens/login.dart';
import 'package:warungfootball_flutter/screens/my_products_page.dart';
import 'package:warungfootball_flutter/screens/product_list_page.dart';
import 'package:warungfootball_flutter/add_product_page.dart';
import 'package:warungfootball_flutter/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Warung Football',
        theme: _buildTheme(context),
        home: const LoginPage(),
        routes: {
          '/home': (context) => const MyHomePage(),
        },
      ),
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    final baseTheme = ThemeData.light();
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: const Color(0xFF2E7D32), // Deep Green
        secondary: const Color(0xFF66BB6A), // Lighter Green
        surface: const Color(0xFFF5F5F5), // Light Grey

        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme).copyWith(
        headlineLarge: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF2E7D32), // Deep Green
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32), // Deep Green
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF2E7D32), // Deep Green
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF66BB6A), // Lighter Green
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: Colors.black54,
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // --- ADDED DEBUG LOGGING START ---
    print('Cookies in request within MyHomePage: ${request.cookies}');
    // --- ADDED DEBUG LOGGING END ---
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warung Football'),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context, request),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Warung Football!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Your one-stop shop for all things football.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, CookieRequest request) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Welcome, ${request.jsonData['username'] ?? 'Anonymous'}!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('All Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProductsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Product'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final response = await request.logout("$baseUrl/auth/logout/");
              String message = response["message"];
              if (context.mounted) {
                if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message Sampai jumpa, $uname."),
                  ));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}