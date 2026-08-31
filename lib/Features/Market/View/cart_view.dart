import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Core/CacheManager/cache_manager.dart';
import 'package:residential_compound_app/Core/Colors/app_colors.dart';
import 'package:residential_compound_app/Data/Models/user_model.dart';

import '../BLoC/market_bloc.dart';
import '../BLoC/market_event.dart';
import '../BLoC/market_state.dart';
import 'checkout_view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppColors colors = AppColors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'السلة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.textMain,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined, color: colors.textMain),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: BlocBuilder<MarketBloc, MarketState>(
            builder: (context, state) {
              if (state is MarketLoaded) {
                final subtotal = state.subtotalPrice;
                final deliveryFee = state.cartItems.isEmpty ? 0 : 3000;
                final total = subtotal + deliveryFee;

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          // Top Summary Banner Box
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'د.ع ${subtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${state.cartCount} منتجات ',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // If cart is empty
                          if (state.cartItems.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Text(
                                  'السلة فارغة حالياً',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          else
                            // Cart Items List
                            ...state.cartItems.map((cartItem) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: colors.inputFill,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: Colors.amber.shade100,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                cartItem.product.imageUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItem.product.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: colors.textMain,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              cartItem.product.price.replaceFirst("IQD", "د.ع"),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: colors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: colors.inputFill,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: colors.inputBorder,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                            ),
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.add,
                                              size: 16,
                                            ),
                                            color: colors.primary,
                                            onPressed: () {
                                              context.read<MarketBloc>().add(
                                                IncrementQuantity(
                                                  cartItem.product,
                                                ),
                                              );
                                            },
                                          ),
                                          Text(
                                            '${cartItem.quantity}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: colors.textMain,
                                            ),
                                          ),
                                          IconButton(
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                            ),
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 16,
                                            ),
                                            color: colors.textSecondary,
                                            onPressed: () {
                                              context.read<MarketBloc>().add(
                                                DecrementQuantity(
                                                  cartItem.product,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                          const SizedBox(height: 10),

                          if (state.cartItems.isNotEmpty)
                            FutureBuilder(
                              future: getUserInfo(),
                              builder: (context, data) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: colors.inputBorder,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'توصيل • ${data.data!.residentProfiles[0].primaryUnit.name}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'المجموع • د.ع ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textMain,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),

                    // Checkout Button Bottom
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: state.cartItems.isEmpty
                              ? null
                              : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: BlocProvider.of<MarketBloc>(context),
                                  child: const CheckoutScreen(),
                                ),
                              ),
                            );
                                },
                          child: const Text(
                            'إتمام الطلب',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Future<UserModel> getUserInfo() async {
    return await CacheManager.getUserModel();
  }
}
