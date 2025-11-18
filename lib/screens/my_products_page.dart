import 'package:flutter/material.dart';
import 'package:warungfootball_flutter/models/product_entry.dart';
import 'package:warungfootball_flutter/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:warungfootball_flutter/screens/product_detail.dart'; // Added import

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    // IMPORTANT: This now fetches only the products for the logged-in user.
    // Make sure you have a corresponding URL in your Django app that returns JSON data for the current user.
    // For example, a view decorated with @login_required that filters products by request.user.
    final response = await request.get('http://10.0.2.2:8000/my-json/');

    // Decode response to json format
    var data = response;

    // Convert json data to ProductEntry objects
    List<ProductEntry> listProducts = [];
    for (var d in data) {
      if (d != null) {
        listProducts.add(ProductEntry.fromJson(d));
      }
    }
    return listProducts;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Products')), // Changed title
      // drawer: const LeftDrawer(), // Commented out as LeftDrawer might not exist or needs correct import
      body: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) { // Check for empty list
              return const Column(
                children: [
                  Text(
                    'You have no products yet.', // Changed text
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => ProductCard( // Changed to ProductCard
                  product: snapshot.data![index], // Changed from news to product
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: snapshot.data![index]),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}