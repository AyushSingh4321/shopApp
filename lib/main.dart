import 'package:flutter/material.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
          primaryColor: Colors.purple,
          colorScheme:
              ThemeData().colorScheme.copyWith(secondary: Colors.deepOrange),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          fontFamily: 'Lato',
          ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (ctx)=>ProductDetailScreen(),
      },
    );
  }
}
