import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'package:flutter_svg/flutter_svg.dart';

import 'package:chronon/v1/Shared/chronon_colors.dart';
import 'package:chronon/v1/Shared/chronon_navigation.dart';
import 'package:chronon/v1/Shared/chronon_footer.dart';
import 'package:chronon/v1/HomeSub/interactive_demo.dart';

// ---------------------------------------------------------------------------
// Home / Landing Page
// ---------------------------------------------------------------------------
class ChrononHomePage extends StatefulWidget {
  const ChrononHomePage({super.key});

  @override
  State<ChrononHomePage> createState() => _ChrononHomePageState();
}

class _ChrononHomePageState extends State<ChrononHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _demoKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _roadmapKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void redirectTo(String url, {bool newTab = false}) {
    if (newTab) {
      web.window.open(url, '_blank');
    } else {
      web.window.location.href = url;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Radial Gradient Ambient Lights
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.6, -0.6),
                  radius: 1.2,
                  colors: [Color(0x33024F86), Color(0x1A01305A), ChrononColors.abyss],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.8, -0.2),
                  radius: 1.0,
                  colors: [Color(0x26048AC1), Colors.transparent],
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // ── Shared Navigation ──
                  ChrononNavigation(
                    navItems: [
                      NavItem(label: 'Features', onTap: () => _scrollToKey(_featuresKey)),
                      NavItem(label: 'Live Timetable', onTap: () => _scrollToKey(_demoKey)),
                      NavItem(label: 'Architecture', onTap: () => _scrollToKey(_stackKey)),
                      NavItem(label: 'Roadmap', onTap: () => _scrollToKey(_roadmapKey)),
                      NavItem(label: 'FAQ', onTap: () => _scrollToKey(_faqKey)),
                    ],
                    onTryDemo: () => _scrollToKey(_demoKey),
                  ),

                  // ── Page Body ──
                  _buildHero(context),
                  Container(key: _demoKey, child: const InteractiveTimetableDemo()),
                  _asterisk(context),
                  _buildFeatures(context),
                  _buildTechStack(context),
                  _buildRoadmap(context),
                  _buildFaq(context),
                  _buildCtaBanner(context),

                  // ── Shared Footer ──
                  const ChrononFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 1. Hero Section
  // =========================================================================
  Widget _buildHero(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              // Phase Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x3301305A),
                  border: Border.all(color: const Color(0x66048AC1)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Color(0x22048AC1), blurRadius: 10)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: ChrononColors.cyanAccent,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: ChrononColors.cyanAccent, blurRadius: 6)],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Phase 3: Real-Time Event Processing & Alpha Pipeline',
                      style: TextStyle(color: ChrononColors.cyanAccent, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Headline
              Text(
                'Have one to rule them all',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth > 600 ? 44 : 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.2,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 20),

              // Subtitle
              Text(
                'Instead of checking numerous times an PDF or SpreadSheet and wonder whether the class is today or next week, choose Chronon where only one change is neccesarry for everyone to know about it. Class postponed? - They know. Room change? - Instant notification.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth > 600 ? 17 : 15,
                  color: ChrononColors.textMuted,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),

              // Hero CTA buttons
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _scrollToKey(_demoKey),
                    icon: const Icon(Icons.play_arrow_rounded, size: 22),
                    label: const Text('Explore Interactive Demo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ChrononColors.cobalt,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 8,
                      shadowColor: const Color(0x80048AC1),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: wire to v1 enrollment page
                    },
                    icon: const Icon(Icons.terminal_rounded, size: 20, color: ChrononColors.cyanAccent),
                    label: const Text('Register as a Tester', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ChrononColors.navyBorder, width: 1.5),
                      backgroundColor: ChrononColors.navySurface,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Stats Row
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x4001305A), width: 1)),
                ),
                child: Wrap(
                  spacing: 40,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _statItem('100%', 'Clarity & Speed'),
                    _statItem('39+', 'TDD Pytest Suite'),
                    _statItem('< 50ms', 'FastAPI Response'),
                    _statItem('Offline', 'Local Cache Fallback'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String number, String label) {
    return Column(children: [
      Text(number, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'monospace')),
      const SizedBox(height: 4),
      Text(label.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ChrononColors.textDim, letterSpacing: 0.8)),
    ]);
  }

  Widget _asterisk(BuildContext context) => const Center(child: Text('* - Subject to change'));

  // =========================================================================
  // 2. Features Grid
  // =========================================================================
  Widget _buildFeatures(BuildContext context) {
    return Container(
      key: _featuresKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      color: const Color(0x40011C3B),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(children: [
            _sectionHeader('KEY CAPABILITIES', 'Engineered for Academic Precision', 'Everything you need to master your university timetable with zero cognitive friction.'),
            const SizedBox(height: 48),
            Wrap(spacing: 20, runSpacing: 20, children: [
              _featureCard(Icons.view_timeline_outlined, 'Dynamic Visual Timeline', 'Chronological daily breakdown with remaining time indicators, current class highlights, and prominent room numbers.'),
              _featureCard(Icons.security_outlined, 'RBAC Security & Privacy', 'Role-Based Access Control protecting student data and allowing only verified academic staff to publish modifications.'),
              _featureCard(Icons.bolt_outlined, 'FastAPI & Supabase Backbone', 'Blazing asynchronous Python 3.12 endpoints combined with PostgreSQL and SQLAlchemy ORM for instant query responses.'),
              _featureCard(Icons.cloud_sync_outlined, 'Local + Cloud Double Cache', 'Minimizes database overload while slashing wait times. Offline local storage keeps your schedule accessible without internet.'),
              _featureCard(Icons.notification_important_outlined, 'Conflict & Overlap Detection', 'Automated schedule validation flags collision between concurrent lectures, double-booked professors, or room clashes.'),
              _featureCard(Icons.devices_outlined, 'Cross-Platform Flutter UI', 'Unified native experience across Mobile (Android & iOS) and Progressive Web Apps with smooth 60fps interaction.'),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String desc) {
    return SizedBox(
      width: 340,
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(color: ChrononColors.navySurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: ChrononColors.navyBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [ChrononColors.navyBorder, ChrononColors.cobalt]),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x66048AC1)),
            ),
            child: Icon(icon, color: ChrononColors.cyanAccent, size: 24),
          ),
          const SizedBox(height: 18),
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 14, color: ChrononColors.textMuted, height: 1.5)),
        ]),
      ),
    );
  }

  // =========================================================================
  // 3. Tech Stack
  // =========================================================================
  Widget _buildTechStack(BuildContext context) {
    return Container(
      key: _stackKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(children: [
            _sectionHeader('UNDER THE HOOD', 'Built with Battle-Tested Technologies', 'Crafted with modern Python backend standards, Test-Driven Development (TDD), and cross-platform Flutter tooling.'),
            const SizedBox(height: 40),
            Wrap(spacing: 16, runSpacing: 16, alignment: WrapAlignment.center, children: [
              _techCard('lib/photos/python.svg', 'Python 3.12', 'Core Engine'),
              _techCard('lib/photos/fastapi.svg', 'FastAPI', 'Async Framework'),
              _techCard('lib/photos/postgresql.svg', 'PostgreSQL', 'Supabase Database'),
              _techCard('lib/photos/sqlalchemy.svg', 'SQLAlchemy', 'Database ORM'),
              _techCard('lib/photos/flutter.svg', 'Flutter', 'Web & Mobile Client'),
              _techCard('lib/photos/docker.svg', 'Docker', 'Mock DB & Container'),
              _techCard('lib/photos/pytest.svg', 'Pytest (TDD)', 'Automated Tests'),
              _techCard('lib/photos/monkeytie.svg', 'OAuth2 / RBAC', 'Identity & Security'),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _techCard(String iconAssetPath, String title, String role) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(color: ChrononColors.navySurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: ChrononColors.navyBorder)),
      child: Column(children: [
        SvgPicture.asset(iconAssetPath, width: 26, height: 26, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(role, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: ChrononColors.cyanAccent)),
      ]),
    );
  }

  // =========================================================================
  // 4. Roadmap
  // =========================================================================
  Widget _buildRoadmap(BuildContext context) {
    return Container(
      key: _roadmapKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      color: const Color(0x40011C3B),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(children: [
            _sectionHeader('TEST-DRIVEN ROADMAP', 'Phases of Development', 'Rigorous progression from database architecture to public app store deployment.'),
            const SizedBox(height: 40),
            Wrap(spacing: 16, runSpacing: 16, children: [
              _roadmapCard('Phase 1 · Complete', 'Structure & Models', 'Database schema design, SQLAlchemy ORM mappings, base migrations, and Flutter web frontend connection.', ChrononColors.success),
              _roadmapCard('Phase 2 · Complete', 'RBAC & Security', 'Role-Based Access Control, personal student data encryption, User CRUD, and responsive schedule layout.', ChrononColors.success),
              _roadmapCard('Phase 3 · Active', 'Event Operations', 'Real-time operations on schedule mutations, automated conflict detection, calendar feeds, and end-to-end tests.', ChrononColors.cyanAccent, isActive: true),
              _roadmapCard('Phase 4 · Upcoming', 'Public Release', 'Final input security audits, endpoint locks, Google Play Alpha release, and campus pilot onboarding.', ChrononColors.textDim),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _roadmapCard(String badge, String title, String desc, Color badgeColor, {bool isActive = false}) {
    return SizedBox(
      width: 250,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isActive ? const Color(0x33024F86) : ChrononColors.navySurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isActive ? ChrononColors.cyanAccent : ChrononColors.navyBorder),
          boxShadow: isActive ? const [BoxShadow(color: Color(0x33048AC1), blurRadius: 16)] : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
            ),
            child: Text(badge, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor)),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 13, color: ChrononColors.textMuted, height: 1.4)),
        ]),
      ),
    );
  }

  // =========================================================================
  // 5. FAQ
  // =========================================================================
  Widget _buildFaq(BuildContext context) {
    return Container(
      key: _faqKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(children: [
            _sectionHeader('GOT QUESTIONS?', 'Frequently Asked Questions', 'Everything you need to know about Chronon timetable.'),
            const SizedBox(height: 40),
            _faqTile('Can I use Chronon when I don\'t have internet on campus?', 'Yes! Chronon features an offline-first caching layer. Your full timetable is preserved in local storage, allowing you to access schedules in basement lecture halls and subterranean auditoriums without dropping a beat.'),
            _faqTile('How does Chronon prevent schedule overlap conflicts?', 'The FastAPI backend runs validation algorithms on every event mutation. If a professor or room is already booked for a specific time slot, or if two mandatory group sessions collide, the mutation is flagged and rejected.'),
            _faqTile('Is Chronon open-source?', 'Yes, Chronon is fully open-source and hosted on GitHub. You can inspect the code, contribute features, or deploy an instance for your student council or university.'),
            _faqTile('What platforms are supported?', 'Chronon is built using Flutter for the client, compiling natively to Android, iOS, and modern desktop web browsers, powered by the high-performance FastAPI Python backend.'),
          ]),
        ),
      ),
    );
  }

  Widget _faqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(color: ChrononColors.navySurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: ChrononColors.navyBorder)),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
        iconColor: ChrononColors.cyanAccent,
        collapsedIconColor: ChrononColors.textMuted,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [Text(answer, style: const TextStyle(color: ChrononColors.textMuted, fontSize: 14, height: 1.5))],
      ),
    );
  }

  // =========================================================================
  // 6. CTA Banner
  // =========================================================================
  Widget _buildCtaBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [ChrononColors.navySurface, ChrononColors.navyBorder, ChrononColors.cobalt],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: ChrononColors.cyanAccent),
              boxShadow: const [BoxShadow(color: Color(0x40048AC1), blurRadius: 30)],
            ),
            child: Column(children: [
              const Text('Ready for a Human-Friendly Schedule?', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 14),
              const Text(
                'Experience clean, stress-free academic scheduling. Star the repository, check out the source code, or run a local instance.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFFE2E8F0)),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => redirectTo('https://github.com/LostyGuy/Uni-Schedule', newTab: true),
                icon: const Icon(Icons.star_rounded, color: Colors.amber),
                label: const Text('Star on GitHub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChrononColors.cobalt,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // Shared: Section Header
  // =========================================================================
  Widget _sectionHeader(String tag, String title, String subtitle) {
    return Column(children: [
      Text(tag, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: ChrononColors.cyanAccent, letterSpacing: 1.2)),
      const SizedBox(height: 8),
      Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
      const SizedBox(height: 12),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: ChrononColors.textMuted, height: 1.5)),
      ),
    ]);
  }
}
