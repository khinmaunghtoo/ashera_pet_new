class SearchContainsDTO{
  final String qs;

  const SearchContainsDTO({
    required this.qs
  });

  Map<String, dynamic> toMap(){
    return {
      'qs': qs
    };
  }
}