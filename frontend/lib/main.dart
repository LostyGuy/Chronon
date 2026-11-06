import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni_schedule/entrolment.dart';
import 'package:uni_schedule/chronon_colors.dart';


void main() {
  runApp(const ChrononApp());
}

// ---------------------------------------------------------------------------
// App Root
// ---------------------------------------------------------------------------
class ChrononApp extends StatelessWidget {
  const ChrononApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ChrononColors.abyss,
        colorScheme: const ColorScheme.dark(
          primary: ChrononColors.cyanAccent,
          secondary: ChrononColors.cobalt,
          surface: ChrononColors.navySurface,
        ),
        fontFamily: 'Segoe UI',
        useMaterial3: true,
      ),
      home: const ChrononLandingPage(),
    );
  }
}

// ---------------------------------------------------------------------------
// Model for Interactive Schedule
// ---------------------------------------------------------------------------
class ScheduleItem {
  final int id;
  final String day;
  final String type; // 'lecture', 'lab', 'seminar'
  final String start;
  final String end;
  final String subject;
  final String room;
  final String teacher;
  final bool isCurrent;

  const ScheduleItem({
    required this.id,
    required this.day,
    required this.type,
    required this.start,
    required this.end,
    required this.subject,
    required this.room,
    required this.teacher,
    this.isCurrent = false,
  });
}

// ---------------------------------------------------------------------------
// Main Landing Page
// ---------------------------------------------------------------------------
class ChrononLandingPage extends StatefulWidget {
  const ChrononLandingPage({super.key});

  @override
  State<ChrononLandingPage> createState() => _ChrononLandingPageState();
}

class _ChrononLandingPageState extends State<ChrononLandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _demoKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _originKey = GlobalKey();
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _roadmapKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();

  String _selectedDay = 'Tue';
  String _selectedFilter = 'all';

  final List<ScheduleItem> _allItems = const [
    ScheduleItem(
      id: 1,
      day: 'Mon',
      type: 'lecture',
      start: '08:30',
      end: '10:00',
      subject: 'Discrete Mathematics',
      room: 'Hall A-102',
      teacher: 'Dr. Nowak',
    ),
    ScheduleItem(
      id: 2,
      day: 'Mon',
      type: 'lab',
      start: '10:15',
      end: '11:45',
      subject: 'Computer Networks Lab',
      room: 'Lab 204',
      teacher: 'Prof. Kowalski',
    ),
    ScheduleItem(
      id: 3,
      day: 'Mon',
      type: 'seminar',
      start: '12:30',
      end: '14:00',
      subject: 'Academic English & Writing',
      room: 'Room 110',
      teacher: 'Mgr. Smith',
    ),
    ScheduleItem(
      id: 4,
      day: 'Tue',
      type: 'lecture',
      start: '09:00',
      end: '10:30',
      subject: 'Database Systems & SQL',
      room: 'Auditorium Magna',
      teacher: 'Prof. Miller',
    ),
    ScheduleItem(
      id: 5,
      day: 'Tue',
      type: 'lab',
      start: '10:45',
      end: '12:15',
      subject: 'Distributed Systems & Cloud',
      room: 'Lab 304B',
      teacher: 'Dr. Wisniewski',
      isCurrent: true,
    ),
    ScheduleItem(
      id: 6,
      day: 'Tue',
      type: 'lecture',
      start: '13:00',
      end: '14:30',
      subject: 'Algorithms & Complexity',
      room: 'Hall B-201',
      teacher: 'Prof. Adams',
    ),
    ScheduleItem(
      id: 7,
      day: 'Wed',
      type: 'seminar',
      start: '10:00',
      end: '11:30',
      subject: 'Software Architecture Patterns',
      room: 'Room 405',
      teacher: 'Dr. Green',
    ),
    ScheduleItem(
      id: 8,
      day: 'Wed',
      type: 'lab',
      start: '12:00',
      end: '13:30',
      subject: 'Operating Systems Kernel Lab',
      room: 'Lab 102',
      teacher: 'Ing. Brown',
    ),
    ScheduleItem(
      id: 9,
      day: 'Wed',
      type: 'lecture',
      start: '14:00',
      end: '15:30',
      subject: 'Cybersecurity Fundamentals',
      room: 'Auditorium C',
      teacher: 'Dr. Clark',
    ),
    ScheduleItem(
      id: 10,
      day: 'Thu',
      type: 'lecture',
      start: '08:30',
      end: '10:00',
      subject: 'Object-Oriented Programming',
      room: 'Auditorium B',
      teacher: 'Dr. Scott',
    ),
    ScheduleItem(
      id: 11,
      day: 'Thu',
      type: 'lab',
      start: '10:15',
      end: '11:45',
      subject: 'Mobile App Development Lab',
      room: 'Lab 301',
      teacher: 'Mgr. Evans',
    ),
    ScheduleItem(
      id: 12,
      day: 'Fri',
      type: 'seminar',
      start: '09:00',
      end: '10:30',
      subject: 'Engineering Ethics & Law',
      room: 'Room 205',
      teacher: 'Dr. Taylor',
    ),
    ScheduleItem(
      id: 13,
      day: 'Fri',
      type: 'lab',
      start: '11:00',
      end: '13:00',
      subject: 'Team Project Consultation',
      room: 'Innovation Lab',
      teacher: 'Prof. Miller',
    ),
  ];

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

  void _showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: ChrononColors.cyanAccent, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          ],
        ),
        backgroundColor: ChrononColors.navySurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: ChrononColors.cyanAccent, width: 1),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _copyCloneCommand() {
    const cmd = 'git clone https://github.com/LostyGuy/Uni-Schedule.git';
    Clipboard.setData(const ClipboardData(text: cmd));
    _showToast('Copied to clipboard: $cmd');
  }

  void redirectTo(String url, {bool newTab = false}) {
    if (newTab) {
      web.window.open(url, '_blank');
    } else {
      web.window.location.href = url;
    }
  }

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
                  colors: [
                    Color(0x33024F86),
                    Color(0x1A01305A),
                    ChrononColors.abyss,
                  ],
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
                  colors: [
                    Color(0x26048AC1),
                    Colors.transparent,
                  ],
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
                  _buildHeader(context),
                  _buildHero(context),
                  _buildTimetableDemo(context),
                  _asterisk(context),
                  // _buildOriginComparison(context),
                  _buildFeatures(context),
                  _buildTechStack(context),
                  _buildRoadmap(context),
                  _buildFaq(context),
                  _buildCtaBanner(context),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Navigation Header
  // ---------------------------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
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
              // Brand Logo
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

              // Navigation Links (Desktop)
              if (isDesktop)
                Row(
                  children: [
                    _navButton('Features', () => _scrollToKey(_featuresKey)),
                    _navButton('Live Timetable', () => _scrollToKey(_demoKey)),
                    _navButton('The Origin', () => _scrollToKey(_originKey)),
                    _navButton('Architecture', () => _scrollToKey(_stackKey)),
                    _navButton('Roadmap', () => _scrollToKey(_roadmapKey)),
                    _navButton('FAQ', () => _scrollToKey(_faqKey)),
                  ],
                ),

              // Action Buttons
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => redirectTo('https://github.com/LostyGuy/Chronon', newTab: true),
                    icon: const Icon(Icons.code_rounded, size: 18, color: ChrononColors.cyanAccent),
                    label: const Text('GitHub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ChrononColors.navyBorder),
                      backgroundColor: ChrononColors.navySurface,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _scrollToKey(_demoKey),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: ChrononColors.textMuted,
        padding: const EdgeInsets.symmetric(horizontal: 14),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Hero Section
  // ---------------------------------------------------------------------------
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
                  boxShadow: const [
                    BoxShadow(color: Color(0x22048AC1), blurRadius: 10),
                  ],
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
                        boxShadow: [
                          BoxShadow(color: ChrononColors.cyanAccent, blurRadius: 6),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Phase 3: Real-Time Event Processing & Alpha Pipeline',
                      style: TextStyle(
                        color: ChrononColors.cyanAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
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
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const EntrolmentPage(),
    ),
  );
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
                  border: Border(
                    top: BorderSide(color: Color(0x4001305A), width: 1),
                  ),
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
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: ChrononColors.textDim,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Interactive Timetable Demo Widget
  // ---------------------------------------------------------------------------
  Widget _buildTimetableDemo(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 860;
    final dayClasses = _allItems.where((item) => item.day == _selectedDay).toList();
    final filteredClasses = dayClasses.where((item) {
      if (_selectedFilter == 'all') return true;
      return item.type == _selectedFilter;
    }).toList();

    final currentClass = dayClasses.firstWhere((c) => c.isCurrent, orElse: () => dayClasses.first);

    return Container(
      key: _demoKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Container(
            decoration: BoxDecoration(
              color: ChrononColors.navySurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ChrononColors.navyBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
                BoxShadow(
                  color: Color(0x33048AC1),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Window Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                    color: ChrononColors.abyss,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border(
                      bottom: BorderSide(color: ChrononColors.navyBorder),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _windowDot(const Color(0xFFFF5F56)),
                          const SizedBox(width: 8),
                          _windowDot(const Color(0xFFFFBD2E)),
                          const SizedBox(width: 8),
                          _windowDot(const Color(0xFF27C93F)),
                        ],
                      ),
                      const Text(
                        'chronon.com.pl/v1/schedule/student_view',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'monospace',
                          color: ChrononColors.textMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ChrononColors.cobalt,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Interactive Widget*',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // App Inside Container
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 280,
                              child: _buildDemoSidebar(dayClasses, currentClass),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildDemoScheduleList(filteredClasses),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildDemoSidebar(dayClasses, currentClass),
                            const SizedBox(height: 24),
                            _buildDemoScheduleList(filteredClasses),
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

  Widget _windowDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildDemoSidebar(List<ScheduleItem> dayClasses, ScheduleItem currentClass) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ChrononColors.abyss.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ChrononColors.navyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ChrononColors.cobalt, ChrononColors.cyanAccent],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('MG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Maksym G.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  Text('CS · Year 3', style: TextStyle(color: ChrononColors.cyanAccent, fontSize: 12)),
                ],
              ),
            ],
          ),
          const Divider(color: ChrononColors.navyBorder, height: 28),

          // Day Selector
          const Text(
            'SELECT DAY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ChrononColors.textDim,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'].map((day) {
              final isSelected = day == _selectedDay;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    onTap: () => setState(() => _selectedDay = day),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? ChrononColors.cobalt : const Color(0x3301305A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? ChrononColors.cyanAccent : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : ChrononColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Quick Stats
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0x4001305A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ChrononColors.navyBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DAY OVERVIEW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ChrononColors.textDim)),
                const SizedBox(height: 8),
                _quickStatRow('Total Classes', '${dayClasses.length} Subjects'),
                _quickStatRow('Total Hours', '4.5 hrs'),
                _quickStatRow('Status', 'On Track', color: ChrononColors.success),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Next Up Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0x4001305A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ChrononColors.navyBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CURRENT / NEXT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ChrononColors.textDim)),
                const SizedBox(height: 6),
                Text(
                  currentClass.subject,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  '${currentClass.room} · ${currentClass.start}',
                  style: const TextStyle(color: ChrononColors.cyanAccent, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: ChrononColors.textMuted)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color ?? Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDemoScheduleList(List<ScheduleItem> classes) {
    const fullDays = {'Mon': 'Monday', 'Tue': 'Tuesday', 'Wed': 'Wednesday', 'Thu': 'Thursday', 'Fri': 'Friday'};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toolbar
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${fullDays[_selectedDay]}'s Schedule",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0x33048AC1),
                    border: Border.all(color: ChrononColors.cyanAccent),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Live Sync', style: TextStyle(fontSize: 11, color: ChrononColors.cyanAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            // Filter Chips
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: ChrononColors.abyss,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ChrononColors.navyBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _filterButton('all', 'All'),
                  _filterButton('lecture', 'Lectures'),
                  _filterButton('lab', 'Labs'),
                  _filterButton('seminar', 'Seminars'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Classes Stack
        if (classes.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ChrononColors.abyss.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ChrononColors.navyBorder),
            ),
            child: Text(
              'No $_selectedFilter items scheduled for this day.',
              style: const TextStyle(color: ChrononColors.textDim),
            ),
          )
        else
          Column(
            children: classes.map((item) => _buildScheduleCard(item)).toList(),
          ),
      ],
    );
  }

  Widget _filterButton(String key, String label) {
    final isSelected = _selectedFilter == key;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = key),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? ChrononColors.cobalt : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : ChrononColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showToast('Selected: ${item.subject} (${item.room}) at ${item.start}'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.isCurrent ? const Color(0x40024F86) : const Color(0x3301305A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: item.isCurrent ? ChrononColors.cyanAccent : ChrononColors.navyBorder,
                width: item.isCurrent ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Time Column
                SizedBox(
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.start,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        'until ${item.end}',
                        style: const TextStyle(fontSize: 11, color: ChrononColors.textDim, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Accent Line
                Container(
                  width: 3,
                  height: 38,
                  decoration: BoxDecoration(
                    color: item.isCurrent ? ChrononColors.cyanAccent : ChrononColors.cobalt,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.subject,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: ChrononColors.cyanAccent),
                          const SizedBox(width: 4),
                          Text(item.room, style: const TextStyle(fontSize: 12, color: ChrononColors.textMuted)),
                          const SizedBox(width: 16),
                          const Icon(Icons.person_outline, size: 14, color: ChrononColors.textMuted),
                          const SizedBox(width: 4),
                          Text(item.teacher, style: const TextStyle(fontSize: 12, color: ChrononColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.isCurrent ? const Color(0x33048AC1) : const Color(0x3301305A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: item.isCurrent ? ChrononColors.cyanAccent : ChrononColors.navyBorder,
                    ),
                  ),
                  child: Text(
                    item.isCurrent ? 'In Progress' : item.type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: item.isCurrent ? ChrononColors.cyanAccent : ChrononColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            
          ),
          
        ),
      ),
    );
  }

  Widget _asterisk(BuildContext context) {
    return Center(
        child:
          Text("* - Subject to change")
      );
  }

  // ---------------------------------------------------------------------------
  // 4. The Origin Story (Pain vs. Solution)
  // ---------------------------------------------------------------------------
  // Widget _buildOriginComparison(BuildContext context) {
  //   final isDesktop = MediaQuery.of(context).size.width > 800;

  //   return Container(
  //     key: _originKey,
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
  //     child: Center(
  //       child: ConstrainedBox(
  //         constraints: const BoxConstraints(maxWidth: 1100),
  //         child: Column(
  //           children: [
  //             _sectionHeader(
  //               'WHY WE BUILT CHRONON',
  //               'The Pain of University Timetables',
  //               'College schedules were an absolute eyesore. One was made in MS Paint, another in Excel '
  //               'with vertical columns so cramped students literally used a physical ruler on their screens.',
  //             ),
  //             const SizedBox(height: 48),

  //             isDesktop
  //                 ? Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Expanded(child: _buildBadCard()),
  //                       const SizedBox(width: 24),
  //                       Expanded(child: _buildGoodCard()),
  //                     ],
  //                   )
  //                 : Column(
  //                     children: [
  //                       _buildBadCard(),
  //                       const SizedBox(height: 24),
  //                       _buildGoodCard(),
  //                     ],
  //                   ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildBadCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(30),
  //     decoration: BoxDecoration(
  //       color: const Color(0x1ADC2626),
  //       borderRadius: BorderRadius.circular(18),
  //       border: Border.all(color: const Color(0x55EF4444)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Row(
  //           children: [
  //             Icon(Icons.cancel_outlined, color: ChrononColors.alert, size: 24),
  //             SizedBox(width: 10),
  //             Text('The Evil Spreadsheets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFCA5A5))),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         const Text('The nightmare every university student has suffered through:', style: TextStyle(color: Color(0xFFFCA5A5), fontSize: 14)),
  //         const SizedBox(height: 20),
  //         _bulletPoint(Icons.close, 'Ruler Required: Microscopic rows that force you to trace your finger across the monitor.', ChrononColors.alert),
  //         _bulletPoint(Icons.close, 'Zero Real-time Updates: When a room changes, you only find out after knocking on an empty hall.', ChrononColors.alert),
  //         _bulletPoint(Icons.close, 'Horrible on Mobile: Pinching and zooming on blurry JPEG screenshots downloaded from chats.', ChrononColors.alert),
  //         _bulletPoint(Icons.close, 'No Conflict Detection: Accidental lecture collisions left undetected until exam week.', ChrononColors.alert),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildGoodCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(30),
  //     decoration: BoxDecoration(
  //       color: const Color(0x22024F86),
  //       borderRadius: BorderRadius.circular(18),
  //       border: Border.all(color: ChrononColors.cyanAccent),
  //       boxShadow: const [
  //         BoxShadow(color: Color(0x26048AC1), blurRadius: 24),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Row(
  //           children: [
  //             Icon(Icons.check_circle_outline, color: ChrononColors.cyanAccent, size: 24),
  //             SizedBox(width: 10),
  //             Text('The Chronon Solution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7DD3FC))),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         const Text('Designed for human eyes and high-speed campus routines:', style: TextStyle(color: Color(0xFF7DD3FC), fontSize: 14)),
  //         const SizedBox(height: 20),
  //         _bulletPoint(Icons.check, 'Glanceable Cards: Time, room, professor, and subject in bold high-contrast typography.', ChrononColors.cyanAccent),
  //         _bulletPoint(Icons.check, 'Instant Cloud Sync: Sub-second timetable broadcast via FastAPI & Supabase.', ChrononColors.cyanAccent),
  //         _bulletPoint(Icons.check, 'Offline Architecture: Intelligent local caching means schedule works in bunker basements.', ChrononColors.cyanAccent),
  //         _bulletPoint(Icons.check, 'Role-Based Access: Admin controls for schedule directors, clean views for students.', ChrononColors.cyanAccent),
  //       ],
  //     ),
  //   );
  // }

  // Widget _bulletPoint(IconData icon, String text, Color iconColor) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 14),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Icon(icon, size: 18, color: iconColor),
  //         const SizedBox(width: 10),
  //         Expanded(
  //           child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.4)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ---------------------------------------------------------------------------
  // 5. Features Grid
  // ---------------------------------------------------------------------------
  Widget _buildFeatures(BuildContext context) {
    return Container(
      key: _featuresKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      color: const Color(0x40011C3B),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _sectionHeader(
                'KEY CAPABILITIES',
                'Engineered for Academic Precision',
                'Everything you need to master your university timetable with zero cognitive friction.',
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _featureCard(Icons.view_timeline_outlined, 'Dynamic Visual Timeline', 'Chronological daily breakdown with remaining time indicators, current class highlights, and prominent room numbers.'),
                  _featureCard(Icons.security_outlined, 'RBAC Security & Privacy', 'Role-Based Access Control protecting student data and allowing only verified academic staff to publish modifications.'),
                  _featureCard(Icons.bolt_outlined, 'FastAPI & Supabase Backbone', 'Blazing asynchronous Python 3.12 endpoints combined with PostgreSQL and SQLAlchemy ORM for instant query responses.'),
                  _featureCard(Icons.cloud_sync_outlined, 'Local + Cloud Double Cache', 'Minimizes database overload while slashing wait times. Offline local storage keeps your schedule accessible without internet.'),
                  _featureCard(Icons.notification_important_outlined, 'Conflict & Overlap Detection', 'Automated schedule validation flags collision between concurrent lectures, double-booked professors, or room clashes.'),
                  _featureCard(Icons.devices_outlined, 'Cross-Platform Flutter UI', 'Unified native experience across Mobile (Android & iOS) and Progressive Web Apps with smooth 60fps interaction.'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String desc) {
    return SizedBox(
      width: 340,
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: ChrononColors.navySurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ChrononColors.navyBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Tech Stack Showcase
  // ---------------------------------------------------------------------------
  Widget _buildTechStack(BuildContext context) {
    return Container(
      key: _stackKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _sectionHeader(
                'UNDER THE HOOD',
                'Built with Battle-Tested Technologies',
                'Crafted with modern Python backend standards, Test-Driven Development (TDD), and cross-platform Flutter tooling.',
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _techCard('lib/photos/python.svg', 'Python 3.12', 'Core Engine'),
                  _techCard('lib/photos/fastapi.svg', 'FastAPI', 'Async Framework'),
                  _techCard('lib/photos/postgresql.svg', 'PostgreSQL', 'Supabase Database'),
                  _techCard('lib/photos/sqlalchemy.svg', 'SQLAlchemy', 'Database ORM'),
                  _techCard('lib/photos/flutter.svg', 'Flutter', 'Web & Mobile Client'),
                  _techCard('lib/photos/docker.svg', 'Docker', 'Mock DB & Container'),
                  _techCard('lib/photos/pytest.svg', 'Pytest (TDD)', 'Automated Tests'),
                  _techCard('lib/photos/monkeytie.svg', 'OAuth2 / RBAC', 'Identity & Security'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _techCard(String iconAssetPath, String title, String role) {
  return Container(
    width: 150,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    decoration: BoxDecoration(
      color: ChrononColors.navySurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: ChrononColors.navyBorder),
    ),
    child: Column(
      children: [
        SvgPicture.asset(
        iconAssetPath,
        width: 26,
        height: 26,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          role,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: ChrononColors.cyanAccent,
          ),
        ),
      ],
    ),
  );
}

  // ---------------------------------------------------------------------------
  // 7. Roadmap
  // ---------------------------------------------------------------------------
  Widget _buildRoadmap(BuildContext context) {
    return Container(
      key: _roadmapKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      color: const Color(0x40011C3B),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _sectionHeader(
                'TEST-DRIVEN ROADMAP',
                'Phases of Development',
                'Rigorous progression from database architecture to public app store deployment.',
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _roadmapCard('Phase 1 · Complete', 'Structure & Models', 'Database schema design, SQLAlchemy ORM mappings, base migrations, and Flutter web frontend connection.', ChrononColors.success),
                  _roadmapCard('Phase 2 · Complete', 'RBAC & Security', 'Role-Based Access Control, personal student data encryption, User CRUD, and responsive schedule layout.', ChrononColors.success),
                  _roadmapCard('Phase 3 · Active', 'Event Operations', 'Real-time operations on schedule mutations, automated conflict detection, calendar feeds, and end-to-end tests.', ChrononColors.cyanAccent, isActive: true),
                  _roadmapCard('Phase 4 · Upcoming', 'Public Release', 'Final input security audits, endpoint locks, Google Play Alpha release, and campus pilot onboarding.', ChrononColors.textDim),
                ],
              ),
            ],
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 8. FAQ
  // ---------------------------------------------------------------------------
  Widget _buildFaq(BuildContext context) {
    return Container(
      key: _faqKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              _sectionHeader(
                'GOT QUESTIONS?',
                'Frequently Asked Questions',
                'Everything you need to know about Chronon timetable.',
              ),
              const SizedBox(height: 40),
              _faqTile('Can I use Chronon when I don\'t have internet on campus?', 'Yes! Chronon features an offline-first caching layer. Your full timetable is preserved in local storage, allowing you to access schedules in basement lecture halls and subterranean auditoriums without dropping a beat.'),
              _faqTile('How does Chronon prevent schedule overlap conflicts?', 'The FastAPI backend runs validation algorithms on every event mutation. If a professor or room is already booked for a specific time slot, or if two mandatory group sessions collide, the mutation is flagged and rejected.'),
              _faqTile('Is Chronon open-source?', 'Yes, Chronon is fully open-source and hosted on GitHub. You can inspect the code, contribute features, or deploy an instance for your student council or university.'),
              _faqTile('What platforms are supported?', 'Chronon is built using Flutter for the client, compiling natively to Android, iOS, and modern desktop web browsers, powered by the high-performance FastAPI Python backend.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _faqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: ChrononColors.navySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ChrononColors.navyBorder),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
        iconColor: ChrononColors.cyanAccent,
        collapsedIconColor: ChrononColors.textMuted,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(answer, style: const TextStyle(color: ChrononColors.textMuted, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 9. CTA Banner
  // ---------------------------------------------------------------------------
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
              boxShadow: const [
                BoxShadow(color: Color(0x40048AC1), blurRadius: 30),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Ready for a Human-Friendly Schedule?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Experience clean, stress-free academic scheduling. Star the repository, check out the source code, or run a local instance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFFE2E8F0)),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
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
                    // OutlinedButton.icon(
                    //   onPressed: _copyCloneCommand,
                    //   icon: const Icon(Icons.copy_rounded, size: 18, color: ChrononColors.cyanAccent),
                    //   label: const Text(
                    //     'git clone https://github.com/LostyGuy/Uni-Schedule.git',
                    //     style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.white),
                    //   ),
                    //   style: OutlinedButton.styleFrom(
                    //     backgroundColor: ChrononColors.abyss.withOpacity(0.7),
                    //     side: const BorderSide(color: ChrononColors.navyBorder),
                    //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 10. Footer
  // ---------------------------------------------------------------------------
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: const BoxDecoration(
        color: ChrononColors.abyss,
        border: Border(top: BorderSide(color: ChrononColors.navyBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [ChrononColors.cyanAccent, ChrononColors.cobalt]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text('Chronon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                    ],
                  ),
                  const Text('© 2026 Chronon (Uni-Schedule). Maksym Knasiecki (LostyGuy). Open-source.', style: TextStyle(color: ChrononColors.textDim, fontSize: 13)),
                  const Text('lostyguycontacts@gmail.com <- contact me', style: TextStyle(color: ChrononColors.textDim, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 24),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text('Palette: ', style: TextStyle(color: ChrononColors.textDim, fontSize: 12)),
              //     const SizedBox(width: 6),
              //     _swatch(ChrononColors.abyss, '#010C22'),
              //     _swatch(ChrononColors.navySurface, '#011C3B'),
              //     _swatch(ChrononColors.navyBorder, '#01305A'),
              //     _swatch(ChrononColors.cobalt, '#024F86'),
              //     _swatch(ChrononColors.cyanAccent, '#048AC1'),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _swatch(Color color, String tooltip) {
  //   return Tooltip(
  //     message: tooltip,
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 3),
  //       width: 14,
  //       height: 14,
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.circular(3),
  //         border: Border.all(color: Colors.white24),
  //       ),
  //     ),
  //   );
  // }

  Widget _sectionHeader(String tag, String title, String subtitle) {
    return Column(
      children: [
        Text(
          tag,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: ChrononColors.cyanAccent,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: ChrononColors.textMuted, height: 1.5),
          ),
        ),
      ],
    );
  }
}
