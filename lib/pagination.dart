import 'package:bwi1/Screens/Products/productsHome.dart';
import 'package:bwi1/widgets/pageHeader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<DocumentSnapshot> products = []; // stores fetched products
  bool isLoading = false; // track if products fetching
  bool hasMore = true; // flag for more products available or not
  int documentLimit = 20; // documents to be fetched per request
  DocumentSnapshot?
      lastDocument; // flag for last document from where next 10 records to be fetched
  ScrollController _scrollController = ScrollController();

  getProducts() async {
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      print('Document is Null : $lastDocument');
      querySnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc('project-1001')
          .collection('products')
          .limit(documentLimit)
          .get();
      // setState(() {
      //   isLoading = false;
      // });
    } else {
      print('Document is not Null : $lastDocument');

      querySnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc('project-1001')
          .collection('products')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      // setState(() {
      //   isLoading = false;
      // });
    }
    if (querySnapshot.docs.length < documentLimit) {
      setState(() {
        hasMore = false;
      });
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    products.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
        setState(() {
          isLoading = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              pageHeader(context: context, title: 'Products'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ProductsHome()));
                  },
                  label: Text('Add New Products'),
                  icon: Icon(Icons.add),
                ),
              ),
              products.length == 0
                  ? Center(
                      child: Text('No Data...'),
                    )
                  : ListView.builder(
                      // controller: _scrollController,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(products[index]['createdAt'].toString()),
                        );
                      }),
              isLoading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      child: LinearProgressIndicator(
                        color: Colors.black,
                        backgroundColor: Colors.grey,
                      ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
