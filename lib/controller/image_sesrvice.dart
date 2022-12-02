import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebaseCore;
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

class ImageService extends GetxController {
  final firebaseStorage.FirebaseStorage storage =
      firebaseStorage.FirebaseStorage.instance;

  RxList imageUrl = <String>[].obs;
  RxList downloadUrlList = <String>[].obs;
  RxString downloadString = ''.obs;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      firebaseStorage.UploadTask uploadTask = storage.ref("test/$fileName").putFile(file);
      firebaseStorage.TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print("this is download url done - ${downloadUrl}");
      downloadString.value = downloadUrl;
      downloadUrlList.add(downloadUrl);
      update();

    } on firebaseCore.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebaseStorage.ListResult> listAllImage() async {
    firebaseStorage.ListResult results = await storage.ref("test").listAll();
    results.items.forEach((firebaseStorage.Reference ref) {
      imageUrl.add(ref.name);
      print(ref.name);
    });
    update();
    return results;
  }

  Future<String> viewImage(String imageName) async {
    String viewUrl = await storage.ref("test/$imageName").getDownloadURL();
    print("this is viewurl - ${viewUrl}");
    return viewUrl;
  }

  // Future<void> getImageUrl() async {
  //   for (int i = 0; i < imageUrl.length; i++) {
  //     String viewUrl = await storage.ref("${imageUrl[i]}").getDownloadURL();
  //     downloadUrl.add(viewUrl);
  //   }
  //   update();
  // }
}
