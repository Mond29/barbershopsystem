import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHero(context),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  children: [
                    _buildVisionCard(),
                    const SizedBox(height: 20),
                    _buildPurposeCard(),
                    const SizedBox(height: 28),
                    _buildSince1988Section(),
                    const SizedBox(height: 28),
                    _buildCoreValuesCard(),
                    const SizedBox(height: 36),
                    _buildBranchCTA(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 24, 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D1608), Color(0xFF0F0F0F)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A853).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "WHO WE ARE",
              style: TextStyle(
                color: Color(0xFFD4A853),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Built on",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const Text(
            "Trust.",
            style: TextStyle(
              color: Color(0xFFD4A853),
              fontSize: 40,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "Since 1988, we've transformed the barbershop experience, combining professionalism, hygiene, and care to deliver every client confidence with every cut.",
            style: TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 15,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A853).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD4A853).withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.workspace_premium, color: Color(0xFFD4A853)),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SINCE 1988 ©",
                      style: TextStyle(
                        color: Color(0xFFD4A853),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "35+ years of trust",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A853).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.visibility, color: Color(0xFFD4A853), size: 24),
          ),
          const SizedBox(height: 16),
          const Text(
            "Our Vision",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "To be the leading global Filipino brand in grooming.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "A positive and meaningful experience that brings growth. For men in need of pampering, we are a full service barbershop that provides an environment where men can relax and come out feeling good about themselves.",
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurposeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1408), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4A853).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A853), Color(0xFFB8892E)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.favorite, color: Color(0xFF0F0F0F), size: 24),
          ),
          const SizedBox(height: 16),
          const Text(
            "Our Purpose",
            style: TextStyle(
              color: Color(0xFFD4A853),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "To create positive and meaningful experiences that bring growth.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "We stand out from the traditional barbershop experience and go beyond our services to create the perfect ambience with well-trained barbers and therapists to cater to our clients' every need.",
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSince1988Section() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "SINCE 1988 ©",
            style: TextStyle(
              color: Color(0xFFD4A853),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            "We've built more than barbershops.\nWe've built trust.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          "From a single shop to a growing network, ours is a place where craft is respected, conversations come naturally, and every cut is delivered with care.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: _buildStatNumber("35+", "Years", const Color(0xFFD4A853)),
            ),
            Container(width: 1, height: 48, color: const Color(0xFF2A2A2A)),
            Expanded(
              child: _buildStatNumber("40+", "Branches", const Color(0xFF999999)),
            ),
            Container(width: 1, height: 48, color: const Color(0xFF2A2A2A)),
            Expanded(
              child: _buildStatNumber("500K+", "Clients", const Color(0xFF999999)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatNumber(String big, String small, Color color) {
    return Column(
      children: [
        Text(
          big,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          small,
          style: const TextStyle(
            color: Color(0xFF777777),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCoreValuesCard() {
    const values = [
      ("Be honest and true.", Icons.verified_user),
      ("Enjoy what you do.", Icons.sentiment_very_satisfied),
      ("Strive to be better.", Icons.trending_up),
      ("Treat others with concern.", Icons.favorite_border),
      ("Encourage & support each other.", Icons.people),
      ("Deliver on your promise.", Icons.check_circle),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Our Core Values",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "The principles that guide us every single day.",
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(values.length, (i) {
          final (label, icon) = values[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: i % 2 == 0
                        ? const Color(0xFFD4A853).withValues(alpha: 0.15)
                        : const Color(0xFF242424),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: i % 2 == 0 ? const Color(0xFFD4A853) : Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBranchCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4A853), Color(0xFF9F7A26)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.location_on_outlined, color: Color(0xFF0F0F0F), size: 28),
          SizedBox(height: 14),
          Text(
            "We're right around\nthe corner.",
            style: TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Wherever you are in the Philippines, we've got a chair waiting for you.",
            style: TextStyle(
              color: Color(0xBF0F0F0F),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
