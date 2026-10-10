import 'package:flutter/material.dart';
import '../models/service.dart';

class ProductsData {
  static const List<Product> all = [
    Product(
      id: 'p1',
      name: 'Liquid Pomade',
      description:
          'All-day hold with a high-shine finish. Water-based formula rinses out easily. Perfect for pompadours, slick backs, and side parts.',
      price: 550,
      category: 'Hairstyling',
      icon: Icons.water_drop,
      badge: 'NEW',
      features: [
        'Strong hold, high shine',
        'Water-based, easy to wash',
        'Non-greasy finish',
        'Scented premium fragrance',
      ],
    ),
    Product(
      id: 'p2',
      name: 'Sea Salt Spray',
      description:
          'Beachy waves and textured volume for a natural, windswept look. Adds grip and grit for messy, effortless styles.',
      price: 350,
      category: 'Hairstyling',
      icon: Icons.waves,
      features: [
        'Instant textured volume',
        'Matte natural finish',
        'Light to medium hold',
        'Great for all hair lengths',
      ],
    ),
    Product(
      id: 'p3',
      name: 'Kids Pomade',
      description:
          'Gentle, hypoallergenic formula crafted for kids. Safe hold without harsh chemicals — fun, easy styling.',
      price: 350,
      category: 'Hairstyling',
      icon: Icons.child_care,
      badge: 'FOR KIDS',
      features: [
        'Hypoallergenic & safe',
        'Mild, tear-free scent',
        'Soft natural hold',
        'Paraben-free',
      ],
    ),
    Product(
      id: 'p4',
      name: 'Water-based Pomade',
      description:
          'Medium hold with a clean, natural shine. Classic go-to for everyday styles that stay put without stiffness.',
      price: 350,
      category: 'Hairstyling',
      icon: Icons.water_drop,
      features: [
        'Medium hold, natural shine',
        'Rinses clean with water',
        'Workable all day',
        'No crunch or flakes',
      ],
    ),
    Product(
      id: 'p5',
      name: 'Oil-based Pomade',
      description:
          'Traditional, heavy-duty hold with a brilliant shine. Authentic barbershop classic that lasts through sweat and humidity.',
      price: 350,
      category: 'Hairstyling',
      icon: Icons.local_drink,
      features: [
        'Heavy hold, high shine',
        'Humidity resistant',
        'Traditional oil-based formula',
        'Iconic barbershop scent',
      ],
    ),
    Product(
      id: 'p6',
      name: 'Fiber (Shiny Finish)',
      description:
          'Thick, pliable fiber for maximum texture with a glossy topcoat. Great for fades, spikes, and messy modern cuts.',
      price: 399,
      category: 'Hairstyling',
      icon: Icons.auto_awesome,
      badge: 'BEST SELLER',
      features: [
        'Thick textured fiber',
        'High shine finish',
        'Moldable & workable',
        'Plump hair fibers instantly',
      ],
    ),
    Product(
      id: 'p7',
      name: 'Fiber (Matte Finish)',
      description:
          'Zero shine for the natural "effortless" look. Adds volume and texture without appearing over-styled.',
      price: 399,
      category: 'Hairstyling',
      icon: Icons.auto_awesome_outlined,
      features: [
        '100% matte finish',
        'Adds instant volume',
        'Great for fine hair',
        'Modern textured look',
      ],
    ),
    Product(
      id: 'p8',
      name: 'Hairwax',
      description:
          'Everyday workhorse wax with a 2-size option. Dependable hold for the office, school, or casual days.',
      price: 150,
      category: 'Hairstyling',
      icon: Icons.invert_colors_on,
      badge: '2 SIZES',
      features: [
        'Budget-friendly',
        'Reliable daily hold',
        '2 sizes available',
        'Proudly Pinoy formula',
      ],
    ),
    Product(
      id: 'p9',
      name: 'Anti-Dandruff Shampoo',
      description:
          'Clinically-formulated anti-flake shampoo. Clears dandruff while keeping hair healthy and nourished.',
      price: 350,
      category: 'Hair Care',
      icon: Icons.shower,
      badge: 'FOR DRY HAIR',
      features: [
        'Reduces dandruff & flakes',
        'Soothes itchy scalp',
        'Safe for daily use',
        'Fresh clean scent',
      ],
    ),
    Product(
      id: 'p10',
      name: 'Daily Care Shampoo',
      description:
          'Balanced everyday shampoo that cleans gently without stripping. Leaves hair soft, shiny, and manageable.',
      price: 350,
      category: 'Hair Care',
      icon: Icons.spa,
      features: [
        'Daily-use formula',
        'Gentle on scalp',
        'Softens & adds shine',
        'pH balanced',
      ],
    ),
  ];

  static const List<String> categories = [
    'Latest',
    'Hairstyling',
    'Hair Care',
  ];

  static List<Product> byCategory(String category) {
    if (category == 'Latest') return all.take(3).toList();
    return all.where((p) => p.category == category).toList();
  }
}

class HairstylesData {
  static const List<Hairstyle> all = [
    Hairstyle(
      id: 'h1',
      name: 'Buzz Cut',
      tagline: 'Clean and sharp. Built for simplicity.',
      description:
          'The ultimate no-fuss, high-confidence haircut. Uniform short length all over — fast to style, never goes out of season. Our barbers precision-clip every length to match your face shape and head contour perfectly.',
      icon: Icons.crop_square,
      recommendedProductIds: ['p8', 'p9'],
    ),
    Hairstyle(
      id: 'h2',
      name: 'Crew Cut',
      tagline: 'Short and low-maintenance. Always in style.',
      description:
          'Timeless gentleman\'s cut: short on the sides with slight length on top. Polished enough for the boardroom, rugged enough for casual weekends — the ultimate versatile staple.',
      icon: Icons.person_outline,
      recommendedProductIds: ['p4', 'p7'],
    ),
    Hairstyle(
      id: 'h3',
      name: 'Fade',
      tagline: 'Smooth and seamless. Built for precision.',
      description:
          'Signature barbershop craftsmanship: a flawless gradient from skin on the sides to length on top. High fade, low fade, mid fade, drop fade — we blend it seamlessly every single time. Expect a mirror-shine finish.',
      icon: Icons.gradient,
      recommendedProductIds: ['p1', 'p6'],
    ),
    Hairstyle(
      id: 'h4',
      name: 'Modern Mullet',
      tagline: 'Edgy and versatile. Built to stand out.',
      description:
          'The 2025 reimagined mullet: short sharp front with controlled length and texture at the back. Controllable chaos — for gents who want a statement without the "2000s rockstar" costume vibe.',
      icon: Icons.star_border_purple500_sharp,
      recommendedProductIds: ['p2', 'p7'],
    ),
    Hairstyle(
      id: 'h5',
      name: 'Pompadour',
      tagline: 'Bold and neat. Built for presence.',
      description:
          'Volume on top, volume everywhere that matters. A signature Gentleman cut — sculpted for height, texture, and a clean shape that turns heads from the boardroom to the bar.',
      icon: Icons.local_fire_department,
      recommendedProductIds: ['p1', 'p5', 'p6'],
    ),
    Hairstyle(
      id: 'h6',
      name: 'Side Part',
      tagline: 'Clean and confident. A staple for the modern gentleman.',
      description:
          'Classic split combed neatly to one side. The definition of "pulled together." Our barbers map your natural hair swirl to find the perfect line every single visit.',
      icon: Icons.chevron_right,
      recommendedProductIds: ['p4', 'p5'],
    ),
    Hairstyle(
      id: 'h7',
      name: 'Taper',
      tagline: 'Classic and refined. Built for balance.',
      description:
          'Gradual graduation of hair length at the neckline and sides. A softer, more natural cousin to the fade. Grows out cleanly — the "1 haircut every 3 weeks guys\' favorite."',
      icon: Icons.expand,
      recommendedProductIds: ['p2', 'p8'],
    ),
  ];
}
