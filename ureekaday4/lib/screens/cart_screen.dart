import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      
      body: cartProvider.items.isEmpty
          ? const Center(child: Text('Keranjang kosong')) 
          : Column(
              children: [
                Text("Total Price: \$${cartProvider.totalPrice}"),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.items.length,
                    itemBuilder: (ctx, i) {
                      final cartItem = cartProvider.items.values.toList()[i];
                      return ListTile(
                        title: Text(cartItem.title),
                        subtitle: Text('Total: \$${(cartItem.price * cartItem.quantity)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            cartProvider.removeItem(cartItem.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
