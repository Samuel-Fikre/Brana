import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../model/book.dart';
import 'package:path_provider/path_provider.dart';

class BookRepository {
  static const String _boxName = 'books';
  late Box<Book> _box;
  final _uuid = const Uuid();

  // Initialize the repository
  Future<void> initialize() async {
    if (!Hive.isBoxOpen(_boxName)) {
      Hive.registerAdapter(BookAdapter());
      _box = await Hive.openBox<Book>(_boxName);
    } else {
      _box = Hive.box<Book>(_boxName);
    }
  }

  // Add a new book
  Future<Book> addBook(File file) async {
    final String fileType =
        path.extension(file.path).toLowerCase().replaceAll('.', '');
    if (fileType != 'pdf' && fileType != 'epub') {
      throw UnsupportedError('Unsupported file type: $fileType');
    }

    // Copy file to app documents directory
    final appDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory('${appDir.path}/books');
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }

    final fileName = path.basename(file.path);
    final savedFile = await file.copy('${booksDir.path}/$fileName');

    // Create book object
    final book = Book(
      id: _uuid.v4(),
      title: path.basenameWithoutExtension(file.path),
      author: 'Unknown', // You might want to extract this from metadata
      filePath: savedFile.path,
      fileType: fileType,
    );

    // Save to Hive
    await _box.put(book.id, book);
    return book;
  }

  // Get all books
  List<Book> getAllBooks() {
    return _box.values.toList();
  }

  // Get recently read books
  List<Book> getRecentBooks({int limit = 3}) {
    return _box.values.toList().where((book) => book.progress > 0).toList()
      ..sort((a, b) => b.lastRead.compareTo(a.lastRead))
      ..take(limit);
  }

  // Update book progress
  Future<void> updateProgress(String bookId, double progress) async {
    final book = _box.get(bookId);
    if (book != null) {
      book.updateProgress(progress);
      await _box.put(bookId, book);
    }
  }

  // Delete book
  Future<void> deleteBook(String bookId) async {
    final book = _box.get(bookId);
    if (book != null) {
      // Delete the file
      final file = File(book.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      // Remove from Hive
      await _box.delete(bookId);
    }
  }

  // Close the box
  Future<void> close() async {
    await _box.close();
  }
}
