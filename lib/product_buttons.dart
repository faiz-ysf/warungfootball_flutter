
import 'package:flutter/material.dart';

class ProductButtons extends StatefulWidget {
  const ProductButtons({super.key});

  @override
  State<ProductButtons> createState() => _ProductButtonsState();
}

class _ProductButtonsState extends State<ProductButtons> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  ButtonStyle _buildButtonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity, // Make button full width
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kamu telah menekan tombol My Products'),
                    ),
                  );
                },
                icon: const Icon(Icons.person, size: 24),
                label: const Text(
                  'My Products',
                  style: TextStyle(fontSize: 18),
                ),
                style: _buildButtonStyle(Colors.green),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15), // Increased spacing
        FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity, // Make button full width
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kamu telah menekan tombol View All Products'),
                    ),
                  );
                },
                icon: const Icon(Icons.list, size: 24),
                label: const Text(
                  'View All Products',
                  style: TextStyle(fontSize: 18),
                ),
                style: _buildButtonStyle(Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
