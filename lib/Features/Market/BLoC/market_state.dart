import '../../../Data/Models/cart_item_model.dart';
import '../../../Data/Models/product_model.dart';

abstract class MarketState {}

class MarketLoaded extends MarketState {
  final List<String> categories;
  final String selectedCategory;
  final List<ProductModel> products;
  final List<CartItemModel> cartItems;

  MarketLoaded({
    required this.categories,
    required this.selectedCategory,
    required this.products,
    required this.cartItems,
  });

  int get cartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get subtotalPrice {
    return cartItems.fold(0, (sum, item) {
      int priceNum = int.tryParse(item.product.price.replaceAll(RegExp(r'[^0-9]'), '').trim()) ?? 0;
      return sum + (priceNum * item.quantity);
    });
  }

  MarketLoaded copyWith({
    String? selectedCategory,
    List<ProductModel>? products,
    List<CartItemModel>? cartItems,
  }) {
    return MarketLoaded(
      categories: categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
    );
  }
}