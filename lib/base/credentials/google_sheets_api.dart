import 'package:flutter/foundation.dart';
import 'package:gsheets/gsheets.dart';

import '../../view/home_page.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "espensetracker2nd",
  "private_key_id": "de8c8cd170f0e80f13e3f9d214e2c57bec8ef554",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQD1P4gW0JFdtRyS\nYdrwY0Y5A3MmJcElRGmfS7l4ktPR/+GG0U7mqGPhEZSrHHQ/VpXD9BDBa5h7x5Lw\nWJIORM99FObIR8D/DghaQPqDGFSZimIDCZmc1ME7XzPLxkeX8SpWVesQR5oq/jcV\nI9QNeZSBcZmLpxGQJI3mY9QQZwQ4ystZzjs+VdW5ZJtajN0aVlvvE3PmI3cELMBS\n82hRZq/5Wa+BmZruberC2r/8WT4cF84uHKx586+bK+H6kpRk2SCibFRVSxX8iuSy\nLA0dbDeeTriPXg6Jui0R1u3Tn0VYY7pKqLgb18WE2S989swGt5D1bWOo9r3Z2RB7\nHpzsjjWtAgMBAAECggEABWxcfM6rbERRR65oykiTuLaKERWkJggTgt2IkjFDBGGR\ncesGgOTH4qYCIN+N9YmbYbwvs6tGsbQJ3I1E25JreTNhYBvwGWPMzPwjXgtHcabF\nAJaxgi2VQVQbX934XtSLMGIRguhmcR1yh+HlMlAWN9+UeulcotCgH7Bk8+DnT78n\nN1d3Ml5vvMoZbN8whh4zFAV44VEL8FjQWszXypsA339HaemKvK/zRii/6JxP8e7l\neFvEpsF7PVeG+mZ7eUa8NkHnmiHMLbyCnVwpLv0UBGOIZALgGIfwNowfZV1XNP1u\nOT9xMn6esMC7uSzcvcaAlSs52m+qJ1Rc7UgzqpazeQKBgQD9t4mCWpum2fKYcGFq\nrZwejbsxNRF/RN53qivspyGNBAMlXESOesWQrdQD4x/bSxiACfpRFKsba7TJ4QA0\nJTSC03wjW6/eP0qxBwjSO5ctEK3WW2kiBFq227uOXptfQfLc907QL0kasN93iM0O\n4vu/ljYi6/v0eNJhPKYsgVT6FQKBgQD3dHxbpre8R6ZCgubLnouo32o1CgXd40vd\nEEHWHZDgRoXZ/7cPJjXwKk6/vpE2Qkw0ysE+6F+WYWh27QVCqMwN2HTUt3ihDoR0\n32thimRMOeQMA/N96i+XsBBXuzBmcuOlE9GXYs7YKNJgIlcQAUoVs9yWP7yMWY9c\nar2xPV0rOQKBgG33P8Vc6ju+GRSTGNX420Ku4WRpgOTtf5LUEeenZLZO9+IYhKpQ\nchLMFKl+po8QlFTifjjoQWVIIHqjZ8gyG/lcGmDk22vzeLcTunIMW/CvWvkec4nH\n412ADWGeha8a0V2OXv2CkSfdY23WwDHklYKrY1lteK20NFLqy4dcou0lAoGAWRQt\n0DBr4/NG/ppwyswAKoKCkSVSh1XTcXjwuktaY+H/PUK4e1OeBx6zyoKnc4jaNgbn\nGeY8wr2+BVG9mwl4q2NIa2rAmfnH5OqolSxkfqw4U7r4ZFNxXoGa4HoaKkche8Nu\np7iCDX5kfQbfoHtWWAmvVscK8NssqHAkaTFV4MECgYEArf10aYgaDOk/CAxsUN4C\nEnPAoej5hbEfGFUeKN+cGF+uUwGxETTRZdvs39ObztMfEEiouOAWid6pp+5xLtSZ\nSd/VMwoihN+rUK5Vjewj3AYqMiOw0zGjQyrS9kJ2nCCrZkPVElL2Lhx57B9YmVlt\n/PoSTdbvsNCjxpAD0bvEYmg=\n-----END PRIVATE KEY-----\n",
  "client_email": "tracker1@espensetracker2nd.iam.gserviceaccount.com",
  "client_id": "116286988157384352907",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/tracker1%40espensetracker2nd.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

  // set up & connect to the spreadsheet
  static const _spreadsheetId = '1A5tlsBZkbMwJ8K_4W4sXALVFNtjlke6DV6ZOII5XdKQ';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // INITIALIZE THE SPREADSHEET AFTER USER IS INSIDE THE HOMEPAGE
  static Future<void> init(String email) async {

    final sheetTitle = email;
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle(sheetTitle);
    countRows();

  }
  static HomePageState? homePageState;


  // COUNT THE NUMBER OF RECORDS IN THE SHEET BASED ON ROWS
  static Future countRows() async {
    numberOfTransactions =0;
    while ((await _worksheet!.values
        .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // LOAD THE DATA FROM WITHIN THE ROWS INTO THE CURRENT TRANSACTIONS LIST
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
      await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
      await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
      await _worksheet!.values.value(column: 3, row: i + 1);

      currentTransactions.add([
        transactionName,
        transactionAmount,
        transactionType,
      ]);
    }
    if (kDebugMode) {
      print(currentTransactions);
    }
    // this will stop the circular loading indicator
    loading = false;
  }

  // INSERT A NEW ROW INTO THE SHEET WHENEVER THE USER ADDS A NEW TRANSACTION
  static Future insert(String name, String amount, bool isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
    if (kDebugMode) {
      print(currentTransactions);
    }
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }

  // DELETE A TRANSACTION BASED ON ITS LOCATION AND INDEX FROM THE SHEETS AS WELL AS THE LOCAL VARIABLE
  static Future<bool> deleteTransaction(int rowId) async {
    try {
      if (_worksheet == null || rowId <= 0 || rowId > numberOfTransactions) {
        // Return false if the deletion is not possible due to invalid parameters
        return false;
      }

      // Delete the row from the worksheet
      await _worksheet!.deleteRow(rowId + 1);

      // Update the local data
      currentTransactions.removeAt(rowId - 1);
      numberOfTransactions--;

      // Return true indicating successful deletion
      return true;
    } catch (e) {
      // Handle any potential errors during the deletion process
      if (kDebugMode) {
        print("Error deleting transaction: $e");
      }
      // Return false indicating unsuccessful deletion
      return false;
    }
  }

  //WHILE LOGGING IN CHECK IF THE USER HAS ANY SHEET AVAILABLE WITH HIS EMAIL OR NOT
  static Future<bool> isSheetAvailable(String sheetTitle) async {
    try {
      final ss = await _gsheets.spreadsheet(_spreadsheetId);
      final worksheet = ss.worksheetByTitle(sheetTitle);
      return worksheet != null;
    } catch (e) {
      if (kDebugMode) {
        print('Error during isSheetAvailable: $e');
      }
      // Handle the error as needed
      return false;
    }
  }

  // CLEAR ALL ROWS IN THE SHEET
  static Future<void> clearSheet() async {
    try {
      if (_worksheet != null) {
        await _worksheet!.clear();
        // Reset local data
        currentTransactions.clear();
        numberOfTransactions = 0;
        await _worksheet!.values.appendRow(['Expense', 'Amount', 'Expense/Income']);

        // Trigger a rebuild of the widget tree
        homePageState?.setState(() {});

      }
    } catch (e) {
      // Handle any potential errors during the clearing process
      if (kDebugMode) {
        print("Error clearing sheet: $e");
      }
    }
  }

}