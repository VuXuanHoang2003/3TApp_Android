import 'package:flutter/material.dart';
import 'package:three_tapp_app/main.dart';
// import 'package:three_tapp_app/view/common_view/product_details_screen.dart';
import 'package:three_tapp_app/view/customer/cart/cart_screen.dart';
import 'package:three_tapp_app/view/product_details_screen.dart';

import '../../../model/product.dart';
import '../../../model/status.dart';
import '../../../utils/common_func.dart';
import '../../../viewmodel/product_viewmodel.dart';
import '../../common_view/product_item_customer_view.dart';
import 'package:badges/badges.dart' as badges;

class CustomerHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  ProductViewModel productViewModel = ProductViewModel();
  TextEditingController searchBarController = TextEditingController();
  FocusNode searchBarFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productViewModel.getAllProduct();
      productViewModel.getProductStream.listen((status) {
        if (status == Status.loading) {
          // Handle loading state if needed
        } else if (status == Status.completed) {
          if (mounted) {
            reloadView();
          }
        } else {
          // Handle other states if needed
        }
      });
    });
  }

  void reloadView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(
            left: 0,
            top: MediaQuery.of(context).padding.bottom + 16,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                       
                        child: TextField(
                          
                          controller: productViewModel.searchBarController,
                          focusNode: searchBarFocusNode,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontSize: 10),
                          
                          onChanged: (value) {
                            print('Text changed: $value');
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 20,
                            ),
                            hintText: "Bạn muốn tìm gì?",
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          
                        ),
                        
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        print(
                            'Search Text: "${productViewModel.searchBarController.text.trim()}"');
                        if (productViewModel.searchBarController.text
                            .trim()
                            .isNotEmpty) {
                          List<Product> results =
                              await productViewModel.searchProduct(context);
                          if (results.isNotEmpty) {
                            print('Navigating to Product List');
                            navigateToProductList(results);
                          } else {
                            print('Search Product returned no results');
                          }
                        } else {
                          print('Empty search text, showing toast.');
                          CommonFunc.showToast(
                              "Vui lòng nhập từ khóa tìm kiếm.");
                        }
                      },
                      child: Text("Tìm kiếm"),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        CommonFunc.goToProfileScreen();
                      },
                      icon: const Icon(
                        Icons.account_circle_rounded,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 4,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 2.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Giấy",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            productViewModel.listGiay.isNotEmpty
                                ? listScrapByType(productViewModel.listGiay)
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Không có dữ liệu',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                            const Text(
                              "Nhựa",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            productViewModel.listNhua.isNotEmpty
                                ? listScrapByType(productViewModel.listNhua)
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Không có dữ liệu',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                            const Text(
                              "Kim loại",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            productViewModel.listKimLoai.isNotEmpty
                                ? listScrapByType(productViewModel.listKimLoai)
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Không có dữ liệu',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                            const Text(
                              "Thủy tinh",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            productViewModel.listKimLoai.isNotEmpty
                                ? listScrapByType(productViewModel.listThuytinh)
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Không có dữ liệu',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                            const Text(
                              "Khác",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            productViewModel.listGiayKhac.isNotEmpty
                                ? listScrapByType(productViewModel.listGiayKhac)
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Không có dữ liệu',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            width: 36,
            height: 36,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                goToCartScreen();
              },
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listScrapByType(List<Product> sendas) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sendas.length,
        itemBuilder: (context, index) {
          return ProductItemCustomerView(product: sendas[index]);
        },
      ),
    );
  }

  void goToCartScreen() {
    Navigator.push(
      navigationKey.currentContext!,
      MaterialPageRoute(builder: (context) => CartScreen()),
    );
  }

  // void navigateToProductDetail(Product product) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ProductDetailScreen(product: product),
  //     ),
  //   );
  // }
  // void navigateToProductDetail(Product product) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ProductDetailsScreen(product: product),
  //     ),
  //   );
  // }
  void navigateToProductList(List<Product> products) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductListScreen(products: products),
    ),
  );
}
}
