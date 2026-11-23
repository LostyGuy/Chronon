import 'package:flutter/material.dart';

import 'package:chronon/v1/Shared/chronon_colors.dart';

// ---------------------------------------------------------------------------
// Model
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
// Interactive Timetable Demo Widget
// ---------------------------------------------------------------------------
class InteractiveTimetableDemo extends StatefulWidget {
  const InteractiveTimetableDemo({super.key});

  @override
  State<InteractiveTimetableDemo> createState() => _InteractiveTimetableDemoState();
}

class _InteractiveTimetableDemoState extends State<InteractiveTimetableDemo> {
  String _selectedDay = 'Tue';
  String _selectedFilter = 'all';

  // Sample timetable data
  final List<ScheduleItem> _allItems = const [
    ScheduleItem(id: 1, day: 'Mon', type: 'lecture', start: '08:30', end: '10:00', subject: 'Discrete Mathematics', room: 'Hall A-102', teacher: 'Dr. Nowak'),
    ScheduleItem(id: 2, day: 'Mon', type: 'lab', start: '10:15', end: '11:45', subject: 'Computer Networks Lab', room: 'Lab 204', teacher: 'Prof. Kowalski'),
    ScheduleItem(id: 3, day: 'Mon', type: 'seminar', start: '12:30', end: '14:00', subject: 'Academic English & Writing', room: 'Room 110', teacher: 'Mgr. Smith'),
    ScheduleItem(id: 4, day: 'Tue', type: 'lecture', start: '09:00', end: '10:30', subject: 'Database Systems & SQL', room: 'Auditorium Magna', teacher: 'Prof. Miller'),
    ScheduleItem(id: 5, day: 'Tue', type: 'lab', start: '10:45', end: '12:15', subject: 'Distributed Systems & Cloud', room: 'Lab 304B', teacher: 'Dr. Wisniewski', isCurrent: true),
    ScheduleItem(id: 6, day: 'Tue', type: 'lecture', start: '13:00', end: '14:30', subject: 'Algorithms & Complexity', room: 'Hall B-201', teacher: 'Prof. Adams'),
    ScheduleItem(id: 7, day: 'Wed', type: 'seminar', start: '10:00', end: '11:30', subject: 'Software Architecture Patterns', room: 'Room 405', teacher: 'Dr. Green'),
    ScheduleItem(id: 8, day: 'Wed', type: 'lab', start: '12:00', end: '13:30', subject: 'Operating Systems Kernel Lab', room: 'Lab 102', teacher: 'Ing. Brown'),
    ScheduleItem(id: 9, day: 'Wed', type: 'lecture', start: '14:00', end: '15:30', subject: 'Cybersecurity Fundamentals', room: 'Auditorium C', teacher: 'Dr. Clark'),
    ScheduleItem(id: 10, day: 'Thu', type: 'lecture', start: '08:30', end: '10:00', subject: 'Object-Oriented Programming', room: 'Auditorium B', teacher: 'Dr. Scott'),
    ScheduleItem(id: 11, day: 'Thu', type: 'lab', start: '10:15', end: '11:45', subject: 'Mobile App Development Lab', room: 'Lab 301', teacher: 'Mgr. Evans'),
    ScheduleItem(id: 12, day: 'Fri', type: 'seminar', start: '09:00', end: '10:30', subject: 'Engineering Ethics & Law', room: 'Room 205', teacher: 'Dr. Taylor'),
    ScheduleItem(id: 13, day: 'Fri', type: 'lab', start: '11:00', end: '13:00', subject: 'Team Project Consultation', room: 'Innovation Lab', teacher: 'Prof. Miller'),
  ];

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_outline, color: ChrononColors.cyanAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
        ]),
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 860;
    final dayClasses = _allItems.where((item) => item.day == _selectedDay).toList();
    final filteredClasses = dayClasses.where((item) {
      if (_selectedFilter == 'all') return true;
      return item.type == _selectedFilter;
    }).toList();
    final currentClass = dayClasses.firstWhere((c) => c.isCurrent, orElse: () => dayClasses.first);

    return Container(
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
                BoxShadow(color: Color(0x66000000), blurRadius: 30, offset: Offset(0, 15)),
                BoxShadow(color: Color(0x33048AC1), blurRadius: 20),
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    border: Border(bottom: BorderSide(color: ChrononColors.navyBorder)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        _windowDot(const Color(0xFFFF5F56)),
                        const SizedBox(width: 8),
                        _windowDot(const Color(0xFFFFBD2E)),
                        const SizedBox(width: 8),
                        _windowDot(const Color(0xFF27C93F)),
                      ]),
                      const Text('chronon.com.pl/v1/schedule/student_view', style: TextStyle(fontSize: 13, fontFamily: 'monospace', color: ChrononColors.textMuted)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: ChrononColors.cobalt, borderRadius: BorderRadius.circular(6)),
                        child: const Text('Interactive Widget*', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ),

                // App Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 280, child: _buildSidebar(dayClasses, currentClass)),
                            const SizedBox(width: 24),
                            Expanded(child: _buildScheduleList(filteredClasses)),
                          ],
                        )
                      : Column(children: [
                          _buildSidebar(dayClasses, currentClass),
                          const SizedBox(height: 24),
                          _buildScheduleList(filteredClasses),
                        ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Sub-widgets ───────────────────────────────────────────────────────────

  Widget _windowDot(Color color) => Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle));

  Widget _buildSidebar(List<ScheduleItem> dayClasses, ScheduleItem currentClass) {
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
          Row(children: [
            Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [ChrononColors.cobalt, ChrononColors.cyanAccent]), shape: BoxShape.circle),
              child: const Center(child: Text('MG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            ),
            const SizedBox(width: 12),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Maksym G.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
              Text('CS · Year 3', style: TextStyle(color: ChrononColors.cyanAccent, fontSize: 12)),
            ]),
          ]),
          const Divider(color: ChrononColors.navyBorder, height: 28),

          // Day Selector
          const Text('SELECT DAY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ChrononColors.textDim, letterSpacing: 0.8)),
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
                        border: Border.all(color: isSelected ? ChrononColors.cyanAccent : Colors.transparent),
                      ),
                      child: Text(day, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : ChrononColors.textMuted)),
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
            decoration: BoxDecoration(color: const Color(0x4001305A), borderRadius: BorderRadius.circular(10), border: Border.all(color: ChrononColors.navyBorder)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('DAY OVERVIEW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ChrononColors.textDim)),
              const SizedBox(height: 8),
              _quickStatRow('Total Classes', '${dayClasses.length} Subjects'),
              _quickStatRow('Total Hours', '4.5 hrs'),
              _quickStatRow('Status', 'On Track', color: ChrononColors.success),
            ]),
          ),
          const SizedBox(height: 14),

          // Current / Next
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0x4001305A), borderRadius: BorderRadius.circular(10), border: Border.all(color: ChrononColors.navyBorder)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('CURRENT / NEXT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ChrononColors.textDim)),
              const SizedBox(height: 6),
              Text(currentClass.subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
              const SizedBox(height: 2),
              Text('${currentClass.room} · ${currentClass.start}', style: const TextStyle(color: ChrononColors.cyanAccent, fontSize: 12)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _quickStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: ChrononColors.textMuted)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color ?? Colors.white)),
      ]),
    );
  }

  Widget _buildScheduleList(List<ScheduleItem> classes) {
    const fullDays = {'Mon': 'Monday', 'Tue': 'Tuesday', 'Wed': 'Wednesday', 'Thu': 'Thursday', 'Fri': 'Friday'};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12, runSpacing: 10,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text("${fullDays[_selectedDay]}'s Schedule", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0x33048AC1), border: Border.all(color: ChrononColors.cyanAccent), borderRadius: BorderRadius.circular(20)),
                child: const Text('Live Sync', style: TextStyle(fontSize: 11, color: ChrononColors.cyanAccent, fontWeight: FontWeight.bold)),
              ),
            ]),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: ChrononColors.abyss, borderRadius: BorderRadius.circular(10), border: Border.all(color: ChrononColors.navyBorder)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                _filterButton('all', 'All'),
                _filterButton('lecture', 'Lectures'),
                _filterButton('lab', 'Labs'),
                _filterButton('seminar', 'Seminars'),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (classes.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: ChrononColors.abyss.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: ChrononColors.navyBorder)),
            child: Text('No $_selectedFilter items scheduled for this day.', style: const TextStyle(color: ChrononColors.textDim)),
          )
        else
          Column(children: classes.map((item) => _buildScheduleCard(item)).toList()),
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
        decoration: BoxDecoration(color: isSelected ? ChrononColors.cobalt : Colors.transparent, borderRadius: BorderRadius.circular(6)),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : ChrononColors.textMuted)),
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
              border: Border.all(color: item.isCurrent ? ChrononColors.cyanAccent : ChrononColors.navyBorder, width: item.isCurrent ? 1.5 : 1),
            ),
            child: Row(children: [
              SizedBox(width: 90, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.start, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'monospace')),
                Text('until ${item.end}', style: const TextStyle(fontSize: 11, color: ChrononColors.textDim, fontFamily: 'monospace')),
              ])),
              const SizedBox(width: 12),
              Container(width: 3, height: 38, decoration: BoxDecoration(color: item.isCurrent ? ChrononColors.cyanAccent : ChrononColors.cobalt, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.subject, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: ChrononColors.cyanAccent),
                  const SizedBox(width: 4),
                  Text(item.room, style: const TextStyle(fontSize: 12, color: ChrononColors.textMuted)),
                  const SizedBox(width: 16),
                  const Icon(Icons.person_outline, size: 14, color: ChrononColors.textMuted),
                  const SizedBox(width: 4),
                  Text(item.teacher, style: const TextStyle(fontSize: 12, color: ChrononColors.textMuted)),
                ]),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.isCurrent ? const Color(0x33048AC1) : const Color(0x3301305A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: item.isCurrent ? ChrononColors.cyanAccent : ChrononColors.navyBorder),
                ),
                child: Text(
                  item.isCurrent ? 'In Progress' : item.type.toUpperCase(),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: item.isCurrent ? ChrononColors.cyanAccent : ChrononColors.textMuted),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
