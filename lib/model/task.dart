class Task {
  final int? id;
  final String title;
  final String description;
  final String status;
  final DateTime lastUpdatedAt;
  final DateTime? lastSyncedAt;
  final bool isDirty;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.lastUpdatedAt,
    this.lastSyncedAt,
    required this.isDirty,
  });

  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'],
      description: map['description'],
      status: map['status'],
      lastUpdatedAt: DateTime.parse(map['lastUpdatedAt']),
      lastSyncedAt: map['lastSyncedAt'] != null
          ? DateTime.parse(map['lastSyncedAt'])
          : null,
      isDirty: map['isDirty'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'isDirty': isDirty ? 1 : 0,
    };
  }
}
