import 'dart:async';
import 'dart:convert';

import 'package:api_avik_da/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Products>> fetchProduct() async {
  final response = await http
      .get(Uri.parse('https://dummyjson.com/products'));

  if (response.statusCode == 200) {
    Map<String, dynamic> valueMap = json.decode(response.body);
    ProductsModel productsModel = ProductsModel.fromJson(valueMap);
    return productsModel.products!;
  } else {
    throw Exception('Failed to load Product');
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Products>> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fetch Data with API',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Fetch Data with API'),
            ),
            body: Center(
                child: FutureBuilder<List<Products>>(
              future: futureProduct,
              builder: (context, data) {
                if (data.hasError) {
                  return Center(child: Text("${data.error}"));
                } else if (data.hasData) {
                  var items = data.data as List<Products>;
                  return ListView.builder(
                      itemCount: items == null ? 0 : items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image(
                                        image: NetworkImage(
                                            items[index].thumbnail!),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Text(
                                              items[index].title.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Text(items[index]
                                                .description
                                                .toString()),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                                Container(
                                  height: 70,
                                  width: double.infinity,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: items[index].images?.length,
                                      itemBuilder: (context, i) {
                                        return SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Image(
                                              image: NetworkImage(
                                                  items[index].images![i]),
                                              fit: BoxFit.fill),
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ))));
  }
}
