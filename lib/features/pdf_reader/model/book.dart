import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String filePath;

  @HiveField(4)
  final String? coverUrl;

  @HiveField(5)
  double progress;

  @HiveField(6)
  DateTime lastRead;

  @HiveField(7)
  final String fileType; // 'pdf' or 'epub'

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.filePath,
    this.coverUrl,
    this.progress = 0.0,
    DateTime? lastRead,
    required this.fileType,
  }) : lastRead = lastRead ?? DateTime.now();

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'filePath': filePath,
      'coverUrl': coverUrl,
      'progress': progress,
      'lastRead': lastRead.toIso8601String(),
      'fileType': fileType,
    };
  }

  // Create from Map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      filePath: map['filePath'],
      coverUrl: map['coverUrl'],
      progress: map['progress'] ?? 0.0,
      lastRead: DateTime.parse(map['lastRead']),
      fileType: map['fileType'],
    );
  }

  // Update progress
  void updateProgress(double newProgress) {
    progress = newProgress;
    lastRead = DateTime.now();
  }

  String get lastReadFormatted {
    final now = DateTime.now();
    final difference = now.difference(lastRead);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Just now';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }
}
