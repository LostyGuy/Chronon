import 'package:flutter/material.dart';

import 'package:chronon/v1/Shared/chronon_colors.dart';

/// Shared page footer used across all Chronon pages.
class ChrononFooter extends StatelessWidget {
  const ChrononFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: const BoxDecoration(
        color: ChrononColors.abyss,
        border: Border(top: BorderSide(color: ChrononColors.navyBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ChrononColors.cyanAccent, ChrononColors.cobalt],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Chronon',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ],
              ),

              // Copyright
              const Text(
                '© 2026 Chronon (Uni-Schedule). Maksym Knasiecki (LostyGuy). Open-source.',
                style: TextStyle(color: ChrononColors.textDim, fontSize: 13),
              ),

              // Contact
              const Text(
                'lostyguycontacts@gmail.com <- contact me',
                style: TextStyle(color: ChrononColors.textDim, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
