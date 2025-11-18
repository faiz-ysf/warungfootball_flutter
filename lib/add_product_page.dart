import 'dart:convert'; // Import for json.encode
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import for Provider
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Import for CookieRequest
import 'package:warungfootball_flutter/screens/product_list_page.dart'; // Import for navigation

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _price = 0;
  String _description = '';
  String _thumbnail = '';
  String? _category;
  bool _isFeatured = false;

  final List<String> _categories = [
    'shoes',
    'men_sportwear',
    'women_sportwear',
    'kids_sportwear',
    'accessories',
    'equipment',
    'bags',
    'outerwear',
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>(); // Access CookieRequest

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price cannot be empty';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Price must be a number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description cannot be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Thumbnail URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Thumbnail URL cannot be empty';
                  }
                  // Basic URL validation
                  if (!Uri.parse(value).isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _thumbnail = value!;
                },
              ),
              DropdownButtonFormField<String>(
                initialValue: _category, // Changed to initialValue
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _category = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
                onSaved: (value) {
                  _category = value!;
                },
              ),
              CheckboxListTile(
                title: const Text('Featured Product'),
                value: _isFeatured,
                onChanged: (bool? value) {
                  setState(() {
                    _isFeatured = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Send data to Django backend
                    final response = await request.postJson(
                      "http://10.0.2.2:8000/create-product-flutter/", // TODO: Replace with your actual endpoint
                      jsonEncode(<String, dynamic>{
                        'name': _name,
                        'price': _price,
                        'descriptions': _description,
                        'thumbnail': _thumbnail,
                        'category': _category,
                        'is_featured': _isFeatured,
                        // Add other fields as necessary, e.g., user_id, user_name, etc.
                      }),
                    );

                    if (!context.mounted) return; // Add this line

                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("New product has been saved!"),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductEntryListPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response['message'] ?? "Failed to save product."),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
