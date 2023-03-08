import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper_verse_admin/resources/storage_res.dart';

class FirestoreRes {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Upload Image Url to FirebaseFirestore.
  Future<String> uploadUrl(
      Uint8List imagefile, String pathName, String name) async {
    String status = 'Some error occured';
    try {
      //Call the method of uploadImage from StorageRes.
      String imageUrl =
          await StorageRes().uploadImageToStorage(imagefile, pathName);
      //Add the Data to firestore.
      _firebaseFirestore.collection(pathName).add({
        'imageUrl': imageUrl,
        'name': name,
      });
      status = 'success';
    } catch (error) {
      status = 'error while uploading image!';
    }
    return status;
  }
}
