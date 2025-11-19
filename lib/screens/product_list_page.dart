import 'package:flutter/material.dart';

class ProductEntryListPage extends StatelessWidget {
  const ProductEntryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: const Center(
        child: Text('This page will display all products.'),
      ),
    );
  }
}
