import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/student_profile.dart';
import '../../widgets/app_components.dart';
import 'interests_screen.dart';

class ProfileResultsScreen extends StatefulWidget {
  const ProfileResultsScreen({
    super.key,
    this.profile = const StudentProfile(),
  });

  final StudentProfile profile;

  @override
  State<ProfileResultsScreen> createState() => _ProfileResultsScreenState();
}

class _ProfileResultsScreenState extends State<ProfileResultsScreen> {
  static const _subjectOptions = [
    'English HL',
    'isiZulu HL',
    'Mathematics',
    'Mathematical Literacy',
    'Physical Sciences',
    'Life Sciences',
    'Geography',
    'History',
    'Accounting',
    'Business Studies',
    'Economics',
    'Life Orientation',
    'Other',
  ];

  late final List<_SubjectResult> _subjects = widget.profile.matricSubjects
      .entries
      .map((entry) => _SubjectResult(entry.key, entry.value))
      .toList();
  bool _consentShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestConsent());
  }

  int get _aps => _subjects
      .where((subject) => subject.name.toLowerCase() != 'life orientation')
      .take(6)
      .fold(0, (total, subject) => total + apsPoints(subject.mark));

  int get _count => _subjects
      .where((subject) => subject.name.toLowerCase() != 'life orientation')
      .length;

  Future<void> _requestConsent() async {
    if (_consentShown || !mounted) return;
    _consentShown = true;
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ConsentDialog(),
    );
    if (!mounted) return;
    if (accepted != true) {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _addSubject() async {
    final result = await showDialog<_SubjectResult>(
      context: context,
      builder: (_) => _AddSubjectDialog(
        availableSubjects: _subjectOptions
            .where(
              (option) => !_subjects.any((subject) => subject.name == option),
            )
            .toList(),
      ),
    );
    if (result != null && mounted) {
      setState(() => _subjects.add(result));
    }
  }

  void _continue() {
    final scoredSubjects = _subjects
        .where((subject) => subject.name.toLowerCase() != 'life orientation')
        .toList();
    if (scoredSubjects.length < 6) {
      showAppMessage(context, 'Add at least six non-Life Orientation subjects.');
      return;
    }
    final marks = <String, int>{};
    for (final subject in _subjects) {
      if (subject.mark < 0 || subject.mark > 100) {
        showAppMessage(context, 'Each subject mark must be from 0 to 100.');
        return;
      }
      marks[subject.name] = subject.mark;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfileInterestsScreen(
          profile: widget.profile.copyWith(matricSubjects: marks),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Your results are a starting point.',
    subtitle: 'Add your final NSC subject percentages. They don’t define your potential.',
    children: [
      Row(
        children: const [
          Expanded(
            child: Text(
              'SUBJECT',
              style: TextStyle(
                color: nextStepPurple,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            'MARK %',
            style: TextStyle(
              color: nextStepPurple,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      if (_subjects.isEmpty)
        const InfoPanel(
          child: Text(
            'Add the subjects shown on your results. Life Orientation is recorded but excluded from this six-subject estimate.',
            style: TextStyle(color: nextStepMuted, height: 1.5),
          ),
        ),
      ..._subjects.map(
        (subject) => _SubjectRow(
          key: ValueKey(subject.name),
          subject: subject,
          availableSubjects: _subjectOptions
              .where(
                (option) =>
                    option == subject.name ||
                    !_subjects.any((item) => item.name == option),
              )
              .toList(),
          onChanged: (updated) => setState(() {
            final index = _subjects.indexOf(subject);
            if (index >= 0) _subjects[index] = updated;
          }),
          onRemove: () => setState(() => _subjects.remove(subject)),
        ),
      ),
      OutlinedButton.icon(
        onPressed: _addSubject,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add another subject'),
      ),
      const SizedBox(height: 14),
      InfoPanel(
        color: const Color(0xFFE4F5F2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ESTIMATED APS',
              style: TextStyle(
                color: Color(0xFF11857C),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$_aps / 42',
              style: const TextStyle(
                color: Color(0xFF11857C),
                fontSize: 38,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '$_count non-Life Orientation subjects recorded. '
              '${_count < 6 ? 'Add ${6 - _count} more for a six-subject estimate.' : 'Life Orientation is excluded.'}',
              style: const TextStyle(color: Color(0xFF11857C), height: 1.5),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const InfoPanel(
        child: Text(
          'Estimate guide: 80–100% = 7, 70–79% = 6, 60–69% = 5, 50–59% = 4, 40–49% = 3, 30–39% = 2, 0–29% = 1. Institutions may calculate APS differently. This is not confirmed eligibility.',
          style: TextStyle(color: nextStepMuted, height: 1.5),
        ),
      ),
      const SizedBox(height: 16),
      PrimaryAction(label: 'Save results', onPressed: _continue),
    ],
  );
}

class _SubjectResult {
  const _SubjectResult(this.name, this.mark);

  final String name;
  final int mark;
}

class _SubjectRow extends StatefulWidget {
  const _SubjectRow({
    required this.subject,
    required this.availableSubjects,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final _SubjectResult subject;
  final List<String> availableSubjects;
  final ValueChanged<_SubjectResult> onChanged;
  final VoidCallback onRemove;

  @override
  State<_SubjectRow> createState() => _SubjectRowState();
}

class _SubjectRowState extends State<_SubjectRow> {
  late final TextEditingController _markController =
      TextEditingController(text: '${widget.subject.mark}');

  @override
  void didUpdateWidget(covariant _SubjectRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subject.mark != widget.subject.mark &&
        _markController.text != '${widget.subject.mark}') {
      _markController.text = '${widget.subject.mark}';
    }
  }

  @override
  void dispose() {
    _markController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: widget.subject.name,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: widget.availableSubjects
                  .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                  .toList(),
              onChanged: (name) {
                if (name != null) {
                  widget.onChanged(_SubjectResult(name, widget.subject.mark));
                }
              },
            ),
          ),
          SizedBox(
            width: 66,
            child: TextField(
              controller: _markController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '%',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                final mark = int.tryParse(value);
                if (mark != null && mark <= 100) {
                  widget.onChanged(_SubjectResult(widget.subject.name, mark));
                }
              },
            ),
          ),
          IconButton(
            tooltip: 'Remove ${widget.subject.name}',
            onPressed: widget.onRemove,
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
        ],
      ),
    ),
  );
}

class _AddSubjectDialog extends StatefulWidget {
  const _AddSubjectDialog({required this.availableSubjects});

  final List<String> availableSubjects;

  @override
  State<_AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<_AddSubjectDialog> {
  final _mark = TextEditingController();
  String? _subject;

  @override
  void dispose() {
    _mark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add a subject'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _subject,
          decoration: const InputDecoration(labelText: 'Subject'),
          items: widget.availableSubjects
              .map((subject) => DropdownMenuItem(value: subject, child: Text(subject)))
              .toList(),
          onChanged: (value) => setState(() => _subject = value),
        ),
        TextField(
          controller: _mark,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(labelText: 'Mark (0–100)'),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          final mark = int.tryParse(_mark.text);
          if (_subject == null || mark == null || mark > 100) return;
          Navigator.pop(context, _SubjectResult(_subject!, mark));
        },
        child: const Text('Add subject'),
      ),
    ],
  );
}

class _ConsentDialog extends StatefulWidget {
  const _ConsentDialog();

  @override
  State<_ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<_ConsentDialog> {
  bool _agreed = false;
  bool _ageConfirmed = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Consent to use personal information'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Before you continue, please read this carefully:\n\n'
            '1. What we collect: your matric marks and interest choices, plus the town and province you provide.\n\n'
            '2. Why we collect it: to suggest career paths, courses and learnerships that may suit you.\n\n'
            '3. What we will not do: we do not share your marks or interests with providers or advertisers. You choose whether to follow external application links.\n\n'
            '4. Your right to delete: you can request deletion of your account data in settings.\n\n'
            '5. If you are under 18: obtain permission from a parent or guardian before entering this information.',
            style: TextStyle(height: 1.45),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('I have read and agree to the above.'),
            value: _agreed,
            onChanged: (value) => setState(() => _agreed = value ?? false),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'I am 18 or older, OR I have parent/guardian permission.',
            ),
            value: _ageConfirmed,
            onChanged: (value) =>
                setState(() => _ageConfirmed = value ?? false),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Return'),
      ),
      FilledButton(
        onPressed: _agreed && _ageConfirmed
            ? () => Navigator.pop(context, true)
            : null,
        child: const Text('Continue'),
      ),
    ],
  );
}
