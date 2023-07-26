import 'package:flutter/material.dart';
import 'package:pinly/constants.dart';

class PlaceFeatures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white.withOpacity(0)],
          stops: [0.75, 1],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _FeatureBadge(
              icon: Icons.star,
              label: 'Our Pick',
              color: Colors.deepOrangeAccent,
            ),
            _FeatureBadge(icon: Icons.wifi, label: 'Free WiFi'),
            _FeatureBadge(icon: Icons.wc, label: 'Toilets Available'),
            _FeatureBadge(icon: Icons.access_time, label: 'Open 24/7'),
            _FeatureBadge(icon: Icons.eco, label: 'Vegan Options'),
            _FeatureBadge(icon: Icons.vpn_key, label: 'VIP Room'),
            _FeatureBadge(
                icon: Icons.smoke_free_outlined, label: 'No Vape Area'),
            _FeatureBadge(icon: Icons.local_cafe, label: 'Outdoor Seating'),
            _FeatureBadge(icon: Icons.music_note, label: 'Live Music'),
            _FeatureBadge(icon: Icons.pets, label: 'Pet-Friendly'),
            _FeatureBadge(icon: Icons.cake, label: 'Birthday Special'),
            _FeatureBadge(icon: Icons.menu_book, label: 'Book Exchange'),
            _FeatureBadge(icon: Icons.games, label: 'Board Games'),
            _FeatureBadge(icon: Icons.image, label: 'Local Art Display'),
            _FeatureBadge(icon: Icons.event, label: 'Special Events'),
            _FeatureBadge(icon: Icons.weekend, label: 'Comfy Couches'),
            _FeatureBadge(icon: Icons.card_giftcard, label: 'Loyalty Program'),
            _FeatureBadge(icon: Icons.date_range, label: 'Seasonal Menu'),
            _FeatureBadge(icon: Icons.restaurant, label: 'Breakfast Menu'),
            _FeatureBadge(icon: Icons.local_cafe, label: 'Local Ingredients'),
            _FeatureBadge(icon: Icons.local_bar, label: 'Coffee Cocktails'),
            _FeatureBadge(
                icon: Icons.subscriptions, label: 'Coffee Subscriptions'),
            _FeatureBadge(
                icon: Icons.table_bar_outlined, label: 'Quiet Study Area'),
            _FeatureBadge(icon: Icons.settings, label: 'Customizable Drinks'),
            _FeatureBadge(icon: Icons.shopping_cart, label: 'Online Ordering'),
          ],
        ),
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  Color color = pinlyPurple;
  Color textColor = Colors.white;

  _FeatureBadge({
    required this.icon,
    required this.label,
    this.color = pinlyPurple,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 18.0,
          ),
          SizedBox(width: 4.0),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
