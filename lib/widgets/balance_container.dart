import 'package:etracker/utils/mysize.dart';
import 'package:flutter/material.dart';

class TopneuCard extends StatefulWidget {
  final String balance;
  final String income;
  final String expense;
  final String username;

  const TopneuCard(
      {super.key,
      required this.balance,
      required this.expense,
      required this.income,
      required this.username
      });

  @override
  State<TopneuCard> createState() => _TopneuCardState();
}

class _TopneuCardState extends State<TopneuCard> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MySize.size20,vertical: MySize.size10),
      height: MySize.size180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySize.scaleFactorHeight * 20),
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade50,width: .5),
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
          ]),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 widget.username.toUpperCase(),
                  style: TextStyle(
                      color: Colors.grey.shade400, fontSize: MySize.size20,letterSpacing: 5,fontWeight: FontWeight.w300),
                ),


              ],
            ),
            Text(
              'B A L A N C E ',
              style: TextStyle(
                  color: Colors.grey.shade600, fontSize: MySize.size17,fontWeight: FontWeight.w800),
            ),
            AnimatedValueText(double.parse(widget.balance), 'balance'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                        shape: const CircleBorder(),
                        child: Padding(
                          padding: EdgeInsets.all(MySize.size4),
                          child: Icon(
                            Icons.keyboard_double_arrow_up,
                            color: Colors.green,
                            size: MySize.size24,
                          ),
                        )),
                    SizedBox(
                      width: MySize.scaleFactorWidth * 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income',
                          style: TextStyle(
                              fontSize: MySize.size16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800),
                        ),
                        AnimatedValueText(
                            double.parse(widget.income), 'income'),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                        shape: const CircleBorder(),
                        child: Padding(
                          padding: EdgeInsets.all(MySize.size4),
                          child: Icon(
                            Icons.keyboard_double_arrow_down,
                            color: Colors.red,
                            size: MySize.size24,
                          ),
                        )),
                    SizedBox(
                      width: MySize.scaleFactorWidth * 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expense',
                          style: TextStyle(
                              fontSize: MySize.size16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800),
                        ),
                        AnimatedValueText(
                            double.parse(widget.expense), 'expense'),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedValueText extends StatelessWidget {
  final double value;
  final String property;

  const AnimatedValueText(this.value, this.property, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = MySize.size16; // Default font size
    Color color = Colors.grey.shade800;
    if (property == 'balance') {
      fontSize = MySize.size40;
    }
    if (property == 'income') {
      color = Colors.green;
    } else if (property == 'expense') {
      color = Colors.red;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: const Duration(seconds: 1),
      builder: (context, double val, child) {
        return Text(
          '\$${val.toStringAsFixed(0)}',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
          ),
        );
      },
    );
  }
}
