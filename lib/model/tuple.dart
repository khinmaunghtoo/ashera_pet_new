class Tuple<T1, T2>{
  final T1? i1;
  final T2? i2;

  Tuple(this.i1, this.i2);

  factory Tuple.fromJson(Map<String, dynamic> json){
    return Tuple(json['i1'], json['i2']);
  }
}