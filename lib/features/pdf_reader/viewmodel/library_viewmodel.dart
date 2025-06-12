import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/book.dart';
import '../repository/book_repository.dart';

class LibraryState {
  final List<Book> allBooks;
  final List<Book> recentBooks;
  final bool isLoading;
  final String? errorMessage;

  LibraryState({
    this.allBooks = const [],
    this.recentBooks = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  LibraryState copyWith({
    List<Book>? allBooks,
    List<Book>? recentBooks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LibraryState(
      allBooks: allBooks ?? this.allBooks,
      recentBooks: recentBooks ?? this.recentBooks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LibraryViewModel extends StateNotifier<LibraryState> {
  final BookRepository _repository;

  LibraryViewModel(this._repository) : super(LibraryState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.initialize();
      _refreshBooks();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to initialize library: $e',
      );
    }
  }

  void _refreshBooks() {
    final allBooks = _repository.getAllBooks();
    final recentBooks = _repository.getRecentBooks();
    state = state.copyWith(
      allBooks: allBooks,
      recentBooks: recentBooks,
      isLoading: false,
    );
  }

  Future<void> addBook(File file) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.addBook(file);
      _refreshBooks();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add book: $e',
      );
    }
  }

  Future<void> updateProgress(String bookId, double progress) async {
    try {
      await _repository.updateProgress(bookId, progress);
      _refreshBooks();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update progress: $e',
      );
    }
  }

  Future<void> deleteBook(String bookId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.deleteBook(bookId);
      _refreshBooks();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete book: $e',
      );
    }
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }
}

// Providers
final bookRepositoryProvider = Provider((ref) => BookRepository());

final libraryViewModelProvider =
    StateNotifierProvider<LibraryViewModel, LibraryState>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return LibraryViewModel(repository);
});
