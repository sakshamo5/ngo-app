import 'package:flutter/material.dart';

class Ngo {
  final String id;
  final String name;
  final String category;
  final String description;
  final double goalAmount;
  double raisedAmount;
  final IconData icon;
  final Color color;

  Ngo({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.goalAmount,
    required this.raisedAmount,
    required this.icon,
    required this.color,
  });

  double get progress => (raisedAmount / goalAmount).clamp(0.0, 1.0);
  String get progressPercent => '${(progress * 100).toStringAsFixed(1)}%';

  static List<Ngo> dummyNgos = [
    Ngo(
      id: '1',
      name: 'Educate India Foundation',
      category: 'Education',
      description:
          'Providing quality education to underprivileged children across rural India. We build schools, train teachers, and distribute learning materials to ensure every child has access to education.',
      goalAmount: 500000,
      raisedAmount: 325000,
      icon: Icons.school,
      color: const Color(0xFF6C63FF),
    ),
    Ngo(
      id: '2',
      name: 'Bright Future Academy',
      category: 'Education',
      description:
          'Empowering youth through digital literacy and vocational training programs. We bridge the skill gap for students from economically weaker sections.',
      goalAmount: 300000,
      raisedAmount: 180000,
      icon: Icons.menu_book,
      color: const Color(0xFF5B8DEF),
    ),
    Ngo(
      id: '3',
      name: 'HealthFirst Initiative',
      category: 'Health',
      description:
          'Bringing affordable healthcare to remote villages. Our mobile medical units provide free check-ups, medicines, and health awareness programs.',
      goalAmount: 800000,
      raisedAmount: 520000,
      icon: Icons.local_hospital,
      color: const Color(0xFFFF6B6B),
    ),
    Ngo(
      id: '4',
      name: 'MedCare for All',
      category: 'Health',
      description:
          'Supporting cancer patients who cannot afford treatment. We fund surgeries, chemotherapy, and post-treatment care for those in need.',
      goalAmount: 1000000,
      raisedAmount: 650000,
      icon: Icons.favorite,
      color: const Color(0xFFEE5A6F),
    ),
    Ngo(
      id: '5',
      name: 'Green Earth Movement',
      category: 'Environment',
      description:
          'Combating climate change through large-scale tree planting, waste management, and community-led conservation projects across the country.',
      goalAmount: 400000,
      raisedAmount: 290000,
      icon: Icons.eco,
      color: const Color(0xFF2ECC71),
    ),
    Ngo(
      id: '6',
      name: 'Clean Water Project',
      category: 'Environment',
      description:
          'Providing clean and safe drinking water to communities facing water scarcity. We install purification systems and dig bore wells.',
      goalAmount: 600000,
      raisedAmount: 350000,
      icon: Icons.water_drop,
      color: const Color(0xFF00B894),
    ),
    Ngo(
      id: '7',
      name: 'Paws & Claws Rescue',
      category: 'Animals',
      description:
          'Rescuing and rehabilitating abandoned and injured animals. We run shelters, provide veterinary care, and facilitate adoptions.',
      goalAmount: 250000,
      raisedAmount: 175000,
      icon: Icons.pets,
      color: const Color(0xFFFFA502),
    ),
    Ngo(
      id: '8',
      name: 'Wildlife Conservation Trust',
      category: 'Animals',
      description:
          'Protecting endangered species and their habitats. We work with local communities to create sustainable conservation models.',
      goalAmount: 750000,
      raisedAmount: 400000,
      icon: Icons.forest,
      color: const Color(0xFFE17055),
    ),
  ];
}
