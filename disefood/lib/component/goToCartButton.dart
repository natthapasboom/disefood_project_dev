// import 'package:disefood/model/cart.dart';
// import 'package:flutter/material.dart';

// class GoToCartButton extends StatefulWidget {
//   // final VoidCallback readSQLite;

//   // const GoToCartButton({
//   //   Key key,
//   //   @required this.readSQLite,
//   // });

//   @override
//   _GoToCartButtonState createState() => _GoToCartButtonState();
// }

// class _GoToCartButtonState extends State<GoToCartButton> {
//   bool isCartNotEmpty = false;
//   // VoidCallback readSQLite;
//   List<CartModel> cartModels = List();

//   @override
//   void initState() {
//     readSQLite();
//     setState(() {
//     });
//     super.initState();
//   }

//       checkEmptyCart();

//   void checkEmptyCart() {
//     print(cartModels.length);
//     if (cartModels.length == 0) {
//       setState(() {
//         isCartNotEmpty = false;
//       });
//     } else {
//       setState(() {
//         isCartNotEmpty = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: isCartNotEmpty,
//       child: Stack(
//         children: [
//           FloatingActionButton(
//             onPressed: () {
//               // Add your onPressed code here!
//             },
//             child: Icon(
//               Icons.shopping_bag,
//               color: Colors.white,
//             ),
//             backgroundColor: Colors.orange,
//           ),
//           Positioned(
//             right: 11,
//             top: 11,
//             child: new Container(
//               padding: EdgeInsets.all(2),
//               decoration: new BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               constraints: BoxConstraints(
//                 minWidth: 14,
//                 minHeight: 14,
//               ),
//               child: Text(
//                 '1',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 8,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
