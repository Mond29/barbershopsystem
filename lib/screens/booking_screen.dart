import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/service.dart';
import '../data/sample_data.dart';

class BookingScreen extends StatefulWidget {
  final BarberService? preselectedService;
  final Branch? preselectedBranch;

  const BookingScreen({
    super.key,
    this.preselectedService,
    this.preselectedBranch,
  });

  @override
  State<BookingScreen> createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _requestsController = TextEditingController();
  final _nameOnCardController = TextEditingController();

  BarberService? _selectedService;
  SubService? _selectedSubService;
  Branch? _selectedBranch;
  DateTime? _selectedDate;
  String? _selectedTime;
  int? _selectedBarberIndex;
  int _currentStep = 0;

  Branch get _defaultBranch => SampleData.branches.first;

  final List<String> _barbers = const [
    "Master Barber Alex",
    "Senior Barber Ben",
    "Barber Carlo",
    "Barber Dave",
    "Stylist Ella",
    "Any Available Barber/Stylist",
  ];

  @override
  void initState() {
    super.initState();
    _selectedService = widget.preselectedService;
    _selectedBranch = _defaultBranch;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _requestsController.dispose();
    _nameOnCardController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    if (_selectedSubService != null) return _selectedSubService!.price;
    return _selectedService?.price ?? 0;
  }

  String get _serviceNameDisplay {
    if (_selectedSubService != null) {
      return "${_selectedService!.name} — ${_selectedSubService!.name}";
    }
    return _selectedService?.name ?? "—";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 390 ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(horizontalPadding),
              _buildStepper(horizontalPadding),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        8,
                        horizontalPadding,
                        20,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(child: _buildCurrentStep()),
                      ),
                    );
                  },
                ),
              ),
              _buildBottomButtons(horizontalPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        14,
        horizontalPadding,
        14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Book Appointment",
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.sizeOf(context).width < 390 ? 26 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Your seat's waiting — 4 easy steps.",
            style: TextStyle(color: Color(0xFF999999), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(double horizontalPadding) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 390;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              _buildStepCircle(1, "Location\n& Service", 0, compact),
              _buildStepConnector(0),
              _buildStepCircle(2, "Date &\nTime", 1, compact),
              _buildStepConnector(1),
              _buildStepCircle(3, "Special\nRequests", 2, compact),
              _buildStepConnector(2),
              _buildStepCircle(4, "Your\nInfo", 3, compact),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepCircle(int number, String label, int index, bool compact) {
    final itemWidth = compact ? 52.0 : 62.0;
    final circleSize = compact ? 34.0 : 38.0;
    final isActive = _currentStep >= index;
    final isCurrent = _currentStep == index;
    return SizedBox(
      width: itemWidth,
      child: Column(
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFD4A853)
                  : const Color(0xFF1A1A1A),
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrent
                    ? const Color(0xFFD4A853)
                    : isActive
                    ? const Color(0xFFD4A853)
                    : const Color(0xFF2A2A2A),
                width: isCurrent ? 2.5 : 1,
              ),
            ),
            child: Center(
              child: isActive && index < _currentStep
                  ? const Icon(Icons.check, color: Color(0xFF0F0F0F), size: 18)
                  : Text(
                      "$number",
                      style: TextStyle(
                        color: isActive
                            ? const Color(0xFF0F0F0F)
                            : Colors.white,
                        fontSize: compact ? 12 : 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFFD4A853)
                  : const Color(0xFF666666),
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int index) {
    final isDone = _currentStep > index;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            color: isDone ? const Color(0xFFD4A853) : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1LocationService();
      case 1:
        return _buildStep2DateTime();
      case 2:
        return _buildStep3Requests();
      case 3:
        return _buildStep4Details();
      default:
        return const SizedBox.shrink();
    }
  }

  // ====== STEP 1: Location + Service ======
  Widget _buildStep1LocationService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildBigSection(
          "Your location",
          "Automatically selected for this booking",
        ),
        const SizedBox(height: 10),
        _buildBranchShortList(),
        const SizedBox(height: 20),
        _buildBigSection(
          "Pick your service",
          "Tap a service to select, then choose options",
        ),
        const SizedBox(height: 10),
        _buildServiceShortList(),
        if (_selectedService != null &&
            (_selectedService!.subServices != null &&
                _selectedService!.subServices!.isNotEmpty)) ...[
          const SizedBox(height: 16),
          _buildBigSection(
            "Choose option",
            "What specific ${_selectedService!.name}?",
          ),
          const SizedBox(height: 10),
          _buildSubServiceSelector(),
        ],
        const Spacer(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBranchShortList() {
    final branch = _defaultBranch;
    return Semantics(
      label: '${branch.name}, selected location',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFD4A853).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD4A853), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A853),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: const Color(0xFF0F0F0F),
                    size: 14,
                  ),
                ),
                const Spacer(),
                const Text(
                  'ONLY LOCATION',
                  style: TextStyle(
                    color: Color(0xFFD4A853),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFD4A853),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              branch.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              branch.city,
              style: const TextStyle(color: Color(0xFF888888), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceShortList() {
    final categories = SampleData.serviceCategories
        .where((c) => c != 'All')
        .take(6)
        .toList();
    return Column(
      children: categories.map((cat) {
        final svcs = SampleData.services
            .where((s) => s.category == cat)
            .toList();
        if (svcs.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                cat.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFD4A853),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            ...svcs.map((s) {
              final isSel = _selectedService?.id == s.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedService = s;
                      _selectedSubService = null;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSel
                          ? const Color(0xFFD4A853).withValues(alpha: 0.08)
                          : const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSel
                            ? const Color(0xFFD4A853)
                            : const Color(0xFF2A2A2A),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSel
                                ? const Color(0xFFD4A853)
                                : const Color(
                                    0xFFD4A853,
                                  ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            s.icon,
                            size: 18,
                            color: isSel
                                ? const Color(0xFF0F0F0F)
                                : const Color(0xFFD4A853),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (s.subServices != null &&
                                  s.subServices!.isNotEmpty)
                                Text(
                                  "${s.subServices!.length} options",
                                  style: const TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          "₱${s.price.toInt()}",
                          style: const TextStyle(
                            color: Color(0xFFD4A853),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSubServiceSelector() {
    final subs = _selectedService!.subServices ?? [];
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentWidth = screenWidth - (screenWidth < 390 ? 32 : 48);
    final cardWidth = screenWidth < 332
        ? contentWidth
        : (contentWidth - 12) / 2;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(subs.length, (index) {
        final subService = subs[index];
        final isSelected = _selectedSubService?.id == subService.id;
        final foreground = isSelected ? const Color(0xFF0F0F0F) : Colors.white;

        return SizedBox(
          width: cardWidth,
          height: 124,
          child: InkWell(
            onTap: () => setState(() {
              _selectedSubService = isSelected ? null : subService;
            }),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFD4A853)
                    : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD4A853)
                      : const Color(0xFF2A2A2A),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      subService.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          "₱${subService.price.toInt()}",
                          style: TextStyle(
                            color: isSelected
                                ? foreground
                                : const Color(0xFFD4A853),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        "${subService.durationMinutes}m",
                        style: TextStyle(
                          color: isSelected
                              ? foreground.withValues(alpha: 0.65)
                              : const Color(0xFF888888),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ====== STEP 2: Date + Time + Barber ======
  Widget _buildStep2DateTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildBigSection("Select date", "Choose your appointment day"),
        const SizedBox(height: 14),
        _buildDateSelector(),
        const SizedBox(height: 28),
        _buildBigSection(
          "Pick a time slot",
          "We recommend 30 min before peak hours",
        ),
        const SizedBox(height: 14),
        _buildTimeSelector(),
        const SizedBox(height: 28),
        _buildBigSection(
          "Choose barber / stylist",
          "Optional — we'll assign the best available",
        ),
        const SizedBox(height: 14),
        _buildBarberSelector(),
      ],
    );
  }

  Widget _buildBigSection(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 60)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFD4A853),
                  onPrimary: Color(0xFF0F0F0F),
                  surface: Color(0xFF1A1A1A),
                  onSurface: Colors.white,
                ),
                dialogTheme: const DialogThemeData(
                  backgroundColor: Color(0xFF1A1A1A),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _selectedDate != null
                ? const Color(0xFFD4A853)
                : const Color(0xFF2A2A2A),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A853).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Color(0xFFD4A853),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Appointment Date",
                    style: TextStyle(color: Color(0xFF999999), fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedDate != null
                        ? DateFormat(
                            'EEEE, MMMM d, yyyy',
                          ).format(_selectedDate!)
                        : "Tap to select date",
                    style: TextStyle(
                      color: _selectedDate != null
                          ? Colors.white
                          : const Color(0xFF666666),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF666666),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    final slots = SampleData.availableTimeSlots;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(slots.length, (index) {
        final slot = slots[index];
        final isSelected = _selectedTime == slot;
        return InkWell(
          onTap: () => setState(() => _selectedTime = slot),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 86,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFD4A853)
                  : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFD4A853)
                    : const Color(0xFF2A2A2A),
              ),
            ),
            child: Center(
              child: Text(
                slot,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF0F0F0F) : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBarberSelector() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentWidth = screenWidth - (screenWidth < 390 ? 32 : 48);
    final cardWidth = screenWidth < 332
        ? contentWidth
        : (contentWidth - 12) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(_barbers.length, (index) {
        final isSelected = _selectedBarberIndex == index;
        return SizedBox(
          key: ValueKey('barber-card-$index'),
          width: cardWidth,
          height: 80,
          child: InkWell(
            onTap: () => setState(() => _selectedBarberIndex = index),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFD4A853).withValues(alpha: 0.08)
                    : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD4A853)
                      : const Color(0xFF2A2A2A),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFD4A853)
                          : const Color(0xFFD4A853).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person,
                      color: isSelected
                          ? const Color(0xFF0F0F0F)
                          : const Color(0xFFD4A853),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _barbers[index],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFFBBBBBB),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ====== STEP 3: Special Requests (NEW) ======
  Widget _buildStep3Requests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildBigSection("Special requests", "Anything you want us to know?"),
        const SizedBox(height: 8),
        const Text(
          "Feel free to leave it blank! You can also tell our staff in-person.",
          style: TextStyle(color: Color(0xFF888888), fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: TextField(
            controller: _requestsController,
            maxLines: 7,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              hintText:
                  "e.g.\n• My hair grows fast on the right side\n• Save some length on top\n• Allergic to hair dye\n• Inspired by \"Crew Cut\" style",
              hintStyle: TextStyle(
                color: Color(0xFF666666),
                fontSize: 13,
                height: 1.5,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 22),
        _buildSectionTitle("Quick suggestions (tap to add)"),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSuggestionChip("Fade on sides"),
            _buildSuggestionChip("Keep length on top"),
            _buildSuggestionChip("Skin fade"),
            _buildSuggestionChip("Scissor-only cut"),
            _buildSuggestionChip("Avoid thinning shears"),
            _buildSuggestionChip("Beard line-up included"),
            _buildSuggestionChip("Bring photo (will show staff)"),
            _buildSuggestionChip("Side part hard line"),
            _buildSuggestionChip("No products afterwards"),
            _buildSuggestionChip("Senior-friendly pressure on massage"),
          ],
        ),
        const SizedBox(height: 28),
        _buildSectionTitle("Appointment summary so far"),
        const SizedBox(height: 12),
        _buildMiniSummaryCard(),
      ],
    );
  }

  Widget _buildSectionTitle(String t) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xFFD4A853),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String t) {
    return InkWell(
      onTap: () {
        final current = _requestsController.text.trim();
        final prefix = current.isEmpty ? "" : "$current\n• ";
        final nextValue = current.isEmpty ? "• $t" : "$prefix$t";
        setState(() => _requestsController.text = nextValue);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: Text(
          "+ $t",
          style: const TextStyle(
            color: Color(0xFFBBBBBB),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMiniSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF151515)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          _summaryRow("Service", _serviceNameDisplay),
          const SizedBox(height: 8),
          _summaryRow("Branch", _selectedBranch?.name ?? "—"),
          const SizedBox(height: 8),
          _summaryRow(
            "Date",
            _selectedDate != null
                ? DateFormat('MMM d, yyyy').format(_selectedDate!)
                : "—",
          ),
          const SizedBox(height: 8),
          _summaryRow("Time", _selectedTime ?? "—"),
          const SizedBox(height: 8),
          _summaryRow(
            "Barber",
            _selectedBarberIndex != null
                ? _barbers[_selectedBarberIndex!]
                : "Any available",
          ),
          const Divider(color: Color(0xFF2A2A2A), height: 24),
          Row(
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                "₱${_totalPrice.toInt()}",
                style: const TextStyle(
                  color: Color(0xFFD4A853),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String k, String v) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            k,
            style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            v,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ====== STEP 4: Personal Details ======
  Widget _buildStep4Details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildBigSection(
          "Your details",
          "Contact info for appointment reminders",
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _nameController,
          label: "Full Name *",
          hint: "Juan Dela Cruz",
          icon: Icons.person,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return "Please enter your full name";
            }
            if (v.trim().length < 3) return "At least 3 characters";
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: "Phone Number *",
          hint: "0917 123 4567",
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return "Please enter your phone";
            }
            final c = v.replaceAll(RegExp(r'[^\d]'), '');
            if (c.length < 10) return "Enter a valid phone number";
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: "Email Address",
          hint: "juan@email.com",
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return null;
            final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!regex.hasMatch(v.trim())) return "Enter a valid email";
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nameOnCardController,
          label: "Referrer (if any)",
          hint: "Friend or barber name that referred you",
          icon: Icons.badge,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1408),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD4A853).withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline, color: Color(0xFFD4A853), size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Payment is settled IN-STORE after your service. You may change or add services on arrival — just let our staff know.",
                  style: TextStyle(
                    color: Color(0xFFDDDDDD),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _buildBigSection("Final summary", "Double-check your booking details"),
        const SizedBox(height: 14),
        _buildFullSummary(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF555555), fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFFD4A853), size: 20),
            filled: true,
            fillColor: const Color(0xFF1A1A1A),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: maxLines > 1 ? 14 : 0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFD4A853),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF151515)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.receipt_long, color: Color(0xFFD4A853), size: 20),
              SizedBox(width: 10),
              Text(
                "Booking Confirmation",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _summaryRow("Branch", _selectedBranch?.name ?? "—"),
          const SizedBox(height: 10),
          _summaryRow("Service", _serviceNameDisplay),
          const SizedBox(height: 10),
          _summaryRow(
            "Date",
            _selectedDate != null
                ? DateFormat('EEEE, MMM d, yyyy').format(_selectedDate!)
                : "—",
          ),
          const SizedBox(height: 10),
          _summaryRow("Time", _selectedTime ?? "—"),
          const SizedBox(height: 10),
          _summaryRow(
            "Barber",
            _selectedBarberIndex != null
                ? _barbers[_selectedBarberIndex!]
                : "Any available",
          ),
          const SizedBox(height: 10),
          _summaryRow(
            "Client",
            _nameController.text.trim().isEmpty
                ? "—"
                : _nameController.text.trim(),
          ),
          const SizedBox(height: 10),
          _summaryRow(
            "Phone",
            _phoneController.text.trim().isEmpty
                ? "—"
                : _phoneController.text.trim(),
          ),
          if (_requestsController.text.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            _summaryRow("Requests", _requestsController.text.trim()),
          ],
          const Divider(color: Color(0xFF2A2A2A), height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount (pay in-store)",
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "₱${_totalPrice.toInt()}",
                style: const TextStyle(
                  color: Color(0xFFD4A853),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====== BOTTOM NAV / STEP BUTTONS ======
  Widget _buildBottomButtons(double horizontalPadding) {
    bool canProceed = true;
    String? errorMsg;

    switch (_currentStep) {
      case 0:
        canProceed = _selectedBranch != null && _selectedService != null;
        errorMsg = "Pick a branch and a service first";
        break;
      case 1:
        canProceed = _selectedDate != null && _selectedTime != null;
        errorMsg = "Select a date AND time to proceed";
        break;
      case 2:
        canProceed = true;
        break;
      case 3:
        canProceed = true;
        break;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        12,
        horizontalPadding,
        16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        border: Border(top: BorderSide(color: Color(0xFF1A1A1A))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep--),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF333333)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: canProceed
                    ? () {
                        if (_currentStep == 3) {
                          if (_formKey.currentState?.validate() ?? false) {
                            _submitBooking();
                          }
                        } else {
                          setState(() => _currentStep++);
                        }
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              errorMsg ?? "Complete required fields first",
                            ),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: canProceed
                      ? const Color(0xFFD4A853)
                      : const Color(0xFF333333),
                  foregroundColor: canProceed
                      ? const Color(0xFF0F0F0F)
                      : const Color(0xFF666666),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentStep == 3
                      ? "Submit Booking Request"
                      : "Next Step ${_currentStep + 2}/4",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitBooking() {
    final submittedAt = DateTime.now();
    final bookingReference =
        "GB-${DateFormat('MMdd').format(submittedAt)}-${submittedAt.millisecondsSinceEpoch.toString().substring(7)}";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4A853),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  color: Color(0xFF0F0F0F),
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Request Submitted",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Hi ${_nameController.text.trim().isEmpty ? 'there' : _nameController.text.trim()}! The shop will review your booking before it is confirmed.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F0F),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: Column(
                  children: [
                    _buildDialogRow("Reference", bookingReference),
                    const SizedBox(height: 6),
                    _buildDialogRow("Status", "Pending approval"),
                    const Divider(color: Color(0xFF2A2A2A), height: 22),
                    _buildDialogRow("Service", _serviceNameDisplay),
                    const SizedBox(height: 6),
                    _buildDialogRow("Branch", _selectedBranch?.name ?? "—"),
                    const SizedBox(height: 6),
                    _buildDialogRow(
                      "When",
                      _selectedDate != null
                          ? "${DateFormat('MMM d').format(_selectedDate!)} · ${_selectedTime ?? ''}"
                          : "—",
                    ),
                    const SizedBox(height: 6),
                    _buildDialogRow("Amount", "₱${_totalPrice.toInt()}"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "We'll notify you using your contact details once the shop approves or proposes a new schedule.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD4A853),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A853),
                    foregroundColor: const Color(0xFF0F0F0F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Got it",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogRow(String k, String v) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
        Flexible(
          child: Text(
            v,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _selectedService = widget.preselectedService;
      _selectedBranch = _defaultBranch;
      _selectedSubService = null;
      _selectedDate = null;
      _selectedTime = null;
      _selectedBarberIndex = null;
    });
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _requestsController.clear();
    _nameOnCardController.clear();
  }
}
