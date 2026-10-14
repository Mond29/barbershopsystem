import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/service.dart';
import '../data/sample_data.dart';
import '../data/products_data.dart';

class ServicesScreen extends StatefulWidget {
  final void Function(int index, {BarberService? preselectedService})
  onBookService;
  final VoidCallback onOpenHairstyle;

  const ServicesScreen({
    super.key,
    required this.onBookService,
    required this.onOpenHairstyle,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _viewTab = 0; // 0 = Services list, 1 = Hairstyle Guide summary
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<String> get _categories => SampleData.serviceCategories;

  List<BarberService> get _filteredServices {
    var list = SampleData.services.toList();
    if (_selectedCategory != null && _selectedCategory != 'All') {
      list = list.where((s) => s.category == _selectedCategory).toList();
    }
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return list;

    final catalogOrder = <String, int>{
      for (var index = 0; index < list.length; index++) list[index].id: index,
    };
    list = list.where((service) => _searchRank(service, q) != null).toList()
      ..sort((a, b) {
        final rankComparison = _searchRank(a, q)!.compareTo(_searchRank(b, q)!);
        if (rankComparison != 0) return rankComparison;
        return catalogOrder[a.id]!.compareTo(catalogOrder[b.id]!);
      });
    return list;
  }

  int? _searchRank(BarberService service, String query) {
    final name = service.name.toLowerCase();
    final category = service.category.toLowerCase();
    final description = service.description.toLowerCase();
    final subServiceNames =
        service.subServices
            ?.map((subService) => subService.name.toLowerCase())
            .toList() ??
        const <String>[];

    bool wordStartsWith(String value) => value
        .split(RegExp(r'[^a-z0-9]+'))
        .any((word) => word.startsWith(query));

    if (name == query) return 0;
    if (name.startsWith(query)) return 1;
    if (wordStartsWith(name)) return 2;
    if (category == query || category.startsWith(query)) return 3;
    if (subServiceNames.any(wordStartsWith)) return 4;
    if (name.contains(query) || category.contains(query)) return 5;
    if (subServiceNames.any((subService) => subService.contains(query))) {
      return 6;
    }
    if (description.contains(query)) return 7;
    return null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabSwitcher(),
            if (_viewTab == 0) ...[_buildSearchBar(), _buildCategoryChips()],
            const SizedBox(height: 8),
            Expanded(
              child: _viewTab == 0
                  ? _buildServicesList()
                  : _buildHairstyleShorthand(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Our Services",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Crafted for confidence. Your style. Our craft.",
            style: TextStyle(color: Color(0xFF999999), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _viewTab = 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _viewTab == 0
                        ? const Color(0xFFD4A853)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Services",
                      style: TextStyle(
                        color: _viewTab == 0
                            ? const Color(0xFF0F0F0F)
                            : Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _viewTab = 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _viewTab == 1
                        ? const Color(0xFFD4A853)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Hairstyle Guide",
                      style: TextStyle(
                        color: _viewTab == 1
                            ? const Color(0xFF0F0F0F)
                            : Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: TextField(
          controller: _searchController,
          inputFormatters: [LengthLimitingTextInputFormatter(100)],
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: "Search services, cuts, treatments...",
            hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 15),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFFD4A853),
              size: 22,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Color(0xFF666666),
                      size: 20,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = (_selectedCategory ?? 'All') == cat;
          return ChoiceChip(
            label: Text(cat),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            visualDensity: VisualDensity.compact,
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedCategory = isSelected ? null : cat;
              });
            },
            backgroundColor: const Color(0xFF1A1A1A),
            selectedColor: const Color(0xFFD4A853),
            labelStyle: TextStyle(
              color: isSelected ? const Color(0xFF0F0F0F) : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFFD4A853)
                    : const Color(0xFF2A2A2A),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHairstyleShorthand() {
    final styles = HairstylesData.all;
    final gradients = const [
      [Color(0xFFD4A853), Color(0xFF7A5A18)],
      [Color(0xFF444444), Color(0xFF1A1A1A)],
      [Color(0xFF99691C), Color(0xFF3D2A0B)],
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1408),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFD4A853).withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFFD4A853),
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Tap 'Full Guide' below for the full Hairstyle Guide with product recommendations and booking.",
                    style: TextStyle(
                      color: Color(0xFFDDDDDD),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onOpenHairstyle,
                  child: const Text(
                    "Full Guide",
                    style: TextStyle(
                      color: Color(0xFFD4A853),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 224,
            ),
            itemCount: styles.length,
            itemBuilder: (ctx, i) {
              final s = styles[i];
              final g = gradients[i % gradients.length];
              final hasImage = s.imagePath != null;
              return InkWell(
                onTap: widget.onOpenHairstyle,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (hasImage)
                          Image.asset(
                            s.imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: g),
                              ),
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: g),
                            ),
                          ),
                        // Dark gradient overlay for text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.3),
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.35,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(s.icon, color: Colors.white),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "#${i + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black54,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                s.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 6,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.tagline,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 11,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 4,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    if (_filteredServices.isEmpty) return _buildEmptyState();
    final compact = MediaQuery.sizeOf(context).width < 390;
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(compact ? 16 : 24, 8, compact ? 16 : 24, 24),
      itemCount: _filteredServices.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildServiceTile(_filteredServices[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A853).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.search_off,
                        color: Color(0xFFD4A853),
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No services found",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Try a different search or category.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceTile(BarberService service) {
    final compact = MediaQuery.sizeOf(context).width < 390;
    final hasSubs =
        service.subServices != null && service.subServices!.isNotEmpty;
    final hasTiers =
        service.priceTiers != null && service.priceTiers!.isNotEmpty;
    final subsLine = hasSubs
        ? "${service.subServices!.length} variants"
        : hasTiers
        ? "${service.priceTiers!.length} tiers"
        : null;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showServiceDetail(service),
          child: Padding(
            padding: EdgeInsets.all(compact ? 12 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: compact ? 52 : 60,
                  height: compact ? 52 : 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4A853), Color(0xFFB8892E)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    service.icon,
                    color: const Color(0xFF0F0F0F),
                    size: compact ? 24 : 28,
                  ),
                ),
                SizedBox(width: compact ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFD4A853,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                service.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFD4A853),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Color(0xFF999999),
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${service.durationMinutes}m",
                                  style: const TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (subsLine != null)
                        Text(
                          subsLine,
                          style: const TextStyle(
                            color: Color(0xFFD4A853),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (subsLine == null)
                        Text(
                          service.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "from ₱${service.price.toInt()}",
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Color(0xFFD4A853),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (hasSubs || hasTiers)
                                  const Text(
                                    "Tap for options",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFF777777),
                                      fontSize: 10,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: compact ? 66 : 74,
                            height: 38,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).maybePop();
                                widget.onBookService(
                                  2,
                                  preselectedService: service,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4A853),
                                foregroundColor: const Color(0xFF0F0F0F),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Book",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showServiceDetail(BarberService service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F0F0F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.92,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD4A853), Color(0xFFB8892E)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          service.icon,
                          color: const Color(0xFF0F0F0F),
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFD4A853,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          service.category,
                          style: const TextStyle(
                            color: Color(0xFFD4A853),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        service.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        "from ₱${service.price.toInt()}  ·  ${service.durationMinutes} min",
                        style: const TextStyle(
                          color: Color(0xFFD4A853),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        service.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 14,
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (service.subServices != null &&
                        service.subServices!.isNotEmpty) ...[
                      _buildSectionTitle("Available Options"),
                      const SizedBox(height: 10),
                      ...service.subServices!.map(
                        (s) => _buildPricingRow(
                          s.name,
                          s.price.toInt(),
                          durationText: "${s.durationMinutes}m",
                        ),
                      ),
                    ] else if (service.priceTiers != null &&
                        service.priceTiers!.isNotEmpty) ...[
                      _buildSectionTitle("Price Tiers (by hair length)"),
                      const SizedBox(height: 10),
                      ...service.priceTiers!.map(
                        (t) => _buildPricingRow(t.label, t.price.toInt()),
                      ),
                    ] else ...[
                      _buildDetailRow(
                        icon: Icons.access_time,
                        label: "Duration",
                        value: "${service.durationMinutes} minutes",
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.verified,
                        label: "Barber",
                        value: "Licensed professionals",
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.star,
                        label: "Products",
                        value: "Premium in-store brands",
                      ),
                    ],
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFF2A2A2A)),
                    const SizedBox(height: 20),
                    _buildSectionTitle("What's included:"),
                    const SizedBox(height: 10),
                    _buildBulletPoint("Professional consultation"),
                    _buildBulletPoint("Premium shampoo & conditioner"),
                    _buildBulletPoint("Service by licensed barber"),
                    _buildBulletPoint(
                      "Hot towel treatment (on applicable services)",
                    ),
                    _buildBulletPoint("Final styling & product recommendation"),
                    const SizedBox(height: 28),
                    const Text(
                      "* Prices and service offerings may vary depending on the branch.",
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onBookService(2, preselectedService: service);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A853),
                          foregroundColor: const Color(0xFF0F0F0F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Book This Service",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String label) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFFD4A853),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPricingRow(String label, int price, {String? durationText}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (durationText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                durationText,
                style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            "₱$price",
            style: const TextStyle(
              color: Color(0xFFD4A853),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A853).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFD4A853), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.check_circle, color: Color(0xFFD4A853), size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
