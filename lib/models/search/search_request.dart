typedef Tokenizer<T> = List<String> Function(T);

class SearchRequest<T> {
  final String term;
  final List<T> items;

  const SearchRequest({
    required this.items,
    required this.term
  });
}