import 'package:flutter/material.dart';

class PriceTier {
  final String label;
  final double price;

  const PriceTier({required this.label, required this.price});
}

class SubService {
  final String id;
  final String name;
  final double price;
  final int durationMinutes;

  const SubService({
    required this.id,
    required this.name,
    required this.price,
    this.durationMinutes = 30,
  });
}

class BarberService {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final IconData icon;
  final String category;
  final List<SubService>? subServices;
  final List<PriceTier>? priceTiers;

  const BarberService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.icon,
    required this.category,
    this.subServices,
    this.priceTiers,
  });
}

class Branch {
  final String id;
  final String name;
  final String address;
  final String city;
  final String region;
  final String landline;
  final List<String> mobileNumbers;
  final String operatingHours;
  final double latitude;
  final double longitude;

  const Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.region,
    required this.landline,
    required this.mobileNumbers,
    required this.operatingHours,
    required this.latitude,
    required this.longitude,
  });
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final IconData icon;
  final List<String> features;
  final String? badge;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.icon,
    this.features = const [],
    this.badge,
  });
}

class Hairstyle {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final IconData icon;
  final List<String> recommendedProductIds;

  const Hairstyle({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.icon,
    this.recommendedProductIds = const [],
  });
}
