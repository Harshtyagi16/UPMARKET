import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:upmarket/controller/image_sesrvice.dart';
import 'package:upmarket/controller/registerC.dart';

import '../models/details.dart';

class AddingService extends GetxController {
  RxList allData = <Details>[].obs;

  final imageService = Get.put(ImageService());
  final phoneAuth = Get.put(RegisterC());


  Future<void> addNameImage(Details details) async {
    String uid = phoneAuth.uid.value;
    String token = phoneAuth.verificationIDToken.value;
    final url = Uri.parse(
        "https://upmarket-e4066-default-rtdb.firebaseio.com/details/$uid.json?auth=$token");
    try {
      final request = await http.post(url,
          body: json.encode({
            "title": details.title,
            "downloadUrl": details.downloadUrl,
          }));
      allData.add(Details(id: json.decode(request.body)["name"], title: details.title, downloadUrl: details.downloadUrl));
      print('this is add ${request.body}');
      update();
    } catch (e) {}
  }

  Future<void> fetchDetails() async {
    String uid = phoneAuth.uid.value;
    String token = phoneAuth.verificationIDToken.value;
    final url = Uri.parse("https://upmarket-e4066-default-rtdb.firebaseio.com/details/$uid.json?auth=$token");
    try {
      final response = await http.get(url);
      print('this is fetch ${response.body}');
      final extractedDetails =
          json.decode(response.body) as Map<String, dynamic>?;
      if (extractedDetails == null) {
        return;
      }
      extractedDetails.forEach((key, value) {
        allData.add(Details(id: key,title: value["title"], downloadUrl: value["downloadUrl"]));
        update();
      });
    } catch (e) {
      print('something went wrong');
    }
  }

  Future<void> updateData({required String id,required Details newDetails})async{
    final existingDataIndex =allData.indexWhere((dataId) => dataId.id == id);
    String uid = phoneAuth.uid.value;
    String token = phoneAuth.verificationIDToken.value;
    final url = Uri.parse("https://upmarket-e4066-default-rtdb.firebaseio.com/details/$uid/$id.json?auth=$token");
    try{
      final request = await http.patch(url,body: json.encode({
        "title": newDetails.title,
        "downloadUrl": newDetails.downloadUrl,
      }));
      allData[existingDataIndex] = newDetails;
      update();
    }catch(e){
      print('went wrong');
    }
  }

  
  Future<void> deleteData(String id) async{
    final existingDataIndex =allData.indexWhere((dataId) => dataId.id == id);
    String uid = phoneAuth.uid.value;
    String token = phoneAuth.verificationIDToken.value;
    final url = Uri.parse("https://upmarket-e4066-default-rtdb.firebaseio.com/details/$uid/$id.json?auth=$token");
    allData.removeAt(existingDataIndex);
    update();
    try{
      final request =await http.delete(url);
      print(request.body);
      if(request.statusCode ==200){
        print('Deleted successfully');
      }
    }catch(e){
      print('went wrong');
    }

  }
}
