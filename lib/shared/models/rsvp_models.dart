class RsvpEvent {
  const RsvpEvent({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  final String id;
  final String title;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
  };

  factory RsvpEvent.fromJson(Map<String, dynamic> json) => RsvpEvent(
    id: json['id'] as String,
    title: json['title'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
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
  });

  final String id;
  final String eventId;
  final String guestName;
  final bool attending;
  final String message;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'guestName': guestName,
    'attending': attending,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
  };

  factory RsvpResponse.fromJson(Map<String, dynamic> json) => RsvpResponse(
    id: json['id'] as String,
    eventId: json['eventId'] as String,
    guestName: json['guestName'] as String,
    attending: json['attending'] as bool,
    message: json['message'] as String? ?? '',
    timestamp: DateTime.parse(json['timestamp'] as String),
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
