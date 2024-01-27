class GoodsMealEntity {
  final int _qty;
  int get qty => _qty;

  final double _value;
  double get value => _value;

  const GoodsMealEntity({qty, val}) : _qty = qty, _value = val;

  Map<String, dynamic> toMap() {
    return {
      'qty': qty,
      'value': value
    };
  }

}