//import 'dart:convert';
//import 'models/mechanic_model.dart';
//class Services{
//  static const String url = 'https://jsonplaceholder.typicode.com/photos';
//
//  static Future<List<Album>> getPhotos() async {
//    try{
//      final response = await http.get(url);
//      if(response.statusCode==200){
//        List<Album> album = parsePhotos(response.body);
//        return album;
//      }else{
//        throw Exception('error');
//      }
//    }catch(e){
//      throw Exception(e.toString());
//    }
//  }
//  static List<Album> parsePhotos(responseBody){
//    final jsonData = json.decode(responseBody);
//    return jsonData.map<Album>((json)=>  Album.fromJson(json)).toList();
//  }
//}
