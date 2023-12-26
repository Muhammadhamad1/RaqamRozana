import 'package:gsheets/gsheets.dart';

class GoogleSheetsRegister {
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

//WHILE SIGN UP CREATE A NEW SHEET FOR THE USER WITH THE TITLE ASSOCIATED WITH USER'S EMAIL
  static Future setupUserSheet(String email) async {
    try {
      final sheetTitle = email;

      final ss = await _gsheets.spreadsheet(_spreadsheetId);

// Try to get the worksheet by title
      Worksheet? worksheet = ss.worksheetByTitle(sheetTitle);
      print('Worksheet Exist with the name $email');

// If the worksheet doesn't exist, create it
      if (worksheet == null) {
        worksheet = await ss.addWorksheet(sheetTitle);
        await worksheet.values
            .appendRow(['Expense', 'Amount', 'Expense/Income']);
      }
    } catch (e) {
      print('Error during setupUserSheet: $e');
// Optionally, you can rethrow the exception if you want the error to propagate further.
// rethrow;
    }
  }
}
