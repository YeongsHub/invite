class RsvpEvent {
  const RsvpEvent({
    required this.id,
    required this.title,
    required this.createdAt,
    this.deadline,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime? deadline;

  bool get isExpired =>
      deadline != null && DateTime.now().isAfter(deadline!);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        if (deadline != null) 'deadline': deadline!.toIso8601String(),
      };

  factory RsvpEvent.fromJson(Map<String, dynamic> json) => RsvpEvent(
        id: json['id'] as String,
        title: json['title'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        deadline: json['deadline'] != null
            ? DateTime.parse(json['deadline'] as String)
            : null,
      );
}

class RsvpResponse {
  const RsvpResponse({
    required this.id,
    required this.eventId,
    required this.guestName,
    required this.attending,
    required this.timestamp,
    this.message = '',
    this.guestCount = 1,
  });

  final String id;
  final String eventId;
  final String guestName;
  final bool attending;
  final String message;
  final DateTime timestamp;
  final int guestCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'guestName': guestName,
        'attending': attending,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'guestCount': guestCount,
      };

  factory RsvpResponse.fromJson(Map<String, dynamic> json) => RsvpResponse(
        id: json['id'] as String,
        eventId: json['eventId'] as String,
        guestName: json['guestName'] as String,
        attending: json['attending'] as bool,
        message: json['message'] as String? ?? '',
        timestamp: DateTime.parse(json['timestamp'] as String),
        guestCount: json['guestCount'] as int? ?? 1,
      );
}

class RsvpState {
  const RsvpState({
    this.events = const [],
    this.responses = const [],
  });

  final List<RsvpEvent> events;
  final List<RsvpResponse> responses;

  RsvpState copyWith({List<RsvpEvent>? events, List<RsvpResponse>? responses}) =>
      RsvpState(
        events: events ?? this.events,
        responses: responses ?? this.responses,
      );
}
