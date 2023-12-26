import 'package:flutter/material.dart';

import '../utils/mysize.dart';

class AddExpenseButton extends StatelessWidget {
 final function;
  const AddExpenseButton({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        margin: EdgeInsets.only(top: MySize.size10),
        height: MySize.scaleFactorHeight * 70,
        width: MySize.scaleFactorWidth * 70,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                offset: const Offset(4.0, 4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-4.0, -4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
              ),
            ]
        ),
        child: Center(
            child: Icon(
              Icons.add,
              size: MySize.size30,
              color: Colors.black,
            )),
      ),
    );
  }
}
