# Bruno's Full Features Implementation Plan

## Repository Research
**Current App**: Dark/gold theme Flutter app na may 4 na bottom-nav screens lang:
- Dashboard (4 quick actions, featured services, about, branches preview)
- Services (12 services, 7 categories, search + filter chips)
- Booking (3-step wizard: Service → Schedule → Details)
- Contacts (6 branches, quick contacts, city filter)

**Bruno's Actual Website Features na WALA PA sa app:**
1. **🛒 Products/Shop Page** — full product catalog (Hairstyling: Pomades, Sea Salt Spray, Hairwax, Fibers; Hair Care: Shampoos; Gift Cards)
2. **💈 Hairstyle Guide** — 7 hairstyle inspirations (Buzz, Crew, Fade, Pompadour, Mullet, Side Part, Taper) with descriptions + recommended products
3. **📋 Expanded Services (50+ items from 11 categories)** — kumpletong Bruno's pricelist with sub-services (e.g. Haircut = 4 subs, Hair Color = 4 length tiers, Scalp Care = 5 subs, etc.)
4. **📍 Expanded Branches (40+)** — grouped by REGION (Metro Manila / Luzon / Visayas / Mindanao) → CITY → with landline + mobile numbers
5. **🎯 Full "Who We Are" Screen** — Our Vision, Our Purpose, Since 1988 History, 6 Core Values
6. **🏠 Dashboard Additions** — Featured Products section, Hairstyle Guide preview, Shop Products quick action, Gift Cards/Corporate banner

**Navigation constraint**: Keep original 4 bottom nav tabs per user's initial request. New major screens (Products, WhoWeAre, HairstyleGuide) will be pushed via Navigator from inside the 4 main screens.

---

## Files and Modules

### NEW Files (to create)
- `lib/models/product.dart` — `Product` model + `Hairstyle` model
- `lib/data/products_data.dart` — kumpletong 8+ Bruno's products + Gift Cards info
- `lib/data/hairstyles_data.dart` — 7 Hairstyle Guide entries
- `lib/screens/products_screen.dart` — full Products catalog with category tabs, product detail bottom sheet
- `lib/screens/about_screen.dart` — Who We Are page (Vision / Purpose / Core Values / History)
- `lib/screens/hairstyle_guide_screen.dart` — Hairstyle Guide gallery with detail view

### Files to UPDATE (with their changes)
- `lib/models/service.dart` — Add `subServices` list, `priceTiersByLength` map support; `Branch` gets `mobileNumbers`, `region`, `city` grouping fields
- `lib/data/sample_data.dart` — Replace 12 services → 50+ Bruno's-exact services with correct prices; Replace 6 branches → 40+ grouped by region/city; Add time slot tweaks
- `lib/screens/dashboard_screen.dart` — Add "Shop Products" quick action (5th), Featured Products horizontal carousel, Hairstyle Guide preview, Gift Cards CTA banner, updated About → navigates to AboutScreen
- `lib/screens/services_screen.dart` — Update categories list to match Bruno's 11 tabs; Use actual 50+ Bruno's-priced services; Add "Hairstyle Guide" internal tab at top
- `lib/screens/booking_screen.dart` — Change from 3 steps to 4 steps to match Bruno's exact flow: (1) Location + Service → (2) Date & Time + Barber → (3) Special Requests → (4) Your Info; Add requests textarea step
- `lib/screens/contacts_screen.dart` — Add Region tabs (Metro Manila/Luzon/Visayas/Mindanao), upgrade to 40+ branches with city grouping, add mobile + landline row
- `lib/main.dart` — Wire routes: handle `onShopProducts()`, `onOpenAbout()`, `onOpenHairstyleGuide()` navigation callbacks; pass to relevant screens

### Dependencies
No new packages needed — current deps (flutter, intl, url_launcher, cupertino_icons) are sufficient. We'll use placeholder product image gradients instead of network images to avoid asset dependencies.

---

## Implementation Steps (Dependency Order)

### Step 1: Expand Models & Build All Data Files (foundation, do first)
1. Update `models/service.dart`:
   - Add `List<SubService>? subServices` field
   - Add `List<PriceTier>? priceTiers` field (for hair color by length)
   - Add `String? region`, `String city`, `List<String>? mobileNumbers` sa `Branch`
2. Create `models/product.dart` with `Product`, `ProductPriceTier`, `Hairstyle` classes
3. Create `data/products_data.dart`:
   - Hairstyling products: Liquid Pomade 550, Sea Salt Spray 350, Kids Pomade 350, Water-based Pomade 350, Oil-based Pomade 350, Fiber Shiny 399, Fiber Matte 399, Hairwax 150
   - Hair Care: Anti-Dandruff Shampoo 350, Daily Care Shampoo 350
   - Gift Cards section data + Corporate Sales contact
4. Create `data/hairstyles_data.dart`: Buzz Cut, Crew Cut, Fade, Modern Mullet, Pompadour, Side Part, Taper — each with tagline, description, recommended product ID
5. **Replace** `data/sample_data.dart`:
   - 11 SERVICE CATEGORIES (Haircut, Hair Styling, Hair Removal, Massages, Stylist, Hand/Foot, Scalp Care, Facial Care, Hair Color, Hair Care, Other)
   - Totaling ~50 services with EXACT Bruno's prices (from website scrape)
   - 40+ BRANCHES grouped by region (start with ~30 Metro Manila entries from the scraped pages: QC, Makati, Taguig, Pasig, Paranaque, Las Pinas, Muntinlupa, San Juan, etc.) with actual phone numbers

### Step 2: Build 3 NEW Screens
1. **ProductsScreen** (`products_screen.dart`):
   - Category tabs: Latest / Hairstyling / Hair Care
   - 2-column product grid with product tile (icon gradient, name, price, "View Product" CTA)
   - Tap product → bottom sheet modal with details, product features, "Inquire via Call/Email" CTA that opens Contacts/dialer
   - Bottom section: Gift Cards + Corporate Sales banner
2. **AboutScreen** (`about_screen.dart`):
   - Hero: "Built on Trust" + since 1988
   - Section 1: Our Vision
   - Section 2: Our Purpose
   - Section 3: Our Core Values (6 bullets)
   - Section 4: "Since 1988" history paragraph
   - CTA buttons: View Services / View Branches
3. **HairstyleGuideScreen** (`hairstyle_guide_screen.dart`):
   - Horizontal category hero (7 tiles)
   - Detail card view: Hairstyle image (gradient + icon), name, tagline, description, "Recommended Products" chips linking to Products detail, CTA: "Book a haircut for this style" → auto-selects Haircut service in Booking

### Step 3: Update 4 Existing Main Screens
1. **DashboardScreen**:
   - Quick actions row: now 5 cards (add **Shop Products**)
   - After featured services section → insert **Featured Products** horizontal carousel
   - After branch preview → insert **Hairstyle Guide** 2-column preview grid (3 items) with "View All Hairstyles" button
   - Before phone CTA → insert **Gift Cards / Corporate Sales** gold banner with "Inquire" CTA → opens Contacts with email/phone options
   - Rework About section "Who We Are" card → "Know More" button navigates to AboutScreen
2. **ServicesScreen**:
   - Replace category list with the 11 Bruno's categories (keep "All")
   - Use expanded 50+ services list from new sample_data
   - Top: add tab switcher (or chip) between "Services" / "Hairstyle Guide"
   - Service detail sheet: updated summary, list of sub-services with individual prices if applicable, price tiers for length-based services
3. **BookingScreen**:
   - Step rename to 4 steps to match Bruno's:
     - Step 1 (was 0): **Location & Service** (merge branch + service selection into 1 screen, side-by-side)
     - Step 2: **Date, Time & Barber**
     - Step 3 (NEW): **Special Requests** (large notes textarea with suggested hints: "Preferred barber", "Hair inspiration photo", "Allergies", etc.)
     - Step 4: **Your Info** + Summary (same)
   - Validation per step, bottom nav step indicators updated to 4
4. **ContactsScreen**:
   - Insert Region selector tabs: Metro Manila / Luzon / Visayas / Mindanao (similar to Bruno's branches page)
   - Search stays; city chips stay but filter per region
   - Branch card redesign:
     - Title row: Name + City badge
     - Address
     - Row of phones: landline (call icon) + mobile 1 + mobile 2 as clickable chips
     - Operating hours line
     - Action buttons: Get Directions / Call / Book
   - Show 40+ branches from new data, paginated or grouped by city with headers

### Step 4: Wire Navigation in main.dart
- Add callbacks `onGoProducts`, `onGoAbout`, `onGoHairstyleGuide`
- Push `MaterialPageRoute` to the new screens when called (keep bottom nav visible approach: use each tab's internal Navigator key for pushing so bottom nav still shows)
- BookingScreen: When hairstyle guide triggers booking, pre-select the "Haircut" service

---

## Dependencies and Considerations
- **No new pub packages** required — we'll use gradient-filled containers with icons for ALL product/hairstyle imagery to skip asset work and keep build fast (no network images needed; Bruno's product photos map cleanly to icon + gradient mockups)
- **Price tiers by length**: For Hair Color/Hair Care services that have "Short/Medium/Long/Extra Long/Extra Short" prices, render as table rows inside service detail sheet
- **40+ branches**: We'll focus on the 30+ Metro Manila branches actually scraped from the site first; leave Luzon/Visayas/Mindanao tabs with empty-state "Coming Soon" branches for now (or add 2-3 example entries each)
- **Region data consistency**: Add a `region` enum field in Branch so tabs filter correctly

---

## Validation
1. **Compile-time check**: `flutter analyze` — 0 errors, 0 warnings, infos are fine
2. **Smoke navigation**: Tap Dashboard's Shop Products → ProductsScreen loads; tap Dashboard Who We Are → AboutScreen; tap Services tab → Hairstyle Guide tab; Booking wizard 4 steps flow completes with confirmation dialog
3. **Data fidelity check**: Spot-check service prices vs Bruno's website (Haircut PHP 480, w/ Shampoo+Blowdry 580, etc.)
4. **Contacts region tabs**: Switch region filters correctly; Call chip on a branch triggers tel: launch
5. **Booking pre-selection flows**:
   - Hairstyle Guide "Book this style" → Booking screen opens w/ Haircut selected
   - Service "Book Now" → Booking w/ service selected
   - Contacts "Book" → Booking w/ branch selected

---

## Risks
- **Risk: 40+ branches causes lag on very old devices** → Mitigation: Keep ListView lazy-loaded (ListView.builder) + city group headers are fine
- **Risk: 4-step booking UX changes may break existing pre-selected service logic** → Mitigation: Unit test the 3 pre-selection flows by manually navigating each path, check ValueKey unique refresh still works
- **Risk: Product screen gradient-only images may look "bare"** → Mitigation: Layer Icon + bold category badge + gold price tag on gradient to compensate — looks premium enough without real assets
- **Risk: Sandbox may block flutter analyze writes** → Mitigation: Manual build via `flutter run -d edge` still works; user hits "r" to hot reload if sandbox blocks analyze
