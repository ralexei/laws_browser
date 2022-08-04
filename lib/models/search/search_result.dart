class SearchResult<T> {
  late final T result;

  double score = 0.0;
  String matchedFullString = '';
  Set<String> matchedTerms = <String>{};

  SearchResult.fullMatch({
    required this.result,
    required this.score,
    required this.matchedFullString,
  });

  SearchResult.containsTerms({
    required this.result,
    required this.score,
    required this.matchedTerms
  });
}