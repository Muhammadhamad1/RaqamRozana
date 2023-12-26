import 'dart:async';
import 'package:etracker/base/credentials/google_sheets_api.dart';
import 'package:etracker/utils/mysize.dart';
import 'package:etracker/widgets/balance_container.dart';
import 'package:etracker/widgets/laoding_data.dart';
import 'package:etracker/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../widgets/SlidetoDelete/slide_to_delete_transactions.dart';
import '../widgets/add_button.dart';

class HomePage extends StatefulWidget {
  static final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();

  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static HomePageState? homePageState;

  static final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();

  late Future<SharedPreferences> credentials;
  String email = "";
  String name = "";

  @override
  void initState() {
    super.initState();

    // Retrieve SharedPreferences instance
    credentials = SharedPreferences.getInstance();

    // Fetch username and name from SharedPreferences
    credentials.then((prefs) {
      setState(() {
        email = prefs.getString('email') ?? "";
        name = prefs.getString('name') ?? "";

        // Initialize Google Sheets API with the retrieved username
        GoogleSheetsApi.init(email);
      });
    });
    HomePage.homePageKey.currentState?.setHomePageState(this);

  }
  void setHomePageState(HomePageState state) {
    homePageState = state;
  }


  // collect user input
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  // enter the new transaction into the spreadsheet
  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
    );
    setState(() {});
  }
  Future<bool> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title:  Text('Confirmation',style: TextStyle(
              letterSpacing: MySize.size4),),
          titleTextStyle: TextStyle(fontSize: MySize.size24,color: Colors.red.shade400,fontWeight: FontWeight.w800),
          content: const Text('Are you sure you want to remove all data?'),
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
                Navigator.of(context).pop(false); // Cancelled
              },
              child:  Text('Cancel',style:  TextStyle(
                  color: Colors.black,letterSpacing: MySize.size4),),
            ),
            TextButton( style: ButtonStyle(
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
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmed
              },
              child:  Text('Yes',style:  TextStyle(
        color: Colors.black,letterSpacing: MySize.size4),),
            ),
          ],
        );
      },
    ) ?? false; // Return false if the dialog is dismissed
  }


  /// **********  A D D       N E W    E X P E N S E     *********
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                backgroundColor: Colors.grey.shade200,
                title: const Center(child: Text('NEW TRANSACTION')),
                titleTextStyle: TextStyle(
                    fontSize: MySize.size20,
                    color: Colors.grey.shade500,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Expense',
                            style: TextStyle(
                                color: _isIncome == false
                                    ? Colors.red
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.bold),
                          ),
                          Transform.scale(
                            scale: .6,
                            // Set the scale factor according to your needs
                            child: Switch(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              activeColor: Colors.grey.shade700,
                              inactiveThumbColor: Colors.red.shade400,
                              value: _isIncome,
                              onChanged: (newValue) {
                                setState(() {
                                  _isIncome = newValue;
                                });
                              },
                            ),
                          ),
                          Text(
                            'Income',
                            style: TextStyle(
                                color: _isIncome == true
                                    ? Colors.green
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySize.size5,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(MySize.size20)),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.circular(MySize.size20)),
                                hintText: _isIncome == true
                                    ? 'Income Name'
                                    : 'Expense Name',
                              ),
                              controller: _textcontrollerITEM,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return _isIncome == true
                                      ? 'Enter an Income title'
                                      : 'Enter an expense title';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: MySize.size5,
                            ),
                            TextFormField(
                              inputFormatters: [NumericInputFormatter()],
                              decoration: InputDecoration(
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(MySize.size20)),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.circular(MySize.size20)),
                                hintText: 'Amount',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return _isIncome == true
                                      ? 'Enter an Income amount'
                                      : 'Enter an expense amount';
                                }
                                return null;
                              },
                              controller: _textcontrollerAMOUNT,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MySize.size10)),
                    color: Colors.grey[500],
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MySize.size10)),
                    color: Colors.grey[500],
                    child: const Text('Enter',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        _textcontrollerITEM.clear();
                        _textcontrollerAMOUNT.clear();
                        CustomSnackBar.show(
                          message: _isIncome ==true
                              ?'New Income Added'
                          :'New Expense Added',
                          isError: false, // Set to true for red color, false for green color
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  bool timerStared = false;

  ///*********    L O A D    D A T A    F R O M     D A T A B A S E     ******
  void startLoading() {
    timerStared = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }else {
        setState(() {

      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //start loading
    if (GoogleSheetsApi.loading == true && timerStared == false) {
      CustomSnackBar.show(
        message: 'Loading Data....',
        isError: false,
      );
      startLoading();
    }
    return Scaffold(
      key: homePageKey,
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(MySize.size20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  bool confirmed = await showConfirmationDialog(context);
                  if (confirmed) {
                    GoogleSheetsApi.clearSheet();
                    setState(() {});
                    CustomSnackBar.show(
                      isError: false,
                      message: 'All Data removed Successfully!',
                    );
                    startLoading();
                  }
                },
                child: TopneuCard(
                  balance: (GoogleSheetsApi.calculateIncome() -
                          GoogleSheetsApi.calculateExpense())
                      .toString(),
                  income: GoogleSheetsApi.calculateIncome().toString(),
                  expense: GoogleSheetsApi.calculateExpense().toString(),
                  username: name,
                ),
              ),
              Expanded(
                  child: Container(
                      child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: MySize.size20,
                    ),
                    Expanded(
                        child: GoogleSheetsApi.loading == true
                            ? const LoadingData()
                            : GoogleSheetsApi.currentTransactions.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: MySize.size35,),

                              Text(
                                'Your expense history is currently empty. Begin documenting your spending.',
                                style: TextStyle(fontSize: MySize.size20,color: Colors.grey.shade600),textAlign: TextAlign.center,
                              ),
                              Text(
                                'Click here to add new expenses',
                                style: TextStyle(fontSize: MySize.size20,color: Colors.grey.shade800,fontWeight: FontWeight.w300),textAlign: TextAlign.center,
                              ),

                            ],
                          ),
                        )
                        : ListView.builder(
                                itemCount:
                                    GoogleSheetsApi.currentTransactions.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      // Dismissible(
                                      //   confirmDismiss: (direction) async {
                                      //     return await showDialog(
                                      //       context: context,
                                      //       builder: (BuildContext context) {
                                      //         return AlertDialog(
                                      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.size15)),
                                      //           elevation: 5,
                                      //           backgroundColor: Colors.white,
                                      //           surfaceTintColor: Colors.grey.shade100,
                                      //           shadowColor: Colors.white,
                                      //           title: const Text("D  E  L  E  T  E",style: TextStyle(fontWeight: FontWeight.w600),),
                                      //           content: const Text("Are you sure you want to delete this Transaction?"),
                                      //           actions: <Widget>[
                                      //             TextButton(
                                      //               style: ButtonStyle(
                                      //                   shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.size10))),
                                      //                   backgroundColor: MaterialStatePropertyAll(Colors.grey.shade400)),
                                      //               onPressed: () => Navigator.of(context).pop(false),
                                      //               child: const Text("Cancel",style: TextStyle(color: Colors.black),),
                                      //             ),
                                      //             TextButton(
                                      //               style: ButtonStyle(
                                      //                   shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.size10))),
                                      //                   backgroundColor: MaterialStatePropertyAll(Colors.red.shade300)),
                                      //               onPressed: () => Navigator.of(context).pop(true),
                                      //               child: const Text("Delete",style: TextStyle(color: Colors.black),),
                                      //             ),
                                      //
                                      //           ],
                                      //         );
                                      //       },
                                      //     );
                                      //   },
                                      //   key: UniqueKey(),
                                      //   onDismissed: (direction) {
                                      //     setState(() {
                                      //       GoogleSheetsApi.deleteTransaction(index + 1);
                                      //       startLoading();
                                      //     });
                                      //     ScaffoldMessenger.of(context).removeCurrentSnackBar(); // Use ScaffoldMessenger
                                      //
                                      //   },
                                      //   background: Container(decoration: BoxDecoration(
                                      //     color: Colors.red.shade200,
                                      //     borderRadius: BorderRadius.circular(MySize.size15),
                                      //   ),
                                      //   padding:EdgeInsets.all(MySize.size15),
                                      //   child: const Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       Icon(Icons.delete_forever_outlined),
                                      //       Icon(Icons.delete_forever_outlined)
                                      //     ],
                                      //   ),),
                                      //   child:
                                      SlideAction(
                                        onSubmit: () async {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomAlert(index: index,onDismissedCallback: startLoading,);
                                            },
                                          );
                                        },
                                        submittedIcon: Icon(
                                          Icons.delete_sweep_outlined,
                                          color: Colors.red,
                                          size: MySize.size35,
                                        ),
                                        reversed: false,
                                        elevation: 1,
                                        animationDuration: const Duration(milliseconds: 200),
                                        sliderButtonIconPadding: MySize.size8,
                                        sliderButtonYOffset: MySize.size8,
                                        height: MySize.scaleFactorHeight * 65,
                                        sliderRotate: true,
                                        borderRadius: MySize.size20,
                                        innerColor: Colors.grey.shade200,

                                        outerColor: Colors.grey.shade100,

                                        sliderButtonIcon: Icon(
                                          Icons.attach_money_outlined,
                                          color: GoogleSheetsApi
                                                          .currentTransactions[
                                                      index][2] ==
                                                  'expense'
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                        sliderButtonIconSize: MySize.size18,
                                        child: SlideableTransactions(
                                          transactionName: GoogleSheetsApi
                                              .currentTransactions[index][0],
                                          ammount: GoogleSheetsApi
                                              .currentTransactions[index][1],
                                          expenseOrIncome: GoogleSheetsApi
                                              .currentTransactions[index][2],
                                        ),
                                      ),
                                      SizedBox(
                                        height: MySize.size10,
                                      ),
                                    ],
                                  );
                                }))
                  ],
                ),
              ))),
              AddExpenseButton(function: _newTransaction),
            ],
          ),
        ),
      ),
    );
  }
}

class NumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove non-numeric characters from the entered text
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Ensure the range is within bounds
    int newSelection = newValue.selection.baseOffset;
    if (newSelection > newText.length) {
      newSelection = newText.length;
    }

    // Create a new TextEditingValue with only numeric characters
    TextEditingValue updatedValue = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelection),
    );

    return updatedValue;
  }
}
