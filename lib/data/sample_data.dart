import 'package:flutter/material.dart';
import '../models/service.dart';

class SampleData {
  // ============================================================
  // BRUNO'S EXACT PRICELIST (Scraped from brunosbarbers.com/our-services)
  // ============================================================
  static const List<BarberService> services = [
    // =============== HAIRCUT ===============
    BarberService(
      id: 'haircut-main',
      name: 'Haircut',
      description:
          'A good haircut goes a long way. From first trims to signature styles, we\'ve been shaping generations with care, skill, and steady hands. Every cut is done with pride.',
      price: 480,
      durationMinutes: 45,
      icon: Icons.content_cut,
      category: 'Haircut',
      subServices: [
        SubService(id: 'hc1', name: 'Haircut', price: 480, durationMinutes: 45),
        SubService(id: 'hc2', name: 'Haircut with Shampoo & Blowdry', price: 580, durationMinutes: 60),
        SubService(id: 'hc3', name: 'Head Shave / Skin Shave', price: 700, durationMinutes: 45),
        SubService(id: 'hc4', name: 'Hair Art', price: 1140, durationMinutes: 90),
      ],
    ),
    BarberService(
      id: 'kids-haircut',
      name: 'Kids Haircut',
      description: 'Gentle, patient haircuts for children 12 & under. Fun environment, zero tears.',
      price: 380,
      durationMinutes: 30,
      icon: Icons.child_care,
      category: 'Haircut',
    ),
    BarberService(
      id: 'senior-haircut',
      name: 'Senior Haircut (60+)',
      description: 'Special care service for our seniors. Gentle & precise grooming.',
      price: 380,
      durationMinutes: 45,
      icon: Icons.elderly,
      category: 'Haircut',
    ),

    // =============== HAIR STYLING ===============
    BarberService(
      id: 'hair-styling-main',
      name: 'Hair Styling',
      description:
          'Big day or just another good hair day, we\'ve got you covered. Our barbers and stylists know how to bring out your best.',
      price: 300,
      durationMinutes: 30,
      icon: Icons.auto_awesome,
      category: 'Hair Styling',
      subServices: [
        SubService(id: 'hs1', name: 'Shampoo', price: 300, durationMinutes: 15),
        SubService(id: 'hs2', name: 'Blowdry (Short hair)', price: 300, durationMinutes: 20),
        SubService(id: 'hs3', name: 'Blowdry (Long hair)', price: 450, durationMinutes: 30),
        SubService(id: 'hs4', name: 'Iron / Curls', price: 550, durationMinutes: 45),
        SubService(id: 'hs5', name: 'Down Perm with Xtenso', price: 2000, durationMinutes: 120),
        SubService(id: 'hs6', name: 'Cold Perm with Dulcia (Short)', price: 2500, durationMinutes: 150),
        SubService(id: 'hs7', name: 'Cold Perm with Dulcia (Medium)', price: 3000, durationMinutes: 180),
        SubService(id: 'hs8', name: 'Cold Perm with Dulcia (Long)', price: 3500, durationMinutes: 200),
      ],
    ),

    // =============== HAIR REMOVAL ===============
    BarberService(
      id: 'hair-removal-main',
      name: 'Hair Removal',
      description: 'From smooth shaves to refined beard grooming. Precision every time.',
      price: 400,
      durationMinutes: 30,
      icon: Icons.face,
      category: 'Hair Removal',
      subServices: [
        SubService(id: 'hr1', name: 'Traditional Straight Razor Shave', price: 550, durationMinutes: 45),
        SubService(id: 'hr2', name: 'Beard / Moustache Trim & Shape', price: 400, durationMinutes: 30),
        SubService(id: 'hr3', name: 'Beard Art / Design', price: 800, durationMinutes: 60),
      ],
    ),

    // =============== MASSAGES ===============
    BarberService(
      id: 'massages-main',
      name: 'Massages',
      description:
          'Therapeutic 15-minute massages to relieve pressure, reduce fatigue, and restore balance. Add-on or standalone.',
      price: 350,
      durationMinutes: 15,
      icon: Icons.self_improvement,
      category: 'Massages',
      subServices: [
        SubService(id: 'm1', name: '15-min Scalp Massage', price: 350),
        SubService(id: 'm2', name: '15-min Back Massage', price: 350),
        SubService(id: 'm3', name: '15-min Hand Massage', price: 350),
        SubService(id: 'm4', name: '15-min Foot Massage', price: 350),
        SubService(id: 'm5', name: '60-min Full Body Massage', price: 1400, durationMinutes: 60),
      ],
    ),

    // =============== STYLIST ===============
    BarberService(
      id: 'stylist-main',
      name: 'Stylist Services',
      description:
          'Available at participating branches. Professional hair & makeup services by our trained stylists.',
      price: 600,
      durationMinutes: 60,
      icon: Icons.face_retouching_natural,
      category: 'Stylist',
      subServices: [
        SubService(id: 'st1', name: 'Stylist Cut', price: 600, durationMinutes: 60),
        SubService(id: 'st2', name: 'Stylist Cut w/ Shampoo & Blowdry', price: 700, durationMinutes: 75),
        SubService(id: 'st3', name: 'Hair & Makeup Package', price: 2400, durationMinutes: 120),
        SubService(id: 'st4', name: 'Makeup Only', price: 1800, durationMinutes: 60),
      ],
    ),

    // =============== HAND & FOOT CARE ===============
    BarberService(
      id: 'hand-foot-main',
      name: 'Hand and Foot Care',
      description:
          'Keep hands, feet, and grooming extras in top shape with our full suite of precision care services.',
      price: 400,
      durationMinutes: 30,
      icon: Icons.clean_hands,
      category: 'Hand and Foot Care',
      subServices: [
        SubService(id: 'hf1', name: 'Hand Nail Cleaning', price: 400),
        SubService(id: 'hf2', name: 'Hand Nail Cleaning w/ Polish', price: 500),
        SubService(id: 'hf3', name: 'Foot Nail Cleaning', price: 450),
        SubService(id: 'hf4', name: 'Foot Nail Cleaning w/ Polish', price: 600),
        SubService(id: 'hf5', name: 'Foot Spa w/ Nail Cleaning', price: 900, durationMinutes: 60),
        SubService(id: 'hf6', name: 'Foot Spa w/ Polish', price: 1150, durationMinutes: 75),
        SubService(id: 'hf7', name: 'Gel Removal (Hand/Foot)', price: 300),
        SubService(id: 'hf8', name: 'Nail Art (per nail — add on)', price: 50),
      ],
    ),

    // =============== SCALP CARE ===============
    BarberService(
      id: 'scalp-care-main',
      name: 'Scalp Care',
      description:
          'Healthy hair starts here. Thoughtful scalp solutions for every hair type — from root to tip.',
      price: 1800,
      durationMinutes: 60,
      icon: Icons.healing,
      category: 'Scalp Care',
      subServices: [
        SubService(id: 'sc1', name: 'Dandruff Control Therapy', price: 2000, durationMinutes: 75),
        SubService(id: 'sc2', name: 'Mentholated Soothing Scalp Therapy', price: 1800, durationMinutes: 60),
        SubService(id: 'sc3', name: 'Scalp Exfoliation & Oil Control', price: 2000, durationMinutes: 75),
        SubService(id: 'sc4', name: 'Hair Growth & Anti-Hairfall', price: 2200, durationMinutes: 90),
        SubService(id: 'sc5', name: 'Plarmia Japanese Headspa', price: 2200, durationMinutes: 90),
      ],
    ),

    // =============== FACIAL CARE ===============
    BarberService(
      id: 'facial-care-main',
      name: 'Facial Care',
      description: 'Professional-grade facials for clean, refreshed skin.',
      price: 1500,
      durationMinutes: 60,
      icon: Icons.face_6,
      category: 'Facial Care',
      subServices: [
        SubService(id: 'fc1', name: 'Deep Cleansing Facial', price: 1500, durationMinutes: 60),
        SubService(id: 'fc2', name: 'Hypoallergenic Facial', price: 2300, durationMinutes: 90),
      ],
    ),

    // =============== HAIR COLOR ===============
    BarberService(
      id: 'hair-color-main',
      name: 'Hair Color',
      description: 'Color services priced by hair length. Premium brands, even coverage.',
      price: 1700,
      durationMinutes: 120,
      icon: Icons.color_lens,
      category: 'Hair Color',
      priceTiers: [
        PriceTier(label: 'Standard Hair Color — Extra Short', price: 1700),
        PriceTier(label: 'Standard Hair Color — Short', price: 2200),
        PriceTier(label: 'Standard Hair Color — Medium', price: 2700),
        PriceTier(label: 'Standard Hair Color — Long', price: 3100),
        PriceTier(label: 'Standard Hair Color — Extra Long', price: 3500),
        PriceTier(label: 'Highlights — Short', price: 2200),
        PriceTier(label: 'Highlights — Medium', price: 2700),
        PriceTier(label: 'Highlights — Long', price: 3200),
        PriceTier(label: 'Highlights — Extra Long', price: 3700),
        PriceTier(label: 'Organic Hair Color — Extra Short', price: 2300),
        PriceTier(label: 'Organic Hair Color — Short', price: 2800),
        PriceTier(label: 'Organic Hair Color — Medium', price: 3400),
        PriceTier(label: 'Organic Hair Color — Long', price: 3900),
        PriceTier(label: 'Organic Hair Color — Extra Long', price: 4400),
        PriceTier(label: 'Moustache / Beard Color', price: 480),
      ],
    ),

    // =============== HAIR CARE / TREATMENT ===============
    BarberService(
      id: 'hair-care-main',
      name: 'Hair Care / Treatment',
      description: 'Repair and restore treatments. Priced by length.',
      price: 1900,
      durationMinutes: 90,
      icon: Icons.local_florist,
      category: 'Hair Care',
      priceTiers: [
        PriceTier(label: 'Intense Repair — Short', price: 3000),
        PriceTier(label: 'Intense Repair — Medium', price: 3150),
        PriceTier(label: 'Intense Repair — Long', price: 3550),
        PriceTier(label: 'Intense Repair — Extra Long', price: 3750),
        PriceTier(label: 'Damage Control — Short', price: 1900),
        PriceTier(label: 'Damage Control — Medium', price: 2100),
        PriceTier(label: 'Damage Control — Long', price: 2300),
        PriceTier(label: 'Damage Control — Extra Long', price: 2500),
      ],
    ),

    // =============== OTHER SERVICES ===============
    BarberService(
      id: 'ear-cleaning',
      name: 'Ear Cleaning',
      description:
          'Removes excess wax and buildup with care, promoting hygiene, comfort, and a clean, refreshed feel.',
      price: 500,
      durationMinutes: 20,
      icon: Icons.hearing,
      category: 'Other Services',
    ),

    // =============== PACKAGES ===============
    BarberService(
      id: 'executive-package',
      name: 'Executive Grooming Package',
      description:
          'The ultimate grooming experience: Haircut + Shave + Scalp Massage + Hand Care. Premium all-in-one service.',
      price: 1600,
      durationMinutes: 150,
      icon: Icons.workspace_premium,
      category: 'Packages',
    ),
    BarberService(
      id: 'best-life-package',
      name: 'Best Life Package',
      description: 'Haircut w/ Shampoo + 15-min Massage + Beard Trim. Top-rated combo.',
      price: 980,
      durationMinutes: 90,
      icon: Icons.favorite,
      category: 'Packages',
    ),
  ];

  static const List<String> serviceCategories = [
    'All',
    'Haircut',
    'Hair Styling',
    'Hair Removal',
    'Massages',
    'Stylist',
    'Hand and Foot Care',
    'Scalp Care',
    'Facial Care',
    'Hair Color',
    'Hair Care',
    'Other Services',
    'Packages',
  ];

  // ============================================================
  // BRANCHES: Single MOA branch only
  // ============================================================
  static const List<Branch> branches = [
    // ========== SM MALL OF ASIA (MOA) ==========
    Branch(
      id: 'moa-main',
      name: 'SM Mall of Asia',
      address: 'SM Mall of Asia, Ground Floor, Bay City, Pasay City',
      city: 'Pasay City',
      region: 'Metro Manila',
      landline: '(02) 8444-1111',
      mobileNumbers: ['+63 917 800 1234'],
      operatingHours: '10:00 AM – 10:00 PM (Mon-Sun)',
      latitude: 14.5337,
      longitude: 120.9824,
    ),
  ];

  static const List<String> regions = [
    'Metro Manila',
  ];

  static const List<String> availableTimeSlots = [
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
  ];
}
