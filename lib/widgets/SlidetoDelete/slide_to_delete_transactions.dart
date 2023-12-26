import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base/credentials/google_sheets_api.dart';
import '../../utils/mysize.dart';
import '../snackbar.dart';

class SlideableTransactions extends StatelessWidget {
  final String transactionName;
  final String ammount;
  final String expenseOrIncome;

  const SlideableTransactions({
    Key? key,
    required this.transactionName,
    required this.ammount,
    required this.expenseOrIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:MySize.size2),
        child: Center(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: MySize.size10),
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
                        border: Border.all(color: Colors.white, width: .3),
                        color: Colors.transparent
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.attach_money_outlined,
                          color: Colors.transparent
                        ),
                      ),
                    ),
                    SizedBox(width: MySize.size22,),
                    Text(
                      transactionName.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: MySize.size15,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${expenseOrIncome == 'expense' ? '-' : '+'}\$$ammount',
                  style: TextStyle(
                    color: expenseOrIncome == 'expense'
                        ? Colors.red
                        : Colors.green.shade700,
                  ),
                ),
              ],
    )
    )
        )
    );
  }
}

class CustomAlert extends StatefulWidget {
  final int index;
  final VoidCallback onDismissedCallback; // Callback function

  const CustomAlert({super.key,required this.index,
    required this.onDismissedCallback,
  });

  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
              MySize.size15)),
      elevation: 5,
      backgroundColor: Colors.white,
      surfaceTintColor:
      Colors.grey.shade100,
      shadowColor: Colors.white,
      title:  Text(
        "DELETE TRANSACTION?",
        style: TextStyle(
           letterSpacing: MySize.size4),
      ),
      titleTextStyle: TextStyle(fontSize: MySize.size24,color: Colors.red.shade300,fontWeight: FontWeight.w800),
      content: const Text(
          "Are you sure you want to delete this Transaction?"),
      contentTextStyle:TextStyle(fontSize: MySize.size18,color: Colors.grey.shade900,fontWeight: FontWeight.w300),
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(MySize
                          .size10))),
              backgroundColor:
              MaterialStatePropertyAll(
                  Colors.grey
                      .shade400)),
          onPressed: () {
            Navigator.of(context).pop(false);
            // Call the callback function when dismissed
            widget.onDismissedCallback();
          },
          child:  Text(
            "Cancel".toUpperCase(),
            style:  TextStyle(
                color: Colors.black,letterSpacing: MySize.size4),
          ),
        ),
        TextButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(MySize
                          .size10))),
              backgroundColor:
              MaterialStatePropertyAll(
                  Colors.red
                      .shade400)),
          onPressed: () async {
            Get.back();
            // Perform asynchronous work without updating the widget state
            bool isDeleted = await GoogleSheetsApi.deleteTransaction(widget.index + 1);

            // Check if the widget is still mounted before calling setState
            CustomSnackBar.show(
              message: isDeleted ? 'Transaction Deleted!' : 'Check Internet Connection and Try Again!',
              isError: !isDeleted,
            );

            widget.onDismissedCallback();
          },
          child:  Text(
            "Delete".toUpperCase(),
            style: TextStyle(
                color: Colors.black,letterSpacing: MySize.size3,fontWeight: FontWeight.w600),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}

