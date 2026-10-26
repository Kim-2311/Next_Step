import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/app_components.dart';

class StudentSuccessScreen extends StatefulWidget {
  const StudentSuccessScreen({super.key});

  @override
  State<StudentSuccessScreen> createState() => _StudentSuccessScreenState();
}

class _StudentSuccessScreenState extends State<StudentSuccessScreen> {
  static const _tasks = [
    'Monday · Request your matric statement from your school',
    'Wednesday · Draft why you want to study your chosen course',
    'Friday · Check document rules with admissions',
  ];
  Set<String> _completed = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _completed =
          preferences
              .getStringList('${_userKey}studentSuccessTasks')
              ?.toSet() ??
          {};
      _loaded = true;
    });
  }

  Future<void> _toggleTask(String task, bool complete) async {
    final updated = {..._completed};
    if (complete) {
      updated.add(task);
    } else {
      updated.remove(task);
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      '${_userKey}studentSuccessTasks',
      updated.toList(),
    );
    if (mounted) setState(() => _completed = updated);
  }

  String get _userKey =>
      '${FirebaseAuth.instance.currentUser?.uid ?? 'device'}:';

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Small habits. Stronger next steps.',
    subtitle: 'Student Success · Practical support for study and applications.',
    children: [
      InfoPanel(
        color: const Color(0xFFE4F5F2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YOUR FOCUS THIS WEEK',
              style: TextStyle(
                color: Color(0xFF11857C),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _completed.length == _tasks.length
                  ? 'You completed your weekly plan.'
                  : 'Choose one useful next action.',
              style: const TextStyle(
                color: nextStepInk,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text('${_completed.length} of ${_tasks.length} tasks completed'),
          ],
        ),
      ),
      const SizedBox(height: 18),
      const Text(
        'A manageable weekly plan',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      if (!_loaded)
        const Center(child: CircularProgressIndicator())
      else
        ..._tasks.map(
          (task) => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(task),
            value: _completed.contains(task),
            onChanged: (value) => _toggleTask(task, value ?? false),
          ),
        ),
      const SizedBox(height: 12),
      const InfoPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BUILD A MOTIVATION LETTER',
              style: TextStyle(
                color: nextStepPurple,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Make it specific. Make it yours.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Explain why this programme interests you, share a real example of your effort, and check the word limit and spelling.',
              style: TextStyle(color: nextStepMuted, height: 1.5),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      const Text(
        'Build your study confidence',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      const _SupportTip(
        title: 'Practise, then check',
        body: 'Try a short exercise without notes, then review steps you missed.',
        icon: Icons.edit_note_rounded,
      ),
      const _SupportTip(
        title: 'Plan a focused session',
        body: 'Choose one topic, work for 25 minutes and take a short break.',
        icon: Icons.timer_outlined,
      ),
      const _SupportTip(
        title: 'Ask for help early',
        body:
            'Contact your school, library or institution’s student support office.',
        icon: Icons.chat_bubble_outline_rounded,
      ),
      const InfoPanel(
        child: Text(
          'You do not have to do this alone. Speak to someone you trust or a qualified counsellor if you feel overwhelmed.',
          style: TextStyle(color: nextStepMuted, height: 1.5),
        ),
      ),
    ],
  );
}

class _SupportTip extends StatelessWidget {
  const _SupportTip({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: nextStepPurple),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text(body),
  );
}