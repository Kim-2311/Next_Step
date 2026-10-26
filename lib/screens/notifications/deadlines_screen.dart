import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/opportunity.dart';
import '../../services/opportunity_service.dart';
import '../../services/student_service.dart';
import '../../widgets/app_components.dart';
import '../explore/opportunity_details_screen.dart';

class DeadlinesScreen extends StatefulWidget {
  const DeadlinesScreen({super.key});

  @override
  State<DeadlinesScreen> createState() => _DeadlinesScreenState();
}

class _DeadlinesScreenState extends State<DeadlinesScreen> {
  String _filter = 'All';
  Set<String> _read = {};
  Set<String> _saved = {};
  bool _loading = true;
  String? _error;
  List<Opportunity> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await StudentService().getSavedOpportunityIds();
      final records = await StudentService().getApplications();
      final activeIds = {...saved, ...records.map((record) => record.opportunityId)};
      final opportunities = OpportunityService.sampleOpportunities
          .where((item) => activeIds.contains(item.id))
          .toList()
        ..sort((a, b) => a.closingDate.compareTo(b.closingDate));
      if (!mounted) return;
      setState(() {
        _items = opportunities;
        _saved = saved;
        _read =
            preferences
                .getStringList('${_userKey}readDeadlineItems')
                ?.toSet() ??
            {};
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _markRead(String id) async {
    final updated = {..._read, id};
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      '${_userKey}readDeadlineItems',
      updated.toList(),
    );
    if (mounted) setState(() => _read = updated);
  }

  Future<void> _markAllRead() async {
    final updated = {..._read, ..._items.map((item) => item.id)};
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      '${_userKey}readDeadlineItems',
      updated.toList(),
    );
    if (mounted) setState(() => _read = updated);
  }

  String get _userKey =>
      '${FirebaseAuth.instance.currentUser?.uid ?? 'device'}:';

  @override
  Widget build(BuildContext context) {
    final visible = _items.where((item) {
      if (_filter == 'Deadlines') return true;
      if (_filter == 'Matches') return !_saved.contains(item.id);
      return true;
    }).toList();
    final unread = _items.where((item) => !_read.contains(item.id)).length;
    return AppPage(
      title: 'A timely nudge. A clearer next step.',
      subtitle: 'Notifications & Deadlines · $unread unread',
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _markAllRead,
            child: const Text('Mark all as read'),
          ),
        ),
        Wrap(
          spacing: 8,
          children: ['All', 'Deadlines', 'Matches'].map((filter) {
            return ChoiceChip(
              label: Text(filter),
              selected: _filter == filter,
              onSelected: (_) => setState(() => _filter = filter),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          InfoPanel(
            child: Column(
              children: [
                Text(_error!),
                TextButton(onPressed: _load, child: const Text('Try again')),
              ],
            ),
          )
        else if (visible.isEmpty)
          const InfoPanel(
            child: Text(
              'No deadline reminders yet. Save an opportunity to keep its example closing date close.',
            ),
          )
        else
          ...visible.map(
            (item) => _DeadlineCard(
              item: item,
              read: _read.contains(item.id),
              onRead: () => _markRead(item.id),
            ),
          ),
        const SizedBox(height: 14),
        const InfoPanel(
          color: Color(0xFFE4F5F2),
          child: Text(
            'Example reminders only. No live provider updates are connected. Confirm all dates with the organisation.',
            style: TextStyle(color: Color(0xFF11857C), height: 1.5),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => showAppMessage(
            context,
            'Device notification permission is optional and is not enabled in this app build.',
          ),
          child: const Text('Manage notification permission'),
        ),
      ],
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  const _DeadlineCard({
    required this.item,
    required this.read,
    required this.onRead,
  });

  final Opportunity item;
  final bool read;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    color: read ? Colors.white : nextStepLavender,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.category == 'funding' ? 'Closing soon' : 'Saved reminder',
            style: const TextStyle(
              color: nextStepPurple,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${item.title} · ${item.closingDateLabel}',
            style: const TextStyle(
              color: nextStepInk,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Illustrative example from ${item.provider}. Check the latest requirements and date directly.',
            style: const TextStyle(color: nextStepMuted, height: 1.45),
          ),
          Row(
            children: [
              TextButton(
                onPressed: read ? null : onRead,
                child: Text(read ? 'Read' : 'Mark read'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        OpportunityDetailsScreen(opportunity: item),
                  ),
                ),
                child: const Text('View opportunity →'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}