import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/main.dart';
import 'package:three_tapp_app/view/customer/cart/cart_screen.dart';
import 'package:three_tapp_app/view/product_details_screen.dart';
import 'package:three_tapp_app/viewmodel/auth_viewmodel.dart';
import '../../../model/product.dart';
import '../../../model/status.dart';
import '../../../utils/common_func.dart';
import '../../../viewmodel/product_viewmodel.dart';
import '../../common_view/product_item_customer_view.dart';
import 'package:badges/badges.dart' as badges;

import '../../common_view/product_list_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  ProductViewModel productViewModel = ProductViewModel();
  TextEditingController searchBarController = TextEditingController();
  FocusNode searchBarFocusNode = FocusNode();
  AuthViewModel authViewModel = AuthViewModel();
  User? user;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productViewModel.getAllProduct();
      productViewModel.getProductStream.listen((status) {
        if (status == Status.completed && mounted) {
          reloadView();
        }
      });
    });
  }

  void reloadView() {
    setState(() {});
  }

  Widget buildHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Xử lý khi nhấn vào IconButton
                  CommonFunc.goToProfileScreen();
                },
                icon: Icon(
                  Icons.account_circle_rounded,
                  color: Colors.blue,
                ),
              ),
              FutureBuilder<String>(
                future: AuthViewModel().getUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    String username = snapshot.data ?? "Unknown";
                    return Text(
                      'Xin chào, $username',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return CircularProgressIndicator(); // Show a loading indicator while fetching data
                  }
                },
              ),
            ],
          ),
          SizedBox(
            width: 36,
            height: 36,
            // child: FloatingActionButton(
            //   backgroundColor: Colors.white,
            //   onPressed: goToCartScreen,
            //   child: Icon(
            //     Icons.notifications,
            //     color: Colors.blue,
            //   ),
            // ),
          ),
        ],
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(),
                const SizedBox(height: 16),
                buildSearchBar(),
                const SizedBox(height: 16),
                Expanded(child: buildProductLists()),
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
              onPressed: goToCartScreen,
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

  Widget buildSearchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
            height:
                8.0), // Thêm khoảng trống giữa đỉnh màn hình và thanh tìm kiếm
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextField(
                    controller: productViewModel.searchBarController,
                    focusNode: searchBarFocusNode,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 16),
                    onChanged: (value) {
                      print('Text changed: $value');
                    },
                    onSubmitted: (value) async {
                      await onSearchSubmitted();
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: "Bạn muốn tìm gì?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await onSearchSubmitted();
                },
                child: Text("Tìm kiếm"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> onSearchSubmitted() async {
    print('Search Text: "${productViewModel.searchBarController.text.trim()}"');
    if (productViewModel.searchBarController.text.trim().isNotEmpty) {
      List<Product> results = await productViewModel.searchProduct(context);
      if (results.isNotEmpty) {
        print('Navigating to Product List');
        navigateToProductList(results);
      } else {
        print('Search Product returned no results');
      }
    } else {
      print('Empty search text, showing toast.');
      CommonFunc.showToast("Vui lòng nhập từ khóa tìm kiếm.");
    }
  }

 
// Inside _CustomerHomeScreenState class

Widget buildScrapTypeWithButton(String title, String imageUrl, List<Product> products) {
  return Column(
    children: [
      const SizedBox(height: 20),
      InkWell(
        onTap: () {
          // Call the navigation function for the specific scrap type
          navigateToScrapList(products, title);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Image.asset(
                imageUrl,
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

void navigateToScrapList(List<Product> products, String category) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductListScreen(products: products, category: category),
    ),
  );
}

Widget buildProductLists() {
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: Wrap(
      spacing: 40.0,
      runSpacing: 10.0,
      alignment: WrapAlignment.start,
      children: [
        buildScrapTypeWithButton("Giấy", "assets/images/paper.jpg", productViewModel.listGiay),
        buildScrapTypeWithButton("Nhựa", "assets/images/plastic.jpg", productViewModel.listNhua),
        buildScrapTypeWithButton("Kim loại", "assets/images/metal.jpg", productViewModel.listKimLoai),
        buildScrapTypeWithButton("Thủy tinh", "assets/images/glass.jpeg", productViewModel.listThuytinh),
        buildScrapTypeWithButton("Khác", "assets/images/other.jpg", productViewModel.listGiayKhac),
      ],
    ),
  );
}

Widget listScrapByType(List<Product> sendas) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.7, // Căn đều theo chiều cao của thiết bị
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

  void navigateToProductList(List<Product> products) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(products: products, category: '',),
      ),
    );
  }
}