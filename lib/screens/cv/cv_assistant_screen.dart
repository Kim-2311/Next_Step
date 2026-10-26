import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../services/cv_service.dart';
import '../../widgets/app_components.dart';

class CvAssistantScreen extends StatefulWidget {
  const CvAssistantScreen({super.key});

  @override
  State<CvAssistantScreen> createState() => _CvAssistantScreenState();
}

class _CvAssistantScreenState extends State<CvAssistantScreen> {
  final _title = TextEditingController();
  final _target = TextEditingController();
  final _profile = TextEditingController();
  final _education = TextEditingController();
  final _skills = TextEditingController();
  final _projects = TextEditingController();
  bool _saving = false;
  bool _exporting = false;
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _title.text = 'My entry-level CV';
    _target.text = 'Entry-level opportunity';
    _profile.text = 'Matric graduate ready to learn, contribute and build practical experience.';
    _education.text = 'National Senior Certificate';
    _skills.text = 'Communication · Numeracy · Problem-solving';
    _projects.text =
        'Add a genuine school project, volunteering role or responsibility.';
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    try {
      final draft = await CvService().loadDraft();
      if (!mounted) return;
      if (draft != null) {
        _title.text = draft.title;
        _target.text = draft.targetOpportunity;
        _profile.text = draft.profile;
        _education.text = draft.education;
        _skills.text = draft.skills;
        _projects.text = draft.projects;
      }
      setState(() => _loading = false);
    } catch (error) {
      if (mounted) {
        setState(() {
          _loadError = error.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _target.dispose();
    _profile.dispose();
    _education.dispose();
    _skills.dispose();
    _projects.dispose();
    super.dispose();
  }

  CvDraft get _draft => CvDraft(
    title: _title.text.trim(),
    targetOpportunity: _target.text.trim(),
    profile: _profile.text.trim(),
    education: _education.text.trim(),
    skills: _skills.text.trim(),
    projects: _projects.text.trim(),
  );

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await CvService().saveDraft(_draft);
      if (!mounted) return;
      showAppMessage(context, 'Your CV draft was saved to your account.');
    } catch (error) {
      if (!mounted) return;
      showAppMessage(context, 'Could not save your CV draft: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _exportPdf() async {
    setState(() => _exporting = true);
    try {
      final draft = _draft;
      final sections = <pw.Widget>[
        pw.Text(
          draft.title.isEmpty ? 'My CV' : draft.title,
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        if (draft.targetOpportunity.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 6),
            child: pw.Text(
              'Target: ${draft.targetOpportunity}',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
        pw.SizedBox(height: 18),
      ];
      void addSection(String heading, String text) {
        if (text.trim().isEmpty) return;
        sections
          ..add(
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
              child: pw.Text(
                heading,
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          )
          ..add(pw.Paragraph(text: text.trim()));
      }

      addSection('Profile', draft.profile);
      addSection('Education', draft.education);
      addSection('Strengths', draft.skills);
      addSection('Projects and experience', draft.projects);

      final document = pw.Document();
      document.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(42),
          build: (_) => sections,
        ),
      );
      final filename = (draft.title.isEmpty ? 'my_cv' : draft.title)
          .replaceAll(RegExp(r'[^\w -]'), '')
          .trim()
          .replaceAll(RegExp(r'\s+'), '_');
      await Printing.sharePdf(
        bytes: await document.save(),
        filename: '${filename.isEmpty ? 'my_cv' : filename}.pdf',
      );
      if (mounted) {
        showAppMessage(context, 'Your CV PDF is ready to save or share.');
      }
    } catch (error) {
      if (mounted) showAppMessage(context, 'Could not export your CV: $error');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _preview() {
    final draft = _draft;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CV preview'),
        content: SingleChildScrollView(child: SelectableText(draft.plainText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Your first CV. Your own story.',
    subtitle:
        'Shape an honest, clear introduction for the opportunity you want.',
    children: [
      InfoPanel(
        color: Color(0xFFE4F5F2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Start with school, projects and everyday responsibilities. This is an editable CV draft, not AI-generated experience.',
              style: TextStyle(color: Color(0xFF11857C), height: 1.5),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: LinearProgressIndicator(color: nextStepTeal),
              ),
            if (_loadError != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Existing draft could not be loaded: $_loadError',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      _field(_title, 'CV title'),
      _field(_target, 'Target opportunity'),
      _field(_profile, 'Profile summary', maxLines: 4),
      _field(_education, 'Education'),
      _field(_skills, 'Strengths you can demonstrate'),
      _field(_projects, 'Projects and experience', maxLines: 4),
      const InfoPanel(
        child: Text(
          'Do not add your ID number, bank details or full street address. Only include references after asking permission.',
          style: TextStyle(color: nextStepMuted, height: 1.5),
        ),
      ),
      const SizedBox(height: 18),
      PrimaryAction(
        label: _saving ? 'Saving…' : 'Save CV draft',
        onPressed: _saving ? null : _save,
        icon: Icons.check_rounded,
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: _preview,
        icon: const Icon(Icons.description_outlined),
        label: const Text('Preview CV'),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: _exporting || _saving ? null : _exportPdf,
        icon: _exporting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.picture_as_pdf_outlined),
        label: Text(_exporting ? 'Preparing PDF…' : 'Export PDF'),
      ),
      const SizedBox(height: 8),
      const Text(
        'Check every detail and only include skills or examples that reflect your own experience.',
        style: TextStyle(color: nextStepMuted, height: 1.5),
      ),
    ],
  );

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}
