import 'package:flutter/material.dart';

import '../utils/mysize.dart';

class MyTransactions extends StatelessWidget {
  final String transactionName;
  final String ammount;
  final String expenseOrIncome;

  const MyTransactions(
      {super.key,
        required this.transactionName,
        required this.ammount,
        required this.expenseOrIncome,

      });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MySize.size5,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySize.size10),
        color: Colors.grey.shade100,


      ),
      padding: EdgeInsets.all(MySize.size10),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(MySize.size8),
                margin: EdgeInsets.only(right: MySize.size10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white,width: .3),
                  color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(3.0, 2.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3.0, -2.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                    ]
                ),
                child: Center(
                  child: Icon(
                    Icons.attach_money_outlined,
                    color:expenseOrIncome == 'expense' ? Colors.red:  Colors.green,
                  ),
                ),
              ),
              Text(transactionName.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w400,fontSize: MySize.size15)),
            ],
          ),
          Text(
            '${expenseOrIncome == 'expense' ? '-' : '+'}\$$ammount',
            style: TextStyle(
                color:
                    expenseOrIncome == 'expense' ? Colors.red : Colors.green.shade700),
          ),
        ],
      )),
    );
  }
}
