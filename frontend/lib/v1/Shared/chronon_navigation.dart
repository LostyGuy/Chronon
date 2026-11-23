import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'package:chronon/v1/Shared/chronon_colors.dart';

/// A single item shown in the desktop navigation bar.
class NavItem {
  final String label;
  final VoidCallback onTap;

  const NavItem({required this.label, required this.onTap});
}

/// Shared top navigation bar used across all Chronon pages.
///
/// Pass [navItems] for the desktop inline links and optional callbacks
/// for the right-hand action buttons.
class ChrononNavigation extends StatelessWidget {
  const ChrononNavigation({
    super.key,
    this.navItems = const [],
    this.onTryDemo,
  });

  /// Desktop-only inline text links (hidden on mobile).
  final List<NavItem> navItems;

  /// If non-null the "Try Demo*" button is shown and calls this callback.
  final VoidCallback? onTryDemo;

  void _openGitHub() {
    web.window.open('https://github.com/LostyGuy/Chronon', '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: ChrononColors.abyss.withValues(alpha: 0.88),
        border: const Border(
          bottom: BorderSide(color: ChrononColors.navyBorder, width: 1),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ── Brand Logo ───────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ChrononColors.cyanAccent, ChrononColors.cobalt],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66048AC1),
                          blurRadius: 14,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Chronon',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0x33048AC1),
                      border: Border.all(color: const Color(0x66048AC1)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: ChrononColors.cyanAccent,
                      ),
                    ),
                  ),
                ],
              ),

              // ── Navigation Links (Desktop only) ─────────────────────
              if (isDesktop && navItems.isNotEmpty)
                Row(
                  children: navItems
                      .map((item) => TextButton(
                            onPressed: item.onTap,
                            style: TextButton.styleFrom(
                              foregroundColor: ChrononColors.textMuted,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                            ),
                            child: Text(
                              item.label,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ))
                      .toList(),
                ),

              // ── Action Buttons ──────────────────────────────────────
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _openGitHub,
                    icon: const Icon(Icons.code_rounded, size: 18, color: ChrononColors.cyanAccent),
                    label: const Text('GitHub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ChrononColors.navyBorder),
                      backgroundColor: ChrononColors.navySurface,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  if (onTryDemo != null) ...[
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: onTryDemo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChrononColors.cobalt,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: const Color(0x80048AC1),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Try Demo*', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
