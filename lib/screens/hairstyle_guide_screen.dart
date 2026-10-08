import 'package:flutter/material.dart';
import '../data/products_data.dart';
import '../models/service.dart';

class HairstyleGuideScreen extends StatefulWidget {
  final void Function(BarberService? service) onBookHairstyle;

  const HairstyleGuideScreen({
    super.key,
    required this.onBookHairstyle,
  });

  @override
  State<HairstyleGuideScreen> createState() => _HairstyleGuideScreenState();
}

class _HairstyleGuideScreenState extends State<HairstyleGuideScreen> {
  final List<Hairstyle> _styles = HairstylesData.all;
  Hairstyle? _expandedStyle;
  final PageController _pageCtrl = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  List<Product> _productsFor(Hairstyle s) {
    return ProductsData.all
        .where((p) => s.recommendedProductIds.contains(p.id))
        .toList();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                      tooltip: "Back",
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "HAIRSTYLE GUIDE",
                      style: TextStyle(
                        color: Color(0xFFD4A853),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Find your look.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Tap any style to see how we craft it, plus product recos to maintain it at home.",
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 340, child: _buildFeaturedPageView()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_styles.length, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentPage == i ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? const Color(0xFFD4A853)
                            : const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              sliver: SliverList.separated(
                itemCount: _styles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) => _buildStyleCard(_styles[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedPageView() {
    final gradients = const [
      [Color(0xFFD4A853), Color(0xFF7A5A18)],
      [Color(0xFF444444), Color(0xFF1A1A1A)],
      [Color(0xFF99691C), Color(0xFF3D2A0B)],
      [Color(0xFF2B2B2B), Color(0xFF0F0F0F)],
      [Color(0xFFD4A853), Color(0xFF2B1F0A)],
      [Color(0xFF3A2A0B), Color(0xFF1A1A1A)],
      [Color(0xFFB8892E), Color(0xFF3D2A0B)],
    ];
    return PageView.builder(
      controller: _pageCtrl,
      onPageChanged: (v) => setState(() => _currentPage = v),
      itemCount: _styles.length,
      itemBuilder: (context, i) {
        final s = _styles[i];
        final g = gradients[i % gradients.length];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.fromLTRB(4, 24, 4, _currentPage == i ? 8 : 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: g),
            borderRadius: BorderRadius.circular(24),
            boxShadow: _currentPage == i
                ? [
                    BoxShadow(
                      color: const Color(0xFFD4A853).withValues(alpha: 0.2),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(s.icon, color: Colors.white, size: 28),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0F0F).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "#${i + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  s.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  s.tagline,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStyleCard(Hairstyle s) {
    final products = _productsFor(s);
    final isExpanded = _expandedStyle?.id == s.id;
    final gradients = const [
      [Color(0xFFD4A853), Color(0xFF7A5A18)],
      [Color(0xFF2E2E2E), Color(0xFF151515)],
    ];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isExpanded
              ? const Color(0xFFD4A853)
              : const Color(0xFF2A2A2A),
        ),
      ),
      child: InkWell(
        onTap: () => setState(() {
          _expandedStyle = isExpanded ? null : s;
        }),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradients[_styles.indexOf(s) % 2],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(s.icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          s.tagline,
                          style: const TextStyle(
                            color: Color(0xFFD4A853),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF777777),
                    size: 26,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xFF2A2A2A),
                ),
                const SizedBox(height: 16),
                Text(
                  s.description,
                  style: const TextStyle(
                    color: Color(0xFFBBBBBB),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Keep it at home — try these:",
                  style: TextStyle(
                    color: Color(0xFFD4A853),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    ...products.map((p) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0F0F),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFD4A853).withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(p.icon,
                                color: const Color(0xFFD4A853), size: 16),
                            const SizedBox(width: 8),
                            Text(
                              p.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "₱${p.price.toInt()}",
                              style: const TextStyle(
                                color: Color(0xFFD4A853),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (products.isEmpty)
                      const Text(
                        "No specific product required.",
                        style: TextStyle(
                            color: Color(0xFF777777), fontSize: 12),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Just tell the parent we want to book haircut
                      final BarberService placeholder = const BarberService(
                        id: 'haircut-main',
                        name: 'Haircut',
                        description: 'Signature Bruno\'s haircut crafted to your chosen style.',
                        price: 480,
                        durationMinutes: 45,
                        icon: Icons.content_cut,
                        category: 'Haircut',
                      );
                      widget.onBookHairstyle(placeholder);
                    },
                    icon: const Icon(Icons.calendar_month, size: 17),
                    label: Text("Book a ${s.name} Haircut"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A853),
                      foregroundColor: const Color(0xFF0F0F0F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
