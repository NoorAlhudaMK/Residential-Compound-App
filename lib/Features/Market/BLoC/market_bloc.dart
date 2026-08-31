import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Models/cart_item_model.dart';
import '../../../Data/Models/product_model.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final List<ProductModel> _allProducts = [
    // بقالة
    ProductModel(
      name: 'سلة طازجة',
      category: 'بقالة',
      description: 'فواكه موسمية وتمور',
      price: 'IQD 18,500',
      imageUrl: 'assets/images/lemon.png',
    ),
    ProductModel(
      name: 'خضار عضوية',
      category: 'بقالة',
      description: 'تشكيلة خضار طازجة منوعة',
      price: 'IQD 12,000',
      imageUrl: 'assets/images/veggies.png',
    ),
    // طعام
    ProductModel(
      name: 'صندوق المخبوزات والحرفيين',
      category: 'طعام',
      description: 'خبز ومعجنات طازجة مخبوزة يومياً',
      price: 'IQD 10,000',
      imageUrl: 'assets/images/bread.png',
    ),
    ProductModel(
      name: 'وجبة ساخنة متكاملة',
      category: 'طعام',
      description: 'تشكيلة وجبات ساخنة جاهزة للأكل',
      price: 'IQD 15,000',
      imageUrl: 'assets/images/meal.png',
    ),
    // منزل
    ProductModel(
      name: 'مجموعة التنظيف الاحترافية',
      category: 'منزل',
      description: 'مستلزمات منزلية صديقة للبيئة',
      price: 'IQD 22,000',
      imageUrl: 'assets/images/clean.png',
    ),
    ProductModel(
      name: 'شموع معطرة',
      category: 'منزل',
      description: 'عطور منزلية عطرية طبيعية',
      price: 'IQD 14,000',
      imageUrl: 'assets/images/candle.png',
    ),
    // صيدلية
    ProductModel(
      name: 'أساسيات الإسعافات الأولية',
      category: 'صيدلية',
      description: 'رعاية طبية وحقيبة طوارئ',
      price: 'IQD 25,000',
      imageUrl: 'assets/images/medical.png',
    ),
    ProductModel(
      name: 'الفيتامينات اليومية',
      category: 'صيدلية',
      description: 'مجموعة مكملات الفيتامينات المتعددة',
      price: 'IQD 30,000',
      imageUrl: 'assets/images/vitamins.png',
    ),
  ];

  MarketBloc() : super(MarketLoaded(
    categories: ['بقالة', 'صيدلية', 'منزل', 'طعام'],
    selectedCategory: 'بقالة',
    products: [
      ProductModel(
        name: 'سلة طازجة',
        category: 'بقالة',
        description: 'فواكه موسمية وتمور',
        price: 'IQD 18,500',
        imageUrl: 'assets/images/lemon.png',
      ),
      ProductModel(
        name: 'خضار عضوية',
        category: 'بقالة',
        description: 'تشكيلة خضار طازجة منوعة',
        price: 'IQD 12,000',
        imageUrl: 'assets/images/veggies.png',
      ),
    ],
    cartItems: [],
  )) {
    on<ChangeCategory>((event, emit) {
      final filteredProducts = _allProducts
          .where((p) => p.category == event.category)
          .toList();

      final currentState = state as MarketLoaded;
      emit(currentState.copyWith(
        selectedCategory: event.category,
        products: filteredProducts,
      ));
    });

    on<AddToCart>((event, emit) {
      final currentState = state as MarketLoaded;

      List<CartItemModel> updatedCart = List.from(currentState.cartItems);

      final existingIndex = updatedCart.indexWhere((item) => item.product.name == event.product.name);

      if (existingIndex >= 0) {
        updatedCart[existingIndex] = CartItemModel(
          product: updatedCart[existingIndex].product,
          quantity: updatedCart[existingIndex].quantity + 1,
        );
      } else {
        updatedCart.add(CartItemModel(product: event.product, quantity: 1));
      }

      emit(currentState.copyWith(cartItems: updatedCart));
    });

    on<IncrementQuantity>((event, emit) {
      final currentState = state as MarketLoaded;
      final updatedCart = currentState.cartItems.map((item) {
        if (item.product.name == event.product.name) {
          return CartItemModel(product: item.product, quantity: item.quantity + 1);
        }
        return item;
      }).toList();
      emit(currentState.copyWith(cartItems: updatedCart));
    });

    on<DecrementQuantity>((event, emit) {
      final currentState = state as MarketLoaded;
      final updatedCart = <CartItemModel>[];
      for (var item in currentState.cartItems) {
        if (item.product.name == event.product.name) {
          if (item.quantity > 1) {
            updatedCart.add(CartItemModel(product: item.product, quantity: item.quantity - 1));
          }
        } else {
          updatedCart.add(item);
        }
      }
      emit(currentState.copyWith(cartItems: updatedCart));
    });
  }
}