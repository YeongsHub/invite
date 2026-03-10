import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:invite/shared/models/rsvp_models.dart';

class RsvpNotifier extends AsyncNotifier<RsvpState> {
  static const _eventsKey = 'rsvp_events';
  static const _responsesKey = 'rsvp_responses';

  @override
  Future<RsvpState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getStringList(_eventsKey) ?? [];
    final responsesJson = prefs.getStringList(_responsesKey) ?? [];

    final events = eventsJson
        .map((e) => RsvpEvent.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
    final responses = responsesJson
        .map((e) => RsvpResponse.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();

    return RsvpState(events: events, responses: responses);
  }

  Future<RsvpEvent> createEvent(String title) async {
    final event = RsvpEvent(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
    );
    final current = state.valueOrNull ?? const RsvpState();
    final updated = current.copyWith(events: [...current.events, event]);
    state = AsyncData(updated);
    await _persist(updated);
    return event;
  }

  Future<void> addResponse(RsvpResponse response) async {
    final current = state.valueOrNull ?? const RsvpState();
    final updated = current.copyWith(responses: [...current.responses, response]);
    state = AsyncData(updated);
    await _persist(updated);
  }

  List<RsvpResponse> responsesForEvent(String eventId) {
    return (state.valueOrNull?.responses ?? [])
        .where((r) => r.eventId == eventId)
        .toList();
  }

  Future<void> _persist(RsvpState s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _eventsKey,
      s.events.map((e) => jsonEncode(e.toJson())).toList(),
    );
    await prefs.setStringList(
      _responsesKey,
      s.responses.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }
}

final rsvpProvider = AsyncNotifierProvider<RsvpNotifier, RsvpState>(
  RsvpNotifier.new,
);
