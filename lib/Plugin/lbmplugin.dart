
import 'dart:async';
import 'dart:convert';


import 'package:http/http.dart' as http;
class LbmPlugin {
  // static const MethodChannel _channel =
  //     const MethodChannel('lbm_plugin');
  static Future<http.Response> platformVersion(String BaseUserURL,String PurchaseCode,String SecretKey) async {
    // final String version = await _channel.invokeMethod('getPlatformVersion');
    String BaseURL = "crmapi.lbmsolutions.in"; // Base Url
    String api_key =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoidGVzdCIsIm5hbWUiOiJ0ZXN0IiwicGFzc3dvcmQiOm51bGwsIkFQSV9USU1FIjoxNTk1NzM0NDM2fQ.rw5jGmbadmM5uS2pwH9VhsQN8cSvBFJoZuaEZliG9lQ";
    String SubUrl = "/api/CheckActivation";
    final paramDic = {
      "BaseUserURL": BaseUserURL.toString().trim(),
      "PurchaseCode": PurchaseCode.toString().trim(),
      "SecretKey": SecretKey.toString().trim(),

    };
    final uri = new Uri.https(BaseURL, SubUrl);

    var response = await http.post(uri,headers: {"Accept": "application/json",'authtoken': api_key},
        body: paramDic);
    return response;

  }

  static Future<http.Response> APIMainClass(
      String BaseURL,String SubURL, Map<String, dynamic> paramDic, String PostGet,String api_key) async {
                final uri = new Uri.https(BaseURL, SubURL, paramDic);

    switch(PostGet){
    //Get Method Work
      case "Get":
        final uri = new Uri.https(BaseURL, SubURL, paramDic);
        print("Get :"+uri.toString());
        var response = await http.get(uri, headers: {"Accept": "application/json",'authtoken': api_key});
        return response;
        break;

    //Post Method Work
      case "Post":
        final uri = new Uri.https(BaseURL, SubURL);
        print("Post :"+uri.toString());
        var response = await http.post(uri,headers: {"Accept": "application/json",'authtoken': api_key},
            body: paramDic);

        return response;
        break;

      case "Put":
        final uri = new Uri.https(BaseURL, SubURL);
        print("Put :"+uri.toString());
        var response = await http.post(uri,headers: {"Accept": "application/json",'authtoken': api_key},
            body: paramDic);

        return response;
        break;
      case "Delete":
        break;

    }
    //check the condition API post and get
//  if (PostGet == "Get") {
//    final uri = new Uri.https(APIClasses.BaseURL, SubURL, paramDic);
//    var response = await http.get(uri, headers: {"Accept": "application/json",'authtoken': APIClasses.api_key});
//    return response;
//  } else {
//
//    final uri = new Uri.https(APIClasses.BaseURL, SubURL);
//
//    var response = await http.post(uri,headers: {"Accept": "application/json",'authtoken': APIClasses.api_key},
//       body: paramDic);
//
//    return response;
//  }
return await http.post(uri,headers: {"Accept": "application/json",'authtoken': api_key},
            body: paramDic);
  }
}