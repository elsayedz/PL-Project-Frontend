import 'package:http/http.dart' as http;

class ReqHandler {
  static const String DEV_BASE_URL = "http://127.0.0.1:3000";
  static const String PROD_BASE_URL =
      "https://premier-league-project.herokuapp.com";
  static const bool flag = false;
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    "Access-Control-Allow-Origin": "*"
  };

  static POST(var body, {String path = '', bool isDev = flag}) async {
    print('--------------- POST Request-----------------\n');

    var temp = isDev ? DEV_BASE_URL + path : PROD_BASE_URL + path;
    print('URL: $temp');
    print('Body: $body');
    print('---------------------------------------------\n');

    var req_url = Uri.parse(temp);

    var res = await http.post(req_url, headers: _headers, body: body);

    return res;
  }

  static GET({String path = '', bool isDev = flag}) async {
    print('--------------- GET Request-----------------\n');

    var temp = isDev ? DEV_BASE_URL + path : PROD_BASE_URL + path;
    print('URL: $temp');
    print('---------------------------------------------\n');

    var req_url = Uri.parse(temp);

    var res = await http.get(req_url, headers: _headers);

    return res;
  }
}
