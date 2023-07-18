/*import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CartProvider with ChangeNotifier {
  CustomerCart? cart;
  GraphQLClient client;
  String? token;
  bool _disposed = false;

  CartProvider({required this.client, required this.token}) {
    load();
  }

  Future<void> load() async {
    if (token == null) {
      cart = null;
    } else {
      var res = await CartQuery(client).call();
      cart = res;
    }
    notifyListeners();
  }

  Future<void> add({required String productId, required int quantity}) async {
    var res = await CartAddMutation(client)
        .call(productId: productId, quantity: quantity);
    cart = res;
    notifyListeners();
  }

  Future<void> modify(
      {required String productId, required int quantity}) async {
    var res = await CartModifyMutation(client)
        .call(productId: productId, quantity: quantity);
    cart = res;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}

final cartProvider = ChangeNotifierProvider<CartProvider>((ref) {
  var client = ref.watch(authProvider).client;
  var token = ref.watch(authProvider).token;
  log('client changed ${client.hashCode} $token');
  return CartProvider(client: client, token: token);
});

*/