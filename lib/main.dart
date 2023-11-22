// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// void main(){
//   runApp(MyApp());
// }
//
// class CounterController extends GetxController{
//   var count=0.obs;
//   increment()=>{count++};
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final CounterController controller=Get.put(CounterController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("GetXExample"),
//       ),
//       body:
//         Center(child: Obx(()=> Text('${controller.count}'))),
//       floatingActionButton: FloatingActionButton(
//         onPressed: controller.increment,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//
//     );
//   }
// }
//

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'Products.dart';
import 'ProductsJson.dart';

void main() {
  runApp(MyApp());
}

class ApiController extends GetxController {
  RxList<Products> _products = <Products>[].obs;

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse("https://dummyjson.com/products"));
    if (response.statusCode == 200) {
      var getProductsData = json.decode(response.body.toString());
      final productsData = getProductsData['products'] as List<dynamic>;

      final productList = productsData
          .map((ProductsJson) => Products.fromJson(ProductsJson))
          .toList();

      _products.assignAll(productList);
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiController apiController = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    apiController.fetchProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text("GetX Api integration"),
      ),
      body: Obx(() => ListView.builder(
          itemCount: apiController._products.length,
          itemBuilder: (BuildContext context, int index) {
            Products pro = apiController._products[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.network("${pro.thumbnail}"),
                    ),
                    Text("${pro.description}"),
                    // Row(
                    //   children: [
                    //     Text("Status  - "),
                    //     Container(child: us.completed==true ? Icon(Icons.done): Icon(Icons.error)),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          })),
    );
  }
}
