class GoodsBag {

  final double value;
  int quantity;

  GoodsBag({required this.value, required this.quantity});

  GoodsBag clone() {
    return GoodsBag(value: value, quantity: quantity);
  }

}