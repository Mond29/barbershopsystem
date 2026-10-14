import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/sample_data.dart';
import '../models/service.dart';

class ContactsScreen extends StatefulWidget {
  final void Function(int index, {Branch? selectedBranch}) onBookBranch;

  const ContactsScreen({super.key, required this.onBookBranch});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String? _searchCity;
  String _selectedRegion = 'Metro Manila';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not open link. Please try again."),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error opening link."),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _callBranch(String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final normalized = cleaned.startsWith('0')
        ? '+63${cleaned.substring(1)}'
        : cleaned.startsWith('63')
        ? '+$cleaned'
        : cleaned;
    final telUri = Uri(scheme: 'tel', path: normalized);
    await _launchUrl(telUri);
  }

  Future<void> _openMaps(Branch branch) async {
    final mapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': '${branch.name} ${branch.address} ${branch.city}',
      },
    );
    await _launchUrl(mapsUri);
  }

  List<Branch> get _regionBranches {
    return SampleData.branches
        .where((b) => b.region == _selectedRegion)
        .toList();
  }

  List<Branch> get _filteredBranches {
    var list = _regionBranches;
    if (_searchCity == null || _searchCity!.trim().isEmpty) {
      return list;
    }
    final query = _searchCity!.toLowerCase();
    return list
        .where(
          (b) =>
              b.city.toLowerCase().contains(query) ||
              b.name.toLowerCase().contains(query) ||
              b.address.toLowerCase().contains(query),
        )
        .toList();
  }

  Map<String, List<Branch>> get _groupedByCity {
    final Map<String, List<Branch>> groups = {};
    for (final b in _filteredBranches) {
      groups.putIfAbsent(b.city, () => []).add(b);
    }
    return groups;
  }

  List<String> get _regionCities {
    return _regionBranches.map((b) => b.city).toSet().toList()..sort();
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Contact Us",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Get in touch with us or visit our 40+ branches nationwide.",
                      style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: _buildContactHero(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _buildQuickContactRow(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: _buildRegionTabs(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                child: _buildSearchBar(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _buildCityChips(_regionCities),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Row(
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
                      "$_selectedRegion Branches",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${_filteredBranches.length} location${_filteredBranches.length != 1 ? 's' : ''}",
                      style: const TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _filteredBranches.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFD4A853,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.location_off,
                              color: Color(0xFFD4A853),
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No branches found",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Try a different city, region, or clear filters.",
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    sliver: _buildGroupedBranchList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactHero() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4A853), Color(0xFFB8892E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.support_agent, color: Color(0xFF0F0F0F), size: 32),
          const SizedBox(height: 16),
          const Text(
            "Gentleman Concierge",
            style: TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Need help booking or have questions? Our team is ready to assist you daily.",
            style: TextStyle(
              color: Color(0xBF0F0F0F),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.phone, color: Color(0xFF0F0F0F), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () => _callBranch("0289278667"),
                  child: const Text(
                    "(02) 89-GENTLE / +632 8927 8667",
                    softWrap: true,
                    style: TextStyle(
                      color: Color(0xFF0F0F0F),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickContactRow() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.phone,
            label: "Call Us",
            sublabel: "(02) 8927-8667",
            color: const Color(0xFF25D366).withValues(alpha: 0.15),
            iconColor: const Color(0xFF25D366),
            onTap: () => _callBranch("0289278667"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.email,
            label: "Email",
            sublabel: "info@gentlemanbarbers.com",
            color: const Color(0xFF3498DB).withValues(alpha: 0.15),
            iconColor: const Color(0xFF3498DB),
            onTap: () => _launchUrl(
              Uri(
                scheme: 'mailto',
                path: 'info@gentlemanbarbers.com',
                queryParameters: {'subject': 'Customer Inquiry'},
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.facebook,
            label: "Message",
            sublabel: "@gentlemanbarbers",
            color: const Color(0xFF1877F2).withValues(alpha: 0.15),
            iconColor: const Color(0xFF1877F2),
            onTap: () => _launchUrl(
              Uri.parse('https://facebook.com/gentlemanbarbersph'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF777777), fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: SampleData.regions.map((region) {
          final isActive = _selectedRegion == region;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _selectedRegion = region;
                  _searchCity = null;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFD4A853)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    region,
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFF0F0F0F)
                          : const Color(0xFFAAAAAA),
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: TextField(
        controller: _searchController,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        onChanged: (v) => setState(() => _searchCity = v),
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: "Search branch or city...",
          hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 15),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFFD4A853),
            size: 22,
          ),
          suffixIcon: _searchCity != null && _searchCity!.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchCity = null);
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
    );
  }

  Widget _buildCityChips(List<String> cities) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildChip(
          label: "All",
          isSelected: _searchCity == null,
          onTap: () {
            _searchController.clear();
            setState(() => _searchCity = null);
          },
        ),
        ...cities.map((city) {
          final isSelected = _searchCity?.toLowerCase() == city.toLowerCase();
          return _buildChip(
            label: city,
            isSelected: isSelected,
            onTap: () {
              _searchController.text = city;
              setState(() => _searchCity = city);
            },
          );
        }),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4A853) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4A853)
                : const Color(0xFF2A2A2A),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0F0F0F) : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedBranchList() {
    final grouped = _groupedByCity;
    final cities = grouped.keys.toList();
    final List<Widget> slivers = [];

    for (var i = 0; i < cities.length; i++) {
      final city = cities[i];
      final branches = grouped[city]!;

      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: i == 0 ? 8 : 20, bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A853).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFD4A853).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    city.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFD4A853),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${branches.length} branch${branches.length != 1 ? 'es' : ''}",
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      slivers.add(
        SliverList.separated(
          itemCount: branches.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _buildBranchCard(branches[index]);
          },
        ),
      );
    }

    return SliverMainAxisGroup(slivers: slivers);
  }

  Widget _buildBranchCard(Branch branch) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4A853), Color(0xFFB8892E)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFF0F0F0F),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${branch.city} • ${branch.region}",
                        style: const TextStyle(
                          color: Color(0xFFD4A853),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBranchInfoRow(
              icon: Icons.location_on_outlined,
              label: branch.address,
            ),
            const SizedBox(height: 10),
            _buildBranchInfoRow(
              icon: Icons.schedule,
              label: branch.operatingHours,
            ),
            if (branch.landline.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildBranchInfoRow(
                icon: Icons.phone,
                label: branch.landline,
                isPhone: true,
                onTap: () => _callBranch(branch.landline),
              ),
            ],
            if (branch.mobileNumbers.isNotEmpty) ...[
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.smartphone,
                      color: Color(0xFFD4A853),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: branch.mobileNumbers.map((phoneNumber) {
                        return InkWell(
                          onTap: () => _callBranch(phoneNumber),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFD4A853,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(
                                  0xFFD4A853,
                                ).withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.call,
                                  color: Color(0xFFD4A853),
                                  size: 13,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    phoneNumber,
                                    style: const TextStyle(
                                      color: Color(0xFFD4A853),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: () => _openMaps(branch),
                    icon: const Icon(Icons.map, size: 16),
                    label: const Text("Directions"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF333333)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (branch.mobileNumbers.isNotEmpty) {
                        _callBranch(branch.mobileNumbers.first);
                      } else if (branch.landline.isNotEmpty) {
                        _callBranch(branch.landline);
                      }
                    },
                    icon: const Icon(Icons.call, size: 16),
                    label: const Text("Call"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD4A853),
                      side: const BorderSide(color: Color(0xFFD4A853)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      widget.onBookBranch(2, selectedBranch: branch);
                    },
                    icon: const Icon(Icons.calendar_month, size: 16),
                    label: const Text("Book"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A853),
                      foregroundColor: const Color(0xFF0F0F0F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchInfoRow({
    required IconData icon,
    required String label,
    bool isPhone = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFD4A853), size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isPhone
                      ? const Color(0xFFD4A853)
                      : const Color(0xFFBBBBBB),
                  fontSize: 13,
                  decoration: isPhone
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: const Color(0xFFD4A853),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
