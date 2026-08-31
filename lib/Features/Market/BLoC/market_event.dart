import '../../../Data/Models/product_model.dart';

abstract class MarketEvent {}

class ChangeCategory extends MarketEvent {
  final String category;
  ChangeCategory(this.category);
}

class AddToCart extends MarketEvent {
  final ProductModel product;
  AddToCart(this.product);
}

class IncrementQuantity extends MarketEvent {
  final ProductModel product;
  IncrementQuantity(this.product);
}

class DecrementQuantity extends MarketEvent {
  final ProductModel product;
  DecrementQuantity(this.product);
}